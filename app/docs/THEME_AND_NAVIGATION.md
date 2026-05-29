# Theme & Navigation — ResQ-Kh Emergency App

## Overview

Dark mode with persistence, theme-aware screens, ShellRoute navigation patterns, and overflow handling.

---

## Dark Mode

### Architecture

```
main.dart
  └─ ResQApp (StatefulWidget)
       ├─ ThemeController (ChangeNotifier)
       │    ├─ load()        → reads darkMode from SharedPreferences
       │    ├─ toggle()      → flips + persists + notifyListeners()
       │    └─ setMode()     → explicit set
       └─ Consumer<ThemeController>
            └─ MaterialApp.router(themeMode: controller.mode)
```

### Key files

| File | Role |
|---|---|
| `core/theme/theme_controller.dart` | `ChangeNotifier` wrapping `StorageService`. Single source of truth for `ThemeMode`. |
| `core/theme/app_theme.dart` | `AppTheme.lightTheme` and `AppTheme.darkTheme` — independent `ThemeData` objects (not `copyWith`). |
| `core/theme/app_color.dart` | Static color palette (reds, accents). **Not theme-aware** — prefer `Theme.of(context)` in widgets. |
| `app.dart` | Creates `ThemeController`, calls `load()` on init, provides it via `ChangeNotifierProvider`. |

### Theme details

| | Light | Dark |
|---|---|---|
| Scaffold bg | `#F2F2F2` | `#121212` |
| Card / surface | `#FFFFFF` | `#1E1E1E` |
| Input fill | `#FFFFFF` | `#2C2C2C` |
| Primary | `#D32F2F` (red) | `#EF5350` (redLight) |
| Text primary | `#1A1A1A` | `#E0E0E0` |
| Text dim | `#555555` | `#AAAAAA` |
| Elevated button bg | `#D32F2F` | `#EF5350` |
| Elevated button text | White | Black |
| Bottom nav sel | `#D32F2F` | `#EF5350` |
| Bottom nav unsel | `#555555` | `#AAAAAA` |

---

## Writing Theme-Aware Widgets

### ✅ Correct pattern

```dart
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final onSurface = theme.colorScheme.onSurface;      // primary text
  final dimColor = theme.textTheme.bodyMedium!.color!; // secondary text
  final surface = theme.colorScheme.surface;            // card/container bg
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    decoration: BoxDecoration(
      color: surface,  // adapts to theme
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black54 : AppColors.shadow,
          blurRadius: 8,
        ),
      ],
    ),
    child: Text('Label', style: TextStyle(color: onSurface)),
  );
}
```

### ❌ Wrong pattern (hardcoded — breaks dark mode)

```dart
Container(
  color: AppColors.white,      // stays white in dark mode
  child: Text('Label',
    style: TextStyle(color: AppColors.textPrimary), // stays dark in dark mode
  ),
)
```

### When to use `AppColors` directly

Only for colors that should remain constant across themes:
- `AppColors.red` / `AppColors.redLight` / `AppColors.redDark` — the SOS brand red
- `AppColors.police`, `AppColors.hospital`, `AppColors.fire`, `AppColors.ambulance` — service accent colors
- `AppColors.success`, `AppColors.warning` — semantic colors
- `Colors.white` — text/icons on red backgrounds (both themes)

---

## Navigation Rules

### Route architecture

```
GoRouter
├── ShellRoute (has bottom nav + header)      ← tab screens
│   ├── /                HomeScreen
│   ├── /map             MapScreen
│   ├── /sos             _SosScreen
│   ├── /contacts        ContactsScreen
│   └── /first-aid       FirstAidListScreen
│
└── Top-level routes (no bottom nav)          ← pushed screens
    ├── /services/:type          ServiceListScreen
    ├── /service/:id             ServiceDetailScreen
    ├── /first-aid/:tipId        FirstAidDetailScreen
    ├── /contacts/add            ContactFormScreen
    ├── /contacts/edit/:id       ContactFormScreen
    ├── /settings                SettingsScreen
    ├── /profile                 _PlaceholderScreen
    └── /notifications           _PlaceholderScreen
```

### Navigation methods

| Method | Use case | Stack behavior |
|---|---|---|
| `context.go(location)` | **Bottom nav tabs only** | Replaces entire shell stack |
| `context.push(location)` | **Everything else** (header buttons, quick actions, list items) | Pushes on top, `pop()` returns |

### Common mistakes (and the crashes they cause)

| Mistake | Crash | Fix |
|---|---|---|
| `context.go()` to a top-level route | Replaces shell → `pop()` has nothing to pop | Use `context.push()` |
| `context.pop()` in a tab screen | Tab reached via `go()` → stack has 1 entry | Use `context.go('/')` to go home, or remove the back button |
| Back button in a tab screen's AppBar | Same as above | Remove `leading` — user switches tabs via bottom nav |

### Where each method is used

```
Bottom nav taps        → context.go()    (tab switch)
Header profile btn     → context.push()  (overlay)
Header notification    → context.push()  (overlay)
Home quick-action tiles → context.push() (service list)
Home settings gear     → context.push()  (settings)
Service card details   → context.push()  (service detail)
First-aid card tap     → context.push()  (first-aid detail)
Contacts FAB           → context.push()  (add form)
Contacts edit btn      → context.push()  (edit form)
SOS confirm dialog     → context.push()  (SOS screen)
Map back button        → context.go('/') (return to home tab)
SOS cancel button      → context.go('/') (return to home tab)

Full-screen back btns  → context.pop()   (return to previous route)
```

---

## Home Screen Overflow

The Home Screen contains a 180px SOS button + 4 quick-action tiles (each ~90px). On screens shorter than ~700px available height, this overflows a standard `Column`.

**Solution**: The body is wrapped in `SingleChildScrollView`. The `Spacer` widgets were replaced with fixed `SizedBox(height: 32)` gaps. Content scrolls on small screens while keeping the SOS button prominent on all sizes.

---

## Settings Persistence

All settings are stored via `StorageService` (SharedPreferences):

| Key | Storage method | Default |
|---|---|---|
| Language (EN/KH) | `StorageService.setLanguage()` / `getLanguage()` | `'EN'` |
| Dark mode | `ThemeController.toggle()` → `StorageService.setDarkMode()` | `false` |
| Blood group | `StorageService.setBloodGroup()` / `getBloodGroup()` | `''` |
| Allergies | `StorageService.setAllergies()` / `getAllergies()` | `''` |
| Personal contacts | `StorageService.saveContacts()` / `loadContacts()` | `[]` |

Dark mode is special: it's managed by `ThemeController` (a `ChangeNotifier`) for reactive UI updates, but still persisted through `StorageService.setDarkMode()`.
