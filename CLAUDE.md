# CarCarePlus — Quick Reference

Flutter frontend for a car‑service platform (Laravel 12 backend, currently login endpoint only).
**Phase 1 = build UI with mock data.** Backend integration comes later.

> ⚠️ Reality check: the repo has ~131 Dart files, but most are **empty scaffolding**. Only the
> customer **auth** flow (welcome / login / register / OTP) has real UI. Everything else is a
> `Center(child: Text(...))` placeholder and every Cubit currently emits `void` with no logic.

## Project Structure
```
lib/
├── main.dart              # ACTIVE entry: MaterialApp(home: WelcomePage) — inline indigo theme
├── app/
│   ├── app.dart           # MaterialApp.router variant (defined but NOT wired up)
│   ├── app_language.dart   # appLocale ValueNotifier<Locale> + AppStrings (ar/en getters)
│   └── app_strings.dart    # bilingual string getters
├── config/
│   ├── router.dart        # go_router: / login /register /home (defined but bypassed)
│   ├── dependency_injection.dart
│   └── env.dart
├── core/
│   ├── constants/         # app_colors, typography, spacing, api_constants, route_constants
│   ├── themes/            # light_theme, dark_theme, app_theme (thin one-liners for now)
│   ├── services/          # connectivity, location, notification
│   ├── utils/             # validators, formatters, helpers, logger
│   ├── websocket/         # websocket_client, tracking_handler
│   └── widgets/           # custom_button, gradient_button, custom_app_bar, loading_widget, social_login_button
├── domain/                # entities / repositories (abstract) / usecases  — mostly empty stubs
├── data/                  # datasources (remote dio + local) / models / repositories impl — stubs
└── presentation/
    ├── common/            # language_switcher, theme_switcher (placeholder), bottom_nav_bar, cubits
    ├── customer/          # auth ✅ | home cars booking payment tracking reports ⏳ (stubs)
    └── employee/          # auth tasks inventory cash_settlement ⏳ (stubs)
```

## Architecture
- **Clean Architecture**: `presentation → domain ← data`
- **State**: `flutter_bloc` (Cubit). `flutter_riverpod` also in pubspec but bloc is the one used.
- **Navigation**: `go_router` — **active**. Boots via `MaterialApp.router` (`main.dart`) using
  `AppRouter.router` (`config/router.dart`). Routes: `/splash` (initial) → `/welcome` → `/login`
  → `/register` → `/otp` (phone via `state.extra`) → `/home`. Navigate with `context.push/go`.
- **Localization**: custom `appLocale` `ValueNotifier<Locale>` + `AppStrings`; default **ar**. Single
  source in `app/app_language.dart`; `app/app_strings.dart` just re-exports it. `flutter_localizations`
  delegates + `supportedLocales [ar, en]` wired, so RTL flips automatically for Arabic.
- **Themes**: real light + dark built from design tokens in `core/themes/app_theme.dart` (Cairo font
  via google_fonts). Runtime switching via `appThemeMode` `ValueNotifier<ThemeMode>` + `ThemeSwitcher`.

## Design System (`core/constants/`)
- **Colors** — primary `#2563EB`, primaryDark `#1D4ED8`, secondary `#F97316`, background `#F8FAFC`,
  surface `#FFFFFF`, error `#EF4444`, textPrimary `#0F172A`, textSecondary `#64748B`, border `#E2E8F0`.
  ⚠️ Auth screens currently hardcode `#073D9E` / `#0368E9` instead of `AppColors` — inconsistent.
- **Typography** — headlineLarge 32/bold, headlineMedium 24/w600, headlineSmall 20/w600,
  bodyLarge 16, bodyMedium 14, bodySmall 12, buttonLarge 16/w600, caption 12.
- **Spacing** — xxs 2, xs 4, sm 8, md 12, lg 16 (base), xl 24, xxl 32, xxxl 48, huge 64.
  Radius — sm 4, md 8, lg 12, xl 16, round 50. Elevation — low 1, med 2, high 4.
- **Reusable widgets**: `GradientButton(text, onPressed, {icon, isLoading, isFullWidth})`,
  `CustomButton(label, onPressed)`, `SocialLoginButton(icon, label, onPressed)`, `LoadingWidget()`,
  `CustomAppBar(title)`.

