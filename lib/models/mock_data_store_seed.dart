import 'package:taeed_flutter/models/models.dart';
import 'package:taeed_flutter/models/mock_data_store.dart';
import 'package:taeed_flutter/models/startup_health_models.dart';

void seedData(MockDataStore store) {
  final now = DateTime.now();

  // ── Users ───────────────────────────────────────────────────────────
  final u1 = User(
    id: "u1",
    name: "Alex Rivera",
    username: "alexrivera",
    bio: "Building the future, one validated idea at a time. Ex-YC. Obsessed with founder psychology.",
    role: "Founder & CEO",
    website: "https://alexrivera.io",
    twitterHandle: "@alexrivera",
    skills: ["Vision", "Fundraising", "GTM"],
    location: "San Francisco, CA",
    validationsCount: 24,
    validationsCompleted: 42,
    helpfulnessScore: 0.98,
    joinedDate: now.subtract(const Duration(days: 180)),
    isVerified: true,
  );

  final u2 = User(
    id: "u2",
    name: "Priya Sharma",
    username: "priyabuilds",
    bio: "Product designer turned founder. I make complex things feel effortless. @Linear alum.",
    role: "Designer / Founder",
    website: "https://priyabuilds.design",
    twitterHandle: "@priyabuilds",
    skills: ["Design Systems", "SwiftUI", "Figma"],
    location: "London, UK",
    validationsCount: 18,
    validationsCompleted: 36,
    helpfulnessScore: 0.96,
    joinedDate: now.subtract(const Duration(days: 240)),
    isVerified: true,
  );

  final u3 = User(
    id: "u3",
    name: "Marcus Webb",
    username: "marcuswebb",
    bio: "Growth hacker. Built 3 SaaS products past \$1M ARR. Currently: NeuralCart. Ask me about PLG.",
    role: "Growth Lead",
    website: "https://marcuswebb.co",
    twitterHandle: "@mwebb",
    skills: ["Growth", "SEO", "Paid Ads"],
    location: "Austin, TX",
    validationsCount: 31,
    validationsCompleted: 29,
    helpfulnessScore: 0.94,
    joinedDate: now.subtract(const Duration(days: 90)),
  );

  final u4 = User(
    id: "u4",
    name: "Sana Khan",
    username: "sanakhan",
    bio: "Full-stack engineer building AI tooling for non-technical founders. Open to co-founder conversations.",
    role: "Engineer / Builder",
    twitterHandle: "@sanakhandev",
    skills: ["React", "Python", "Postgres"],
    location: "Dubai, UAE",
    validationsCount: 12,
    validationsCompleted: 21,
    helpfulnessScore: 0.91,
    joinedDate: now.subtract(const Duration(days: 60)),
  );

  final u5 = User(
    id: "u5",
    name: "Jordan Lee",
    username: "jordanlee",
    bio: "Solo founder. Shipped 6 products, 2 profitable. Blogging about the journey at jordanlee.blog",
    role: "Solo Founder",
    website: "https://jordanlee.blog",
    twitterHandle: "@jordanlee",
    skills: ["No-code", "Marketing", "Automation"],
    location: "Toronto, CA",
    validationsCount: 9,
    validationsCompleted: 18,
    helpfulnessScore: 0.89,
    joinedDate: now.subtract(const Duration(days: 30)),
  );

  final me = User(
    id: "me",
    name: "Jane Designer",
    username: "jane_ui",
    bio: "UX Architect & Product Thinker. Currently building @TAEED. Validation-first mindset.",
    role: "UX Architect",
    website: "https://janedesigner.io",
    twitterHandle: "@jane_ui",
    skills: ["UX", "SwiftUI", "Research", "Design Systems"],
    location: "New York, NY",
    validationsCount: 16,
    validationsCompleted: 25,
    helpfulnessScore: 0.95,
    joinedDate: now.subtract(const Duration(days: 365)),
    isVerified: true,
  );

  final u6 = User(
    id: "u6",
    name: "Carlos Ruiz",
    username: "carlosruiz",
    bio: "FinTech operator. 8 years in banking, now building what banks should have been.",
    role: "FinTech Founder",
    twitterHandle: "@carlosruizfin",
    skills: ["FinTech", "Compliance", "Sales"],
    location: "Miami, FL",
    validationsCount: 7,
    joinedDate: now.subtract(const Duration(days: 120)),
  );

  final u7 = User(
    id: "u7",
    name: "Nadia Osei",
    username: "nadiaosei",
    bio: "Community builder at heart. Founded 3 online communities, now productizing community itself.",
    role: "Community Founder",
    website: "https://nadiaosei.com",
    twitterHandle: "@nadiaosei",
    skills: ["Community", "Content", "Discord"],
    location: "Berlin, DE",
    validationsCount: 22,
    joinedDate: now.subtract(const Duration(days: 200)),
  );

  final aiMentor = User(
    id: "ai_mentor",
    name: "TAEED AI Mentor",
    username: "aimentor",
    bio: "Your 24/7 AI Startup Advisor. Ask me about product validation, PMF signals, pitch deck critiques, and GTM strategy.",
    role: "AI Startup Advisor",
    website: "https://taeed.ai",
    twitterHandle: "@taeed_ai",
    skills: ["Validation Critique", "GTM Strategy", "Pitch Decks", "PMF Diagnosis"],
    location: "Always Online",
    validationsCount: 1540,
    joinedDate: now.subtract(const Duration(days: 500)),
    isVerified: true,
  );

  store.users = [aiMentor, u1, u2, u3, u4, u5, me, u6, u7];
  store.currentUser = me;

  // ── Validations ─────────────────────────────────────────────────────
  store.validations = [
    ValidationRequest(
      id: "v1",
      title: "A platform to validate startup ideas before building",
      problem: "Founders spend months building products nobody wants. They get feedback only from friends and family — who almost always say yes.",
      solution: "A community platform where aspiring founders pitch ideas, get structured async feedback from a curated peer network, and find validated co-founders.",
      targetAudience: "Aspiring entrepreneurs, indie hackers, developers, designers.",
      authorId: "me",
      upvotes: 342,
      commentsCount: 3,
      isUpvoted: false,
      createdAt: now.subtract(const Duration(days: 2)),
      tags: ["Community", "Validation", "SaaS"],
      views: 1204,
    ),
    ValidationRequest(
      id: "v2",
      title: "AI-powered personal assistant for busy professionals",
      problem: "Managing emails, scheduling, and to-do lists eats 3+ hours of every professional's day.",
      solution: "An AI agent that integrates with email + calendar to auto-triage, draft responses, and schedule proactively.",
      targetAudience: "Executives, freelancers, small business owners.",
      authorId: "u1",
      upvotes: 287,
      commentsCount: 2,
      isUpvoted: true,
      isBookmarked: true,
      createdAt: now.subtract(const Duration(days: 5)),
      tags: ["AI", "Productivity", "B2B"],
      views: 891,
    ),
    ValidationRequest(
      id: "v3",
      title: "B2B procurement intelligence with LLMs",
      problem: "Enterprise procurement teams waste 40% of their time manually searching for vendor data across fragmented platforms.",
      solution: "NeuralCart: An AI-powered procurement intelligence layer that surfaces vendor insights in real time, integrated into existing ERP workflows.",
      targetAudience: "Procurement managers, CFOs, operations teams at mid-market companies.",
      authorId: "u3",
      upvotes: 198,
      commentsCount: 1,
      isUpvoted: false,
      createdAt: now.subtract(const Duration(days: 3)),
      tags: ["AI", "B2B", "Enterprise"],
      views: 567,
    ),
    ValidationRequest(
      id: "v4",
      title: "Community-first mental health app for founders",
      problem: "Founder burnout is an invisible epidemic. Existing mental health apps are designed for general audiences — not the unique pressures of startup life.",
      solution: "A peer-support platform where founders anonymously share mental health challenges, track mood, and access founder-specific coping playbooks.",
      targetAudience: "Startup founders, solo builders, early team members.",
      authorId: "u2",
      upvotes: 512,
      commentsCount: 4,
      isUpvoted: false,
      isBookmarked: true,
      createdAt: now.subtract(const Duration(days: 1)),
      tags: ["MentalHealth", "Community", "HealthTech"],
      views: 2100,
    ),
    ValidationRequest(
      id: "v5",
      title: "Micro-pension platform for gig economy workers",
      problem: "250M+ gig workers globally have zero retirement savings infrastructure. Traditional pension platforms are built for salaried employees.",
      solution: "A mobile-first micro-pension platform that auto-invests a percentage of every gig payout into diversified portfolios.",
      targetAudience: "Uber/DoorDash drivers, Fiverr freelancers, Upwork contractors.",
      authorId: "u6",
      upvotes: 431,
      commentsCount: 2,
      isUpvoted: true,
      createdAt: now.subtract(const Duration(days: 7)),
      tags: ["FinTech", "GigEconomy", "Social Impact"],
      views: 1587,
    ),
    ValidationRequest(
      id: "v6",
      title: "Open-source Notion alternative for technical teams",
      problem: "Notion is too slow, proprietary, and enterprise-priced for small technical teams that want control over their data.",
      solution: "A self-hostable, open-source workspace built on markdown, Git-native version history, and plugin-first architecture.",
      targetAudience: "Developer teams, open-source communities, privacy-first organizations.",
      authorId: "u4",
      upvotes: 765,
      commentsCount: 5,
      isUpvoted: false,
      createdAt: now.subtract(const Duration(days: 10)),
      tags: ["OpenSource", "Productivity", "Developer Tools"],
      views: 4302,
    ),
  ];

  // ── Comments ─────────────────────────────────────────────────────────
  store.comments = [
    Comment(id: "c1", validationId: "v1", authorId: "u1", authorName: "Alex Rivera", authorRole: "Founder", text: "Great idea! Focused feedback loops are what most founders are missing. Have you considered async video feedback to improve depth?", timestamp: "1d ago", likes: 24),
    Comment(id: "c2", validationId: "v1", authorId: "u2", authorName: "Priya Sharma", authorRole: "Designer", text: "The UX challenge here is huge — how do you make structured feedback feel lightweight? Would love to help with this.", timestamp: "2h ago", likes: 11),
    Comment(id: "c3", validationId: "v1", authorId: "u3", authorName: "Marcus Webb", authorRole: "Growth", text: "This is literally what I needed 2 years ago. The go-to-market plays itself: target YC-rejected founders.", timestamp: "30m ago", likes: 8),
    Comment(id: "c4", validationId: "v2", authorId: "u4", authorName: "Sana Khan", authorRole: "Engineer", text: "What's your differentiator vs Notion AI or Copilot? The integration layer is key.", timestamp: "4h ago", likes: 15),
    Comment(id: "c5", validationId: "v2", authorId: "u5", authorName: "Jordan Lee", authorRole: "Solo Founder", text: "This market is crowded. What's the wedge? Calendar integration is a commodity now.", timestamp: "6h ago", likes: 7),
    Comment(id: "c6", validationId: "v4", authorId: "me", authorName: "Jane Designer", authorRole: "UX Architect", text: "This is deeply needed. Anonymity is the right call. How will you combat misuse?", timestamp: "3h ago", likes: 19),
    Comment(id: "c7", validationId: "v4", authorId: "u7", authorName: "Nadia Osei", authorRole: "Community Founder", text: "Community moderation will make or break this. Happy to advise — been there.", timestamp: "1h ago", likes: 31),
  ];

  // ── Posts (social) ────────────────────────────────────────────────────
  store.posts = [
    PostItem(
      id: "p1", authorId: "u1",
      title: "How I got our first 500 users with \$0 marketing",
      body: "Thread: No ads. No PR. Just these 7 distribution plays that compounded over 60 days...\n\n1. Reddit: Find the subreddits where your exact user hangs out.\n2. Twitter: Don't just post — reply to 50 posts a day in your niche.\n3. Cold DMs: Personalized, 3-sentence max, always lead with value.\n4. Product Hunt: The night-before game matters more than the launch itself.\n5. Developer communities: Hacker News Show HN is still underrated.\n6. Newsletter swaps: Find newsletters with 2-10k subs — they're desperate for content.\n7. Founders helping founders: Reciprocity is the cheat code.",
      tags: ["Growth", "Distribution", "Startup"], likes: 847, commentsCount: 63, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 1)),
    ),
    PostItem(
      id: "p2", authorId: "u2",
      title: "Why your design system is killing your startup",
      body: "Hot take: Most early-stage startups have NO business building a full design system.\n\nHere's why — and what to do instead:\n\nA design system is leverage. But leverage only matters when you have repeating patterns. In the first 6 months, everything changes. Your ICP shifts. Your flows get rebuilt 3 times. Your brand evolves.\n\nInstead, do this:\n✅ 3 typography scales\n✅ 1 primary color + 2 neutrals  \n✅ 4 spacing values\n✅ A card component\n✅ A button component\n\nThat's it. The rest is premature optimization.",
      tags: ["Design", "Startups", "ProductThinking"], likes: 1204, commentsCount: 89, isLiked: true, isBookmarked: true, createdAt: now.subtract(const Duration(hours: 6)),
    ),
    PostItem(
      id: "p3", authorId: "u7",
      title: "The community building playbook that actually works in 2026",
      body: "I've built 3 communities past 10K members. Here's the framework:\n\n**Phase 1 (0–100 members): Concierge everything.**\nManually DM every member. Host weekly calls. You ARE the value.\n\n**Phase 2 (100–1K members): Surface the lurkers.**\nCreate rituals. Weekly intros. Monthly spotlights. Make participation feel safe.\n\n**Phase 3 (1K+ members): Distribute leadership.**\nIdentify your top 10 contributors. Give them titles, early access, and responsibility.\n\nThe mistake everyone makes: Jumping to Phase 3 before earning Phase 1.",
      tags: ["Community", "Growth", "BuildInPublic"], likes: 2391, commentsCount: 142, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(hours: 12)),
    ),
    PostItem(
      id: "p4", authorId: "u4",
      title: "I built an AI feature that our users hate — here's what I learned",
      body: "We shipped AI-generated summaries for our document tool. 6 weeks of work. The result: 12% of users tried it. 3% used it more than once.\n\nWhat went wrong:\n\n❌ We solved a problem users didn't feel.\n❌ The output quality wasn't trustworthy enough.\n❌ We buried it 3 clicks deep.\n❌ We never watched a user actually use it.\n\nWe pulled the feature. Spent the next 2 weeks talking to 40 users about what they actually needed. Built a different, smaller thing in 3 days. 68% activation rate.\n\nDo less. Watch more.",
      tags: ["AI", "ProductLessons", "BuildInPublic"], likes: 3102, commentsCount: 218, isLiked: true, isBookmarked: true, createdAt: now.subtract(const Duration(days: 2)),
    ),
    PostItem(
      id: "p5", authorId: "me",
      title: "What 'design-first' actually means (it's not what you think)",
      body: "Every founder says they're 'design-first.' Almost none of them are.\n\nDesign-first doesn't mean:\n❌ Pretty UI\n❌ Nice fonts\n❌ A Dribbble-worthy landing page\n\nDesign-first means:\n✅ Starting with the user's mental model, not your solution\n✅ Prototyping before a single line of code\n✅ Making decisions based on what reduces friction, not what looks cool\n✅ Treating copy as a design tool\n\nThe best products feel inevitable because someone sweated the decisions you never notice.",
      tags: ["Design", "UX", "ProductThinking"], likes: 891, commentsCount: 71, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 3)),
    ),
  ];

  // ── Conversations ─────────────────────────────────────────────────────
  store.conversations = [
    Conversation(
      id: "conv_ai",
      participantIds: ["me", "ai_mentor"],
      lastMessage: "I analyzed your validation metrics. Ready to discuss your GTM strategy?",
      lastMessageTime: now.subtract(const Duration(minutes: 2)),
      unreadCount: 1,
      isPinned: true,
    ),
    Conversation(id: "conv1", participantIds: ["me", "u1"], lastMessage: "Would love to get your feedback on our pitch deck 🙏", lastMessageTime: now.subtract(const Duration(seconds: 600)), unreadCount: 2),
    Conversation(id: "conv2", participantIds: ["me", "u2"], lastMessage: "That design idea is brilliant. Let's sync this week!", lastMessageTime: now.subtract(const Duration(hours: 2)), unreadCount: 0),
    Conversation(id: "conv3", participantIds: ["me", "u3"], lastMessage: "The PLG playbook you mentioned — can you send the link?", lastMessageTime: now.subtract(const Duration(days: 1)), unreadCount: 1),
    Conversation(id: "conv4", participantIds: ["me", "u4"], lastMessage: "I can help with the backend architecture for sure", lastMessageTime: now.subtract(const Duration(days: 2)), unreadCount: 0),
    Conversation(id: "conv5", participantIds: ["me", "u7"], lastMessage: "Nadia your community framework was exactly what we needed", lastMessageTime: now.subtract(const Duration(days: 3)), unreadCount: 0),
  ];

  // ── Messages ─────────────────────────────────────────────────────────
  store.messages = [
    ChatMessage(id: "mai_1", conversationId: "conv_ai", senderId: "ai_mentor", text: "Hey Jane! I'm your dedicated TAEED AI Mentor 🤖. I've reviewed your latest validation requests.", sentAt: now.subtract(const Duration(hours: 1)), isRead: true),
    ChatMessage(id: "mai_2", conversationId: "conv_ai", senderId: "me", text: "Hi! How does our willingness-to-pay metric look so far?", sentAt: now.subtract(const Duration(minutes: 15)), isRead: true),
    ChatMessage(id: "mai_3", conversationId: "conv_ai", senderId: "ai_mentor", text: "I analyzed your validation metrics. Ready to discuss your GTM strategy?", sentAt: now.subtract(const Duration(minutes: 2)), isRead: false),

    ChatMessage(id: "m1", conversationId: "conv1", senderId: "me", text: "Hey Alex! Huge fan of what you're building. I've been following your validation journey.", sentAt: now.subtract(const Duration(hours: 5)), isRead: true),
    ChatMessage(id: "m2", conversationId: "conv1", senderId: "u1", text: "Jane! Thanks so much 🙌 TAEED looks incredible — the validation wizard is next-level.", sentAt: now.subtract(const Duration(hours: 4)), isRead: true),
    ChatMessage(id: "m3", conversationId: "conv1", senderId: "me", text: "Really appreciate that! We'd love expert feedback from a founder like you.", sentAt: now.subtract(const Duration(hours: 3)), isRead: true),
    ChatMessage(id: "m4", conversationId: "conv1", senderId: "u1", text: "Would love to get your feedback on our pitch deck 🙏", sentAt: now.subtract(const Duration(seconds: 600)), isRead: false),
    ChatMessage(
      id: "m4_deck",
      conversationId: "conv1",
      senderId: "u1",
      text: "Here is our latest seed pitch deck draft for your review!",
      attachmentType: "pitch_deck",
      attachmentTitle: "Truthprenuer_Seed_Deck_v2.pdf",
      attachmentSubtitle: "12 slides • 4.2 MB",
      sentAt: now.subtract(const Duration(seconds: 580)),
      isRead: false,
      reaction: "🚀",
    ),
    ChatMessage(id: "m5", conversationId: "conv1", senderId: "u1", text: "I'll DM you the link! Super excited to hear your thoughts 🚀", sentAt: now.subtract(const Duration(seconds: 540)), isRead: false),

    ChatMessage(id: "m6", conversationId: "conv2", senderId: "u2", text: "Jane I saw your post about design-first — so true. We need to chat.", sentAt: now.subtract(const Duration(hours: 8)), isRead: true),
    ChatMessage(id: "m7", conversationId: "conv2", senderId: "me", text: "YES. Let's! I have some thoughts on your validation tool design too.", sentAt: now.subtract(const Duration(hours: 7)), isRead: true),
    ChatMessage(id: "m8", conversationId: "conv2", senderId: "u2", text: "That design idea is brilliant. Let's sync this week!", sentAt: now.subtract(const Duration(hours: 2)), isRead: true, reaction: "❤️"),

    ChatMessage(id: "m9", conversationId: "conv3", senderId: "me", text: "Marcus your PLG post was 🔥 — what's the one distribution channel you'd double down on right now?", sentAt: now.subtract(const Duration(hours: 25)), isRead: true),
    ChatMessage(id: "m10", conversationId: "conv3", senderId: "u3", text: "Honestly? LinkedIn + community-led. The funnel is so underpriced right now.", sentAt: now.subtract(const Duration(days: 1)), isRead: true),
    ChatMessage(id: "m11", conversationId: "conv3", senderId: "me", text: "The PLG playbook you mentioned — can you send the link?", sentAt: now.subtract(const Duration(days: 1)), isRead: false),
  ];

  // ── Notifications ─────────────────────────────────────────────────────
  store.notifications = [
    AppNotification(id: "n1", type: AppNotificationType.upvote, actorId: "u1", actorName: "Alex Rivera", message: "Alex Rivera upvoted your validation 'A platform to validate startup ideas'", time: now.subtract(const Duration(seconds: 120)), isRead: false, actionId: "v1"),
    AppNotification(id: "n2", type: AppNotificationType.follow, actorId: "u3", actorName: "Marcus Webb", message: "Marcus Webb started following you", time: now.subtract(const Duration(seconds: 1800)), isRead: false),
    AppNotification(id: "n3", type: AppNotificationType.comment, actorId: "u2", actorName: "Priya Sharma", message: "Priya Sharma commented: 'The UX challenge here is huge - how do you make structured feedback feel lightweight?'", time: now.subtract(const Duration(hours: 2)), isRead: false, actionId: "v1"),
    AppNotification(id: "n4", type: AppNotificationType.mention, actorId: "u4", actorName: "Sana Khan", message: "Sana Khan mentioned you in a post: 'Inspired by @jane_ui on validation-first UX'", time: now.subtract(const Duration(hours: 5)), isRead: true, actionId: "p4"),
    AppNotification(id: "n5", type: AppNotificationType.milestone, actorId: "system", actorName: "TAEED", message: "🎉 Your validation reached 300 upvotes! You're trending in the SaaS category.", time: now.subtract(const Duration(hours: 8)), isRead: true, actionId: "v1"),
    AppNotification(id: "n6", type: AppNotificationType.upvote, actorId: "u7", actorName: "Nadia Osei", message: "Nadia Osei upvoted your post 'What design-first actually means'", time: now.subtract(const Duration(days: 1)), isRead: true, actionId: "p5"),
    AppNotification(id: "n7", type: AppNotificationType.follow, actorId: "u6", actorName: "Carlos Ruiz", message: "Carlos Ruiz started following you", time: now.subtract(const Duration(days: 2)), isRead: true),
    AppNotification(id: "n8", type: AppNotificationType.comment, actorId: "u7", actorName: "Nadia Osei", message: "Nadia Osei commented on your validation: 'Community moderation will make or break this'", time: now.subtract(const Duration(days: 3)), isRead: true, actionId: "v4"),
    AppNotification(id: "n9", type: AppNotificationType.system, actorId: "system", actorName: "TAEED", message: "Your weekly analytics digest is ready. You had 1,204 profile views this week.", time: now.subtract(const Duration(days: 5)), isRead: true),
    AppNotification(id: "n10", type: AppNotificationType.welcome, actorId: "system", actorName: "TAEED", message: "Welcome to TAEED! You're part of an early community of 2,800+ founders validating together.", time: now.subtract(const Duration(days: 365)), isRead: true),
  ];

  // ── Decision Actions ──────────────────────────────────────────────────
  store.decisionCenterActions = [
    DecisionAction(id: "da1", title: "Validate Pricing Strategy", description: "3 recent validators expressed willingness to pay, but expected price is 40% lower than target.", impact: "High Impact", confidence: 0.85, type: ActionType.gatherEvidence, validationId: "v1"),
    DecisionAction(id: "da2", title: "Revisit Target Audience", description: "Feedback from 'Enterprise' users is contradictory. Consider narrowing to 'Mid-Market'.", impact: "Medium Impact", confidence: 0.65, type: ActionType.pivot, validationId: "v1"),
    DecisionAction(id: "da3", title: "Schedule Expert Review", description: "Your PMF readiness score is stalled. An expert review could uncover blind spots.", impact: "High Impact", confidence: 0.90, type: ActionType.expertReview, validationId: null),
  ];

  // ── AI Validation Reports ──────────────────────────────────────────────
  store.aiReports = [
    AIValidationReport(
      id: "air_1",
      validationId: "v1",
      problemAnalysis: "The problem space is acute: over 90% of tech startups fail due to building products nobody wants. Founders currently rely on unscientific Twitter polls or polite feedback from friends. Truthprenuer fills the empirical validation void with structured evidence extraction.",
      competitorOverview: "Existing alternatives include Typeform (generic surveys with 2% completion), Product Hunt (post-launch vanity metrics), and YC Co-Founder matching (social networking without structured feedback telemetry). Truthprenuer is the first dedicated pre-code validation engine.",
      marketAssumptions: [
        "Founders are willing to pay \$49-\$99/month for verified, high-conviction validator feedback.",
        "Accredited validators and PMs want reputation tokens and equity exposure in exchange for reviews.",
        "Structured quantitative scorecards drive 10x higher decision confidence than qualitative comments.",
      ],
      risks: [
        "Cold-start marketplace liquidity: maintaining validator response turnaround within 24 hours.",
        "Founder confirmation bias: risk of ignoring negative willingness-to-pay indicators.",
        "Platform disintermediation: founders attempting to hire validators directly outside Truthprenuer.",
      ],
      missingInformation: [
        "Cohort retention metrics for second-time founders running multiple experiments.",
        "Average customer willingness-to-pay threshold for enterprise B2B validation tiers.",
      ],
      suggestedAudience: "Seed & Pre-Seed B2B SaaS Founders, Venture Studio Builders, Product Leads at high-growth startups.",
      interviewQuestions: [
        "Walk me through the exact moment you decided to write your first line of code. What empirical evidence did you have?",
        "When was the last time you killed an idea based on negative customer feedback? What metric convinced you?",
        "If you could get 10 verified PMF reviews within 48 hours for \$100, would you swipe your corporate card right now?",
      ],
      biasWarnings: [
        "Beware of 'polite founder syndrome' — early users saying 'looks cool!' without putting down a credit card or letter of intent.",
        "Sampling bias: ensure feedback comes from actual budget holders, not aspiring builders without buying authority.",
      ],
      generatedAt: now.subtract(const Duration(hours: 12)),
    ),
  ];

  _seedPhase3Data(store, now);
}

