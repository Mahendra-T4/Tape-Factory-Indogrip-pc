# Clear Data Feature Documentation

## Overview
This feature allows users to manually clear all their local app data directly from the Profile screen. This is useful before uninstalling the app or when you want to completely reset your local data.

## What Gets Deleted

When users click "Clear All Data", the following are permanently deleted:
- ✅ User profile information (name, email, phone)
- ✅ Login credentials and authentication tokens
- ✅ App preferences and settings
- ✅ Cached data
- ✅ Hive database files

## How to Use

### For Users:
1. Go to **Profile** screen
2. Scroll down to **Data Management** section
3. Click the **"Clear All Data"** button (red button)
4. A confirmation dialog will appear explaining what will be deleted
5. Click **"Delete All Data"** to confirm
6. The app will clear all data and automatically log you out
7. You'll be redirected to the login screen

### For Developers:
The feature is implemented through two main components:

#### 1. HiveService (lib/core/database/hive_service.dart)

**New Methods:**

```dart
/// Clear all user data while keeping app settings
static Future<void> clearUserData() async {
  // Clears user-specific data but preserves app preferences
}

/// Clear all app data (more aggressive)
static Future<void> clearAllData() async {
  // Completely deletes the Hive box and all data
  // Reinitializes for continued app usage
}
```

#### 2. Profile Screen (lib/features/profile/profile.dart)

**New Methods:**

```dart
/// Show confirmation dialog before clearing data
Future<void> _showClearDataConfirmation(BuildContext context) async {}

/// Execute the clear operation and logout
Future<void> _clearAllDataAndLogout(BuildContext context) async {}
```

## Manual Data Deletion (Windows)

If you need to manually delete the app data without using the UI:

### Windows:
- **App Installation:** Remove the app from Program Files
- **User Data Locations:**
  - `C:\Users\[YourUsername]\AppData\Local\[AppName]`
  - `C:\Users\[YourUsername]\AppData\Roaming\[AppName]`
  - Hive database files (typically `.hive` files)

**Steps:**
1. Press `Win + R`
2. Type `%APPDATA%` or `%LOCALAPPDATA%`
3. Find and delete the app's folder
4. Empty Recycle Bin

### Why Data Persists After Normal Uninstall

Most installers don't delete user data by design to:
- Prevent accidental data loss
- Allow users to reinstall and recover their data
- Follow platform conventions (Windows, macOS, Linux)

This new "Clear Data" feature solves this by giving users explicit control.

## Technical Details

### Hive Database Location
- **Android:** `app_data_directory/hive_box`
- **iOS:** `Documents/hive_box`
- **Windows:** App's local data directory
- **Web:** Browser's local storage

### Error Handling
- The feature includes try-catch blocks for safe error handling
- Users receive feedback via SnackBar notifications
- Loading indicators show during the clearing process
- The app safely logs out and redirects to login screen

## Future Enhancements

Consider adding:
- [ ] Option to clear only specific data (e.g., cache only)
- [ ] Data backup before clearing
- [ ] Schedule automatic data clearing on app close
- [ ] Export user data before clearing

## Testing

To test the feature:
1. Add test data through normal app usage
2. Navigate to Profile > Data Management
3. Click "Clear All Data"
4. Verify all data is removed and you're logged out
5. Re-login to confirm the app works normally
