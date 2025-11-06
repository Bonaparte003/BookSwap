# How to Get SHA-1 Fingerprint for Google Sign-In

## Option 1: Using Android Studio (Easiest)

1. Open Android Studio
2. Open your project: `/Users/avellin/Desktop/bookswap`
3. Click on the **Gradle** tab on the right side (or View → Tool Windows → Gradle)
4. Expand: `bookswap` → `android` → `app` → `Tasks` → `android`
5. Double-click on **`signingReport`**
6. Look at the **Run** tab at the bottom
7. Find the section that says:
   ```
   Variant: debug
   Config: debug
   Store: ~/.android/debug.keystore
   ```
8. Copy the **SHA1:** value (it looks like: `AB:CD:EF:12:34:56:...`)

## Option 2: Using Terminal (Requires Java)

If you have Java installed, run:

```bash
cd /Users/avellin/Desktop/bookswap
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Then look for the **SHA1** line.

## Option 3: Install Java First

If you don't have Java:

1. Install Homebrew (if not installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install Java:
   ```bash
   brew install openjdk@17
   ```

3. Then run the keytool command from Option 2

## Add SHA-1 to Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **bookswap-fec4c**
3. Click the gear icon ⚙️ → **Project settings**
4. Scroll down to **Your apps** section
5. Find your Android app (package: `com.example.bookswap`)
6. Click **Add fingerprint**
7. Paste your SHA-1 fingerprint
8. Click **Save**
9. Download the updated `google-services.json`
10. Replace the file at: `android/app/google-services.json`

## After Adding SHA-1

1. Run `flutter clean`
2. Run `flutter pub get`
3. Rebuild: `flutter run`