void _seedPhase3Data(MockDataStore store, DateTime now) {
  final u8 = User(id: "u8", name: "Founder 8", username: "founder8", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 8, joinedDate: now.subtract(const Duration(days: 240)));
  final u9 = User(id: "u9", name: "Founder 9", username: "founder9", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 3, joinedDate: now.subtract(const Duration(days: 52)));
  final u10 = User(id: "u10", name: "Founder 10", username: "founder10", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 2, joinedDate: now.subtract(const Duration(days: 89)));
  final u11 = User(id: "u11", name: "Founder 11", username: "founder11", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 1, joinedDate: now.subtract(const Duration(days: 193)));
  final u12 = User(id: "u12", name: "Founder 12", username: "founder12", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 8, joinedDate: now.subtract(const Duration(days: 113)));
  final u13 = User(id: "u13", name: "Founder 13", username: "founder13", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 2, joinedDate: now.subtract(const Duration(days: 277)));
  final u14 = User(id: "u14", name: "Founder 14", username: "founder14", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 6, joinedDate: now.subtract(const Duration(days: 249)));
  final u15 = User(id: "u15", name: "Founder 15", username: "founder15", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 2, joinedDate: now.subtract(const Duration(days: 108)));
  final u16 = User(id: "u16", name: "Founder 16", username: "founder16", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 6, joinedDate: now.subtract(const Duration(days: 100)));
  final u17 = User(id: "u17", name: "Founder 17", username: "founder17", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 6, joinedDate: now.subtract(const Duration(days: 57)));
  final u18 = User(id: "u18", name: "Founder 18", username: "founder18", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 4, joinedDate: now.subtract(const Duration(days: 260)));
  final u19 = User(id: "u19", name: "Founder 19", username: "founder19", bio: "Building cool things.", role: "Founder", skills: ["Product", "Design"], location: "Global", validationsCount: 1, joinedDate: now.subtract(const Duration(days: 185)));

  store.users.addAll([u8, u9, u10, u11, u12, u13, u14, u15, u16, u17, u18, u19]);

  store.validations.addAll([
    ValidationRequest(id: "v13", title: "AI-Powered Tool 0", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u8", upvotes: 165, commentsCount: 34, isUpvoted: false, createdAt: now.subtract(const Duration(days: 4)), tags: ["AI", "SaaS"]),
    ValidationRequest(id: "v14", title: "AI-Powered Tool 1", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u9", upvotes: 220, commentsCount: 11, isUpvoted: false, createdAt: now.subtract(const Duration(days: 7)), tags: ["AI", "SaaS"]),
    ValidationRequest(id: "v7", title: "AI-Powered Tool 2", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u10", upvotes: 69, commentsCount: 36, isUpvoted: false, createdAt: now.subtract(const Duration(days: 8)), tags: ["AI", "SaaS"]),
    ValidationRequest(id: "v8", title: "AI-Powered Tool 3", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u11", upvotes: 186, commentsCount: 31, isUpvoted: false, createdAt: now.subtract(const Duration(days: 3)), tags: ["AI", "SaaS"]),
    ValidationRequest(id: "v9", title: "AI-Powered Tool 4", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u12", upvotes: 140, commentsCount: 16, isUpvoted: false, createdAt: now.subtract(const Duration(days: 6)), tags: ["AI", "SaaS"]),
    ValidationRequest(id: "v10", title: "AI-Powered Tool 5", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u13", upvotes: 482, commentsCount: 35, isUpvoted: false, createdAt: now.subtract(const Duration(days: 7)), tags: ["AI", "SaaS"]),
    ValidationRequest(id: "v11", title: "AI-Powered Tool 6", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u14", upvotes: 230, commentsCount: 4, isUpvoted: false, createdAt: now.subtract(const Duration(days: 3)), tags: ["AI", "SaaS"]),
    ValidationRequest(id: "v12", title: "AI-Powered Tool 7", problem: "People need AI tools.", solution: "An AI tool to solve problems.", targetAudience: "Everyone", authorId: "u15", upvotes: 78, commentsCount: 48, isUpvoted: false, createdAt: now.subtract(const Duration(days: 10)), tags: ["AI", "SaaS"]),
  ]);

  store.posts.addAll([
    PostItem(id: "p6", authorId: "u8", title: "Post about startups 0", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 93, commentsCount: 32, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 5))),
    PostItem(id: "p7", authorId: "u9", title: "Post about startups 1", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 752, commentsCount: 18, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 2))),
    PostItem(id: "p8", authorId: "u10", title: "Post about startups 2", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 535, commentsCount: 49, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 5))),
    PostItem(id: "p9", authorId: "u11", title: "Post about startups 3", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 592, commentsCount: 64, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 2))),
    PostItem(id: "p10", authorId: "u12", title: "Post about startups 4", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 959, commentsCount: 21, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 3))),
    PostItem(id: "p11", authorId: "u13", title: "Post about startups 5", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 985, commentsCount: 22, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 3))),
    PostItem(id: "p12", authorId: "u14", title: "Post about startups 6", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 390, commentsCount: 21, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 1))),
    PostItem(id: "p13", authorId: "u15", title: "Post about startups 7", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 313, commentsCount: 82, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 5))),
    PostItem(id: "p14", authorId: "u16", title: "Post about startups 8", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 114, commentsCount: 58, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 3))),
    PostItem(id: "p15", authorId: "u17", title: "Post about startups 9", body: "This is a post body.", tags: ["Startup", "Growth"], likes: 84, commentsCount: 71, isLiked: false, isBookmarked: false, createdAt: now.subtract(const Duration(days: 4))),
  ]);
}
