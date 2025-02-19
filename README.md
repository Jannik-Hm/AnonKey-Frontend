# Anonkey Frontend

AnonKey is a zero-knowledge password manager, designed for self hosting.

This repository contains the Flutter project files for the AnonKey Frontend, which is currently WIP.

## Backend

The repository containing the backend code can be found [here](https://github.com/LightJack05/AnonKey-Backend).

## Flutter Installation

Please install the Flutter IDE and SDK using [this Guide](https://docs.flutter.dev/get-started/install) after reading the following.

Currently tested platforms for running and testing the app:

- Android (recommended on Windows)
- iOS
- MacOS (needs a Signing Certificate in Xcode -> Open `/macos/Runner.xcodeproj` -> `Signing & Capabilities` ->
  `Select Team` and `Enable Development Signing`)

### !!!Not working due to CORS: Web (Chrome)!!!

Other platforms may work but aren't tested by the development Team.
<br>
<br>

Run `flutter pub get` in project root as well as `/lib/api/` to get all dependencies.

After installation please run the following command to generate the IconPack for the IconPicker used in the Folder
Create and Update page.

Otherwise it will remain empty.

```bash
dart run flutter_iconpicker:generate_packs --packs material
```

<br>

To start the app execute `flutter run` in your terminal at the project root and select the (virtual) device you want to
run the app on.
<br>
<br>

In debug mode, the Backend URL is overriden in the file `/lib/Utility/request_utility.dart` using the variable
`basePath`.
<br>
When using your own backend server, please update this string.
<br>
<br>
In case of problems, please feel free to open an issue or contact the development team in another way.

## File Structure

The dart files containing the cross-platform code are located in `/lib`.

## Testing Biometrics

### Android Emulator

1. SetUp Finger Print in `Security & Privacy` -> `Device Unlock`-> `add Fingerprint`
2. Authenticate via Finger Print using `...` in the Side Menu und navigating to `Fingerprint`

### iOS

Note: iOS 18.0 Simulator is bugged. Use 18.1 or <18.0

1. Mac Top Bar `Features` -> `Face ID` or `Touch ID` -> `Enable`
2. Authenticate via Finger Print using same Menu with `Matching Face`

### Mac

Nothing to set up. Uses System Biometrics.

## Localization

This project generates localized messages based on arb files found in
the `/lib/src/localization` directory.

## Usage of Swagger

### Perform this only when something changed in the backend.

The API endpoints interfaces are auto-generated using swagger and located in `/lib/api`. <br>
To update the API Client paste the new `swagger.yaml` in `/openapi/` and run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Which Variables are located in the Storage of the secure Storage and share Preferences?

#### Secure Storage

| Variable Name       | Description                                                      | Key                 | Storage Type   |
|---------------------|------------------------------------------------------------------|---------------------|----------------|
| `encryptionKDF`     | The encryption Key Derivation Function used for encrypting data. | `encryptionKDF`     | Secure Storage |
| `username`          | The username of the authenticated user.                          | `username`          | Secure Storage |
| `refreshToken`      | The refresh token used to obtain new access tokens.              | `refreshToken`      | Secure Storage |
| `refreshExpiration` | The expiration timestamp of the refresh token.                   | `refreshExpiration` | Secure Storage |
| `validationHash`    | The hash used to validate the user's encryptionKDF.              | `validationHash`    | Secure Storage |

#### Shared Preferences

| Variable Name          | Description                                                     | Key                    | Storage Type       |
|------------------------|-----------------------------------------------------------------|------------------------|--------------------|
| `themeMode`            | The theme mode selected by the user (e.g., light or dark mode). | `themeMode`            | Shared Preferences |
| `language_code`        | The language selected by the user for the app interface.        | `language_code`        | Shared Preferences |
| `countryCode`          | The country code selected by the user for the app interface.    | `countryCode`          | Shared Preferences |
| `biometricEnabled`     | A flag indicating whether the user has enabled biometrics.      | `biometricEnabled`     | Shared Preferences |
| `notificationsEnabled` | A flag indicating whether the user has enabled notifications.   | `notificationsEnabled` | Shared Preferences |

### Singleton Pattern

The `AuthenticationCredentialsSingleton` class is a singleton class that stores the credentials of the authenticated
user. <br>

| Variable Name      | Description                                                              | Type    |
|--------------------|--------------------------------------------------------------------------|---------|
| `encryptionKDF`    | The encryption Key Derivation Function used for encrypting data.         | String? |
| `refreshToken`     | The refresh token used to obtain new access tokens.                      | Token?  |
| `accessToken`      | The access token used for authenticating API requests.                   | Token?  |
| `username`         | The username of the authenticated user.                                  | String? |
| `softLogout`       | A flag indicating whether the user has logged out without deleting data. | bool    |
| `skipSplashScreen` | A flag indicating whether to skip the splash screen on app startup.      | bool    |
| `validationHash`   | The hash used to validate the user's encryptionKDF.                      | String? |


