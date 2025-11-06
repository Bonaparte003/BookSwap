# Get SHA-1 Using Android Studio (Step-by-Step)

Since Java isn't available in your terminal, use Android Studio:

## Step 1: Open Android Studio
1. Open Android Studio
2. Open your project: `/Users/avellin/Desktop/bookswap`

## Step 2: Open Gradle Panel
1. Look at the **right side** of Android Studio
2. Find the **Gradle** tab (usually at the top right)
3. If you don't see it: **View** → **Tool Windows** → **Gradle**

## Step 3: Run signingReport
1. In the Gradle panel, expand:
   ```
   bookswap
   └── android
       └── app
           └── Tasks
               └── android
   ```
2. Double-click on **`signingReport`**

## Step 4: Get SHA-1
1. Look at the **Run** tab at the bottom of Android Studio
2. Wait for the task to finish
3. Scroll through the output until you see:
   ```
   Variant: debug
   Config: debug
   Store: /Users/avellin/.android/debug.keystore
   Alias: androiddebugkey
   MD5: ...
   SHA1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12
   SHA-256: ...
   Valid until: ...
   ```
4. **Copy the SHA1 value** (the long string after `SHA1:`)

## Step 5: Add to Firebase
1. Go to: https://console.firebase.google.com/
2. Select project: **bookswap-fec4c**
3. Click ⚙️ **Project settings**
4. Scroll to **Your apps**
5. Find Android app: **com.example.bookswap**
6. Click **Add fingerprint**
7. Paste your SHA-1
8. Click **Save**

## Step 6: Rebuild
```bash
cd /Users/avellin/Desktop/bookswap
flutter clean
flutter pub get
flutter run
```

That's it! Google Sign-In should work after this.

