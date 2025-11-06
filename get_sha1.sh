#!/bin/bash

# Script to get SHA-1 fingerprint for Android debug keystore

echo "Getting SHA-1 fingerprint for Google Sign-In..."
echo ""

# Method 1: Try using Android Studio's keytool
ANDROID_STUDIO_KEYTOOL="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool"
if [ -f "$ANDROID_STUDIO_KEYTOOL" ]; then
    echo "Using Android Studio's keytool..."
    "$ANDROID_STUDIO_KEYTOOL" -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>&1 | grep -A 2 "SHA1:"
    exit 0
fi

# Method 2: Try using system keytool
if command -v keytool &> /dev/null; then
    echo "Using system keytool..."
    keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>&1 | grep -A 2 "SHA1:"
    exit 0
fi

# Method 2: Try using Gradle
if [ -f "android/gradlew" ]; then
    echo "Using Gradle..."
    cd android
    ./gradlew signingReport 2>&1 | grep -A 10 "SHA1:" || echo "Gradle failed. Please use Android Studio method."
    exit 0
fi

echo "Neither keytool nor Gradle available."
echo ""
echo "Please use Android Studio:"
echo "1. Open Android Studio"
echo "2. Open Gradle panel (right side)"
echo "3. Run: android > app > Tasks > android > signingReport"
echo "4. Look for SHA1: in the output"
echo ""
echo "Or install Java: brew install openjdk@17"

