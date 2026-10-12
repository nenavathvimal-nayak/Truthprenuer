# TRUTHPRENUER — MODULE O: MESSAGING & COMMUNITIES
## Screens 141 – 150 Specification

---

### Module Overview
- **Domain:** Direct Messaging, Threaded Group Communities, Notifications Center & Discussion Hubs
- **Communication Principles:**
  - Fast, responsive messaging with read receipts, typing indicators, and rich link previews.
  - Granular notification controls preventing alert fatigue.
  - Dedicated community spaces centered around vertical validation themes (e.g., #HealthTechValidation, #B2BSaaSFounders).

---

### Screen 141: Messages Inbox
- **Screen ID:** `SCR-141`
- **Route:** `/app/messages`
- **Two-Column Split Layout:**
  - Left Pane (340px): Conversation list with search, unread filters, user avatar, last message preview, timestamp, and unread count badge (`#F44A22`).
  - Right Pane (Remaining width): Selected conversation thread or empty placeholder ("Select a conversation to start chatting").

---

### Screen 142: One-to-One Conversation
- **Screen ID:** `SCR-142`
- **Route:** `/app/messages/:conversationId`
- **Chat Interface:**
  - Header: Partner avatar, name, headline, link to profile, action menu (Mute, Block, Report).
  - Message Bubbles:
    - Sent: Dark `#161616` (or Orange accent) with white text.
    - Received: Light Grey `#E4E2E3` with dark text.
  - Interactive Embeds: Embedded Validation Preview Card with real-time confidence pill.
  - Input Bar: Rich text, file attachment (+), emoji picker, Send button.

---

### Screen 143: New Message / Start Conversation
- **Screen ID:** `SCR-143`
- **Route:** Modal dialog on `/app/messages/new`
- **Recipient Picker:** Autocomplete search across your connections and fellow validators.

---

### Screen 144: Message Requests
- **Screen ID:** `SCR-144`
- **Route:** `/app/messages/requests`
- **Anti-Spam Filter:** Messages from users who are not direct connections. Allows previewing message without triggering read receipts; options: "Accept Request" | "Delete" | "Block Sender".

---

### Screen 145: Message Search
- **Screen ID:** `SCR-145`
- **Route:** `/app/messages/search?q={query}`
- **Faceted Search:** Search across all past conversation histories, filtering by person, keyword, or shared media attachments.

---

### Screen 146: Notifications & Activity Centre
- **Screen ID:** `SCR-146`
- **Route:** `/app/notifications`
- **Activity Streams:** All (24) | Feedback (12) | Mentions (4) | System & AI (8).
- **Notification Item:** Avatar of actor, action description ("Sarah M. submitted pricing feedback on EcoPack"), relative timestamp ("14m ago"), unread indicator.

---

### Screen 147: Notifications Preferences
- **Screen ID:** `SCR-147`
- **Route:** `/app/notifications/preferences`
- **Matrix Settings:** Toggle In-App, Email, and Push notifications across:
  - New Validator Feedback
  - AI Synthesis Report Complete
  - Connection Requests
  - Community Mentions
  - Weekly Health Digest

---

### Screen 148: Communities Directory
- **Screen ID:** `SCR-148`
- **Route:** `/app/communities`
- **Directory Grid:**
  - Community Cards: Banner, Logo, Name, Member Count (e.g., "1,420 Founders"), Topic Description, "Join Community" button.

---

### Screen 149: Community Details & Discussion
- **Screen ID:** `SCR-149`
- **Route:** `/app/communities/:communitySlug`
- **Community Hub:**
  - Header with Community Rules and Moderator list.
  - Feed of discussions, shared validation requests, weekly AMA threads.

---

### Screen 150: Community Creation & Management
- **Screen ID:** `SCR-150`
- **Route:** `/app/communities/new`
- **Settings Form:** Community Name, Slug, Description, Cover Art, Membership Rules (Open / Application Required), Moderator Assignments.
