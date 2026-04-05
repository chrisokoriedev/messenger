# Messenger

A Gmail-inspired email client built with Flutter, showcasing clean architecture, Riverpod state management, and local persistence with SharedPreferences.

---

## Features

- **Inbox / Sent / Drafts** tabs with persistent storage across sessions
- **Compose** screen with Gmail-style recipient chip input
- **Draft auto-save** — closing compose with content saves the draft; reopening it pre-fills all fields
- **Search** — full-text search across inbox emails by sender, subject, or preview
- **Snackbar validation** on compose (missing recipient, subject, or body)

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.10.4`
- Dart SDK `>=3.0.0`
- An Android emulator, iOS simulator, or physical device

### Run

```bash
# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run

# Target a specific device
flutter run -d emulator-5554
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release
```

---

## Project Structure

```
lib/
├── main.dart                         # App entry — bootstraps SharedPreferences + ProviderScope
├── app.dart                          # Root MaterialApp + ScreenUtil init
├── core/
│   ├── domain/email.dart             # Base Email model
│   ├── providers/                    # Shared providers (auth, inbox datasource, SharedPreferences)
│   ├── router/                       # GoRouter config + AppShell (drawer nav)
│   ├── shared/                       # Reusable widgets & constants
│   └── theme/                        # AppColors token system
└── features/
    ├── auth/                         # Login flow (Notifier + SharedPreferences session)
    ├── compose/                      # Compose screen, widgets, state & datasource
    ├── inbox/                        # Inbox / Sent / Drafts screens, providers & storage service
    └── profile/                      # Profile tab (placeholder)
```

---

## Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management (`AsyncNotifier`, `AutoDisposeNotifier`) |
| `go_router` | Declarative navigation with `StatefulShellRoute` |
| `shared_preferences` | Persisting sent and draft emails locally |
| `flutter_screenutil` | Responsive sizing (design base 390×844) |
| `google_fonts` | Plus Jakarta Sans typeface |

---

## Challenges

### 1. Router type mismatch on draft navigation
Opening a draft passed an `EmailModel` as GoRouter `extra`, but the compose route cast it as `Map?`, causing a runtime type error. Fixed by checking `extra is EmailModel` before `extra is Map` in the route builder so both draft-open and reply flows are handled without a shared wrapper type.

### 2. Formatter reverting in-progress state changes
The Dart formatter partially reverted multi-field state changes mid-session — leaving stray `required bool toError` in `copyWith` — breaking every call site. The fix was to track the exact intended state shape and re-apply cleanly after each formatter pass.

### 3. SharedPreferences bootstrap timing
`SharedPreferences.getInstance()` is async, so it must complete before `runApp`. Wrapped with `WidgetsFlutterBinding.ensureInitialized()` in `main()` and injected via a `ProviderScope` override, matching the pattern already used for auth persistence.

### 4. Draft upsert vs insert ordering
`DraftsNotifier.saveDraft()` needs to update an existing draft in-place (for repeated saves) while inserting new drafts at the top of the list. Resolved with an `indexWhere` check — replace at index if found, otherwise `insert(0, ...)`.

