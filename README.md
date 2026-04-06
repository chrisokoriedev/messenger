# Messenger

A Flutter email client app built as part of a mobile developer assessment.

---

## Features

- **Login** — simulated authentication with session persistence
- **Inbox** — view emails with sender, subject, preview, and timestamp
- **Email Detail** — read full email, mark as read/unread, reply, or delete
- **Compose** — write and send emails with recipient chips, subject, and body
- **Sent & Drafts** — sent emails and auto-saved drafts persist across sessions
- **Search** — search inbox by sender, subject, or content

---

## Demo & Download

- **Screen Recording** — [Watch demo on Google Drive](https://drive.google.com/file/d/1YZYJW7nLXhff_SwexFrwfzeudDmwQUdt/view?usp=sharing)
- **APK Download** — [Download APK from Google Drive](https://drive.google.com/file/d/1_WWN88yXOifhQC29lW9DQsarj7XRFzI5/view?usp=sharing)

---

## How to Run

### Prerequisites

- Flutter SDK `>=3.10.4`
- A connected device or emulator

### Steps

```bash
flutter pub get
flutter run
```

---

## Tech Stack

- **Flutter** + **Dart**
- **Riverpod** — state management
- **GoRouter** — navigation
- **SharedPreferences** — local persistence
- **Google Fonts** — Plus Jakarta Sans

---

## Challenges

1. **Draft navigation type error** — GoRouter `extra` was cast as `Map?` but drafts pass an `EmailModel`. Fixed by checking the type before casting.

2. **SharedPreferences async init** — Had to ensure `SharedPreferences.getInstance()` completed before `runApp` to avoid provider reads on an uninitialized instance.

3. **Draft upsert logic** — Saving a draft needed to update in-place if it already existed, or insert at the top if new. Used `indexWhere` to handle both cases.