## Feature Status
### ✅ Real UI
- Customer Auth: Welcome, Login, Register (**wired to the real API**), OTP verification (unused in flow —
  reserved for password reset), Splash
- Home: themed landing with emergency banner → Road Assistance
- **Road Assistance** (`presentation/customer/roadside/`): 4-step request wizard
  (service → details → location/photo → review+price) + tracking screen (mock map,
  status timeline, employee card, BR-13 cancel window). Cubits: `RoadsideRequestCubit`,
  `RoadsideTrackingCubit` (mock status progression). Taxonomy follows PRD Module 2.

### ⏳ Stub / placeholder (folder + empty Cubit exist, UI is a Text placeholder)
- Customer: Cars (list/add/edit), Booking, Payment, Tracking, Reports
- Employee: Auth, Tasks, Inventory, Cash settlement

### ❌ Not started (no presentation layer)
- AI Chatbot · Points & Packages · Admin dashboard

## API Integration (started 2026-07-17)
- **Auth (Login + Register)** wired to the Laravel backend. Layering: `AuthCubit` → `AuthRepositoryImpl`
  → `AuthApi` → `DioClient`. Token saved via `TokenStorage` (flutter_secure_storage). See `docs/API_INTEGRATION.md`.
- `DioClient` (`data/datasources/remote/dio_client.dart`): base URL from `Env.apiBaseUrl`
  (`http://10.0.2.2:8000/api` for the Android emulator), Bearer interceptor, `ApiException` mapping
  (Laravel 422 field errors), optional logging. Cleartext http enabled in the **debug** manifest only.
- Endpoint paths in `core/constants/api_constants.dart`. Login/Register return a token → go to `/home`
  (no OTP in the auth flow). **Not yet wired**: logout, other features (still mock/stub).

## Known Issues / Tech Debt
1. **Most Cubits/usecases/repositories still empty** — only auth has a real data layer; other features
   use mock data or are stubs. Wiring them to the API is still to do.
2. **`lib/app/app.dart`** — an older `MaterialApp.router` wrapper, now redundant (main.dart is the
   canonical entry). Safe to delete once confirmed unused.
3. Feature pages (home, cars, booking, …) are still placeholders — see status table.

### ✅ Foundation fixed (2026-07-16)
- go_router wired as the real navigator; all auth routes registered; `Navigator.push` → `context.push/go`.
- Real light/dark themes from design tokens; `ThemeSwitcher` toggles `appThemeMode`.
- Fixed duplicate `appLocale` notifier bug (app_strings/app_language were divergent copies).
- `flutter_localizations` added → automatic RTL. Splash de-Riverfied to plain `StatefulWidget`.
- Auth screens refactored onto the theme + design system; OTP uses `pinput`; register uses real validators.

## How to Add a New Feature
1. `domain/`: entity + abstract repository + usecase(s).
2. `data/`: model (+ `fromJson`/`toJson`), repository impl, remote/local datasource (mock for now).
3. `presentation/<role>/<feature>/`: `cubit/` (state + logic), `pages/`, `widgets/`.
4. Register route in `config/router.dart`; add strings to `app_strings.dart` (ar + en).
5. Use `AppColors` / `AppTypography` / `Spacing` — do not hardcode colors. Support light + dark + RTL.

## External Docs (`docs/`)
- PRD: `docs/Requirement Analysis/carCarePlus_PRD.md` · SRS §4 UI: `docs/Requirement Analysis/SRS2.md`
- Use cases: `docs/use_case_document.md` · `docs/System Analysis/use_case_specification.md`
- Business rules: `docs/System Analysis/BusinessRules.md`
- Flows: `docs/System Analysis/Activity Diagrams/` (incl. `خدمة الطوارئ.txt` = road assistance)
- States: `docs/System Analysis/State Chart/` · ERD: `docs/System Design/ERD Mermaid.txt`
- Roles: `docs/System Design/Role_Permission_Matrix.md`

## Current Status
Auth flow works end‑to‑end with mock delays. Next: build **Road Assistance** UI (UC‑18→22) with mock
data, following the design system and fixing the routing/architecture gaps as we go.
