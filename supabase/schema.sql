-- Supabase Schema for Truthprenuer

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- PROFILES TABLE (Mirrors our User model)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    role TEXT NOT NULL DEFAULT 'Founder',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- VALIDATIONS TABLE (Mirrors our ValidationRequest model)
CREATE TABLE validations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    hypothesis TEXT NOT NULL,
    target_audience TEXT NOT NULL,
    industry TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft',
    upvotes INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- VALIDATION QUESTIONS TABLE
CREATE TABLE validation_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    validation_id UUID NOT NULL REFERENCES validations(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL, -- e.g., 'multiple_choice', 'text', 'scale'
    options JSONB, -- Array of strings for multiple choice
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- EVIDENCE ITEMS TABLE (Mirrors EvidenceItem model)
CREATE TABLE evidence_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    validation_id UUID NOT NULL REFERENCES validations(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    type TEXT NOT NULL, -- 'interview', 'survey', 'data', 'other'
    summary TEXT NOT NULL,
    confidence_score INTEGER NOT NULL CHECK (confidence_score >= 1 AND confidence_score <= 100),
    key_insight TEXT NOT NULL,
    tags JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Set up Row Level Security (RLS)

-- Profiles: Anyone can view, only owners can update
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone." ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile." ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile." ON profiles FOR UPDATE USING (auth.uid() = id);

-- Validations: Anyone can view, only owners can insert/update
ALTER TABLE validations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Validations are viewable by everyone." ON validations FOR SELECT USING (true);
CREATE POLICY "Users can insert their own validations." ON validations FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Users can update own validations." ON validations FOR UPDATE USING (auth.uid() = author_id);

-- Validation Questions: Viewable by everyone, insert/update by validation owner
ALTER TABLE validation_questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Validation questions are viewable by everyone." ON validation_questions FOR SELECT USING (true);
CREATE POLICY "Owners can insert questions." ON validation_questions FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Owners can update questions." ON validation_questions FOR UPDATE USING (
    EXISTS (SELECT 1 FROM validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);

-- Evidence Items: Viewable by everyone, insert/update by validation owner
ALTER TABLE evidence_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Evidence items are viewable by everyone." ON evidence_items FOR SELECT USING (true);
CREATE POLICY "Owners can insert evidence." ON evidence_items FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Owners can update evidence." ON evidence_items FOR UPDATE USING (
    EXISTS (SELECT 1 FROM validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);

-- Function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, username, role)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'username', 'Founder');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to automatically create profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
