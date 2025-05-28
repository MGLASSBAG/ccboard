# Android Studio Setup Guide for Cboard

This guide explains how to set up and run the Cboard project in Android Studio on Windows with WSL.

## Prerequisites

- Windows with WSL2 (Ubuntu) installed
- Android Studio installed on Windows
- Java 11 installed in WSL
- Node.js installed in WSL
- Android SDK configured in Android Studio

## Project Structure

- **Main Cordova Project**: `/home/markg/dev/convo-dev/ccboard`
- **React App (submodule)**: `/home/markg/dev/convo-dev/ccboard/cboard`
- **Android Platform**: `/home/markg/dev/convo-dev/ccboard/platforms/android`

## Building the Project (in WSL)

1. **Navigate to the project directory**:
   ```bash
   cd /home/markg/dev/convo-dev/ccboard
   ```

2. **Build the React app**:
   ```bash
   cd cboard
   NODE_OPTIONS="--max-old-space-size=4096 --openssl-legacy-provider" npm run build
   ```

3. **Copy build to Cordova www folder**:
   ```bash
   cd ..
   rm -rf www/*
   cp -r cboard/build/* www/
   ```

4. **Prepare Android platform**:
   ```bash
   cordova prepare android
   ```

## Opening in Android Studio (Windows)

1. **Launch Android Studio** on Windows

2. **Open the Android project**:
   - Click "File" → "Open"
   - Navigate to: `\\wsl$\Ubuntu\home\markg\dev\convo-dev\ccboard\platforms\android`
   - Click "OK"

3. **Configure Gradle JDK**:
   - When prompted or go to "File" → "Project Structure"
   - Under "SDK Location" → "Gradle Settings"
   - Set JDK location to: `\\wsl$\Ubuntu\usr\lib\jvm\java-11-openjdk-amd64`
   - Click "OK"

4. **Wait for Gradle sync**:
   - Android Studio will sync the project
   - This may take a few minutes on first run

5. **Create Run Configuration**:
   - Click the dropdown next to the run button
   - Select "Edit Configurations..."
   - Click "+" → "Android App"
   - Name: "app"
   - Module: Select "ccboard.app" or "app"
   - Click "OK"

6. **Run the app**:
   - Select your emulator or connected device
   - Click the green "Run" button

## Troubleshooting

### "No modules" error in Android Studio
- Ensure you opened the `platforms/android` folder, not the root project
- Wait for Gradle sync to complete
- Try "File" → "Sync Project with Gradle Files"

### Build errors in Android Studio
- Ensure Java 11 is being used (not Java 17)
- Check that all Cordova plugins are properly installed
- Run `cordova clean android` and rebuild if needed

### App shows "Hello Android" instead of Cboard
- Ensure the React app was built successfully
- Verify files were copied to `www/` folder
- Run `cordova prepare android` again

### Memory errors during React build
- Use the NODE_OPTIONS flag as shown in the build command
- Increase the memory allocation if needed

## Quick Rebuild Script

Create a script `rebuild.sh` in the project root:

```bash
#!/bin/bash
cd cboard
NODE_OPTIONS="--max-old-space-size=4096 --openssl-legacy-provider" npm run build
cd ..
rm -rf www/*
cp -r cboard/build/* www/
cordova prepare android
echo "Build complete! Open Android Studio and run the app."
```

Make it executable: `chmod +x rebuild.sh`

## Important Notes

- Always build in WSL, not Windows
- Android Studio runs on Windows but accesses WSL files via `\\wsl$\` path
- The cboard submodule should be on commit `be9fcbc6` with:
  - `homepage: "."` in package.json
  - `<script src="cordova.js"></script>` in public/index.html 