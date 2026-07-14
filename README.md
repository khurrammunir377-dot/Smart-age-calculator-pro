# Smart Age Calculator Pro

A working Flutter app: pick a date of birth, calculate exact age (years/months/days,
total days/weeks/hours/minutes lived), and see the countdown to the next birthday.
Includes dark/light/system theme switching.

## What's included

- ✅ Age calculation engine (years/months/days, total time lived, next birthday)
- ✅ Home screen with date picker + results card + Quick Tools
- ✅ Settings screen with theme switching (Riverpod + SharedPreferences)
- ✅ Zodiac Info screen (Western + Chinese zodiac, all 12 signs each)
- ✅ Birthday Reminders: save birthdays, see live countdowns, get local
  notifications 1/3/7 days before (or on the day) — stored locally via
  SharedPreferences, no account or server needed
- ✅ Family Age Tracker: save unlimited family members with name, relationship,
  gender, date of birth, and a photo (picked from gallery, copied into the
  app's own storage so it survives even if the original photo is deleted).
  Shows live age + "upcoming birthdays in the next 30 days" section.
- ✅ History Log: every age calculated on the home screen (or via the PDF
  report generator) is automatically saved with a timestamp. Search by name,
  star favorites, delete individual entries, or clear everything.
- ✅ PDF Age Report: enter a name + DOB, generate a formatted PDF report
  (exact age, total days/weeks/months/hours lived, next birthday), then
  either preview/print it or share it directly via the system share sheet.

**Not included yet**: AdMob, Firebase, premium/IAP.

### Known limitations (by design, for now)

- `flutter_local_notifications` has no built-in "repeat yearly" option, so each
  birthday reminder is scheduled for its **next occurrence only**. The app
  automatically recalculates and re-schedules everything every time it's
  opened, so as long as you open the app at least once between reminders,
  they'll stay correct. True background yearly recurrence would need a small
  addition (e.g. WorkManager) — ask if you want that added.
- Notification times use the `timezone` package's default rather than confirmed
  local-timezone detection. If reminder times seem off by a few hours, let me
  know and I'll wire in exact detection via `flutter_timezone`.
- `image_picker` handles the modern Android photo picker without extra manifest
  permissions. Camera capture (not just gallery picking) would need
  `<uses-permission android:name="android.permission.CAMERA"/>` added — ask if
  you want that too.

---

## How to build & test this project

Pick whichever of these two options is easier for you — both produce a working
APK you can install on your phone.

### Option A: GitHub Actions (no local Flutter install needed)

This project includes a ready-made workflow at `.github/workflows/build_apk.yml`
that builds a release APK on GitHub's own servers.

1. Create a new **empty** repository on GitHub (don't initialize it with a README).
2. In a terminal, inside this unzipped folder:
   ```
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```
3. Go to your repo on GitHub → the **Actions** tab. The "Build APK" workflow
   starts automatically on push (or click **Run workflow** to trigger it
   manually).
4. Wait for the green checkmark (2–5 minutes). Click into the finished run →
   scroll to **Artifacts** → download `smart-age-calculator-pro-apk` (a zip
   containing `app-release.apk`).
5. Transfer that APK to your Android phone (email, Google Drive, USB, etc.),
   enable **"Install unknown apps"** for whichever app you used to open it,
   and tap the file to install.

This workflow automatically generates the `android/` platform folder and adds
the notification permission needed for Birthday Reminders, so there's nothing
else to configure.

### Option B: Run locally with Flutter installed

1. Unzip this project (if not already done) and open a terminal inside the
   folder containing `pubspec.yaml`.
2. Generate the native platform folders (only needed once):
   ```
   flutter create .
   ```
   This won't touch your existing `lib/`, `assets/`, or `pubspec.yaml`.
3. Add notification permission for Birthday Reminders — open
   `android/app/src/main/AndroidManifest.xml` and add this line inside
   `<manifest>` (above `<application>`):
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   ```
4. Install dependencies and check for issues:
   ```
   flutter pub get
   flutter analyze
   ```
5. Run it on a connected device/emulator:
   ```
   flutter run
   ```
6. Build a release APK when ready:
   ```
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`

## Requirements
- For Option A: just a free GitHub account.
- For Option B: Flutter SDK installed locally (`flutter --version` to check),
  plus Android Studio/Xcode or a physical phone with USB debugging enabled.
