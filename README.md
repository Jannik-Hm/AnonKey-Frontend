# Anonkey Frontend

Flutter project files for the AnonKey Frontend.

## Flutter Installation

Please install the Flutter IDE and SDK using [this Guide](https://docs.flutter.dev/get-started/install) after reading the following.

Currently tested platforms for running and testing the app:
- Android (recommended on Windows)
- iOS
- MacOS (needs a Signing Certificate in Xcode -> Open `/macos/Runner.xcodeproj` -> `Signing & Capabilities` -> `Select Team` and `Enable Development Signing`)

### !!!Not working due to CORS: Web (Chrome)!!!

Other platforms may work but aren't tested by the development Team.
<br>
<br>
After installation please run the following command to generate the IconPack for the IconPicker used in the Folder Create and Update page.

Otherwise it will remain empty.

```bash
dart run flutter_iconpicker:generate_packs --packs material
```
<br>

To start the app execute `flutter run` in your terminal at the project root and select the (virtual) device you want to run the app on.
<br>
<br>

In debug mode, the Backend URL is overriden in the file `/lib/Utility/request_utility.dart` using the variable `basePath`.
<br>
When using your own backend server, please update this string.
<br>
<br>
In case of problems, please feel free to open an issue or contact the development team in another way.

## File Structure

The dart files containing the cross-platform code are located in `/lib`.

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
