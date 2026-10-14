-- ==============================================================================
-- TRUTHPRENUER PRODUCTION NOTIFICATIONS TRIGGERS & PROCEDURES
-- Trusted, Idempotent, Server-Side Notification Generation
-- ==============================================================================

-- 1. Trigger on Connection Request Sent
CREATE OR REPLACE FUNCTION public.fn_notify_on_connection_request()
RETURNS TRIGGER AS $$
DECLARE
    v_sender_name TEXT;
BEGIN
    IF NEW.status = 'pending' AND NEW.sender_id != NEW.receiver_id THEN
        SELECT full_name INTO v_sender_name 
        FROM public.profiles 
        WHERE id = NEW.sender_id;

        INSERT INTO public.notifications (
            recipient_id,
            actor_id,
            event_type,
            title,
            body,
            resource_path,
            is_read
        ) VALUES (
            NEW.receiver_id,
            NEW.sender_id,
            'connection_request',
            'New Connection Request',
            COALESCE(v_sender_name, 'A user') || ' sent you a connection request.',
            '/network',
            false
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_connection_request ON public.connection_requests;
CREATE TRIGGER trg_notify_connection_request
    AFTER INSERT ON public.connection_requests
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_notify_on_connection_request();

-- 2. Trigger on Connection Request Accepted
CREATE OR REPLACE FUNCTION public.fn_notify_on_connection_accepted()
RETURNS TRIGGER AS $$
DECLARE
    v_receiver_name TEXT;
BEGIN
    IF OLD.status = 'pending' AND NEW.status = 'accepted' THEN
        SELECT full_name INTO v_receiver_name 
        FROM public.profiles 
        WHERE id = NEW.receiver_id;

        INSERT INTO public.notifications (
            recipient_id,
            actor_id,
            event_type,
            title,
            body,
            resource_path,
            is_read
        ) VALUES (
            NEW.sender_id,
            NEW.receiver_id,
            'connection_accepted',
            'Connection Accepted',
            COALESCE(v_receiver_name, 'Your connection') || ' accepted your connection request.',
            '/network',
            false
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_connection_accepted ON public.connection_requests;
CREATE TRIGGER trg_notify_connection_accepted
    AFTER UPDATE ON public.connection_requests
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_notify_on_connection_accepted();

-- 3. Trigger on Validation Response Submitted
CREATE OR REPLACE FUNCTION public.fn_notify_on_validation_response()
RETURNS TRIGGER AS $$
DECLARE
    v_author_id UUID;
    v_validation_title TEXT;
    v_respondent_name TEXT;
BEGIN
    SELECT author_id, title INTO v_author_id, v_validation_title 
    FROM public.validations 
    WHERE id = NEW.validation_id;

    -- Only notify if the respondent is not the sprint author themselves
    IF v_author_id IS NOT NULL AND v_author_id != NEW.respondent_id THEN
        SELECT full_name INTO v_respondent_name 
        FROM public.profiles 
        WHERE id = NEW.respondent_id;

        INSERT INTO public.notifications (
            recipient_id,
            actor_id,
            event_type,
            title,
            body,
            resource_path,
            is_read
        ) VALUES (
            v_author_id,
            NEW.respondent_id,
            'validation_feedback',
            'New Validation Feedback',
            COALESCE(v_respondent_name, 'A peer') || ' submitted structured feedback on "' || COALESCE(v_validation_title, 'your sprint') || '".',
            '/validation-detail/' || NEW.validation_id,
            false
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_validation_response ON public.validation_responses;
CREATE TRIGGER trg_notify_validation_response
    AFTER INSERT ON public.validation_responses
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_notify_on_validation_response();

-- 4. Trigger on Direct Message Sent
CREATE OR REPLACE FUNCTION public.fn_notify_on_direct_message()
RETURNS TRIGGER AS $$
DECLARE
    r_member RECORD;
    v_sender_name TEXT;
BEGIN
    SELECT full_name INTO v_sender_name 
    FROM public.profiles 
    WHERE id = NEW.sender_id;

    FOR r_member IN 
        SELECT user_id 
        FROM public.conversation_members 
        WHERE conversation_id = NEW.conversation_id 
          AND user_id != NEW.sender_id
    LOOP
        INSERT INTO public.notifications (
            recipient_id,
            actor_id,
            event_type,
            title,
            body,
            resource_path,
            is_read
        ) VALUES (
            r_member.user_id,
            NEW.sender_id,
            'direct_message',
            'New Direct Message',
            COALESCE(v_sender_name, 'A user') || ' sent you a message.',
            '/chat/' || NEW.conversation_id,
            false
        );
    END LOOP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_direct_message ON public.messages;
CREATE TRIGGER trg_notify_direct_message
    AFTER INSERT ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_notify_on_direct_message();
