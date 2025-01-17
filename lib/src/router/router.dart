import 'package:anonkey_frontend/src/Auth/login_view.dart';
import 'package:anonkey_frontend/src/Auth/register_view.dart';
import 'package:anonkey_frontend/src/Auth/splash_screen_view.dart';
import 'package:anonkey_frontend/src/Credentials/credential_list_view.dart';
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/Folders/folder_view.dart';
import 'package:anonkey_frontend/src/Folders/list-entry/folder_edit.dart';
import 'package:anonkey_frontend/src/home/home.dart';
import 'package:anonkey_frontend/src/app_lifecycle_page.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:anonkey_frontend/src/settings/settings_controller.dart';
import 'package:anonkey_frontend/src/settings/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../exception/auth_exception.dart';

class AppRouter {
  AppRouter({
    required this.settingsController,
  });

  final SettingsController settingsController;

  GoRouter getRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        /* GoRoute(
          path: '/:site',
          builder: (context, state) => HomeScreen(
            controller: settingsController,
            index: int.parse(state.pathParameters['site']!),
          ),
        ), */
        GoRoute(
          name: "home",
          path: '/',
          builder: (context, state) => AppLifecyclePage(
            child: HomeScreen(
              controller: settingsController,
              index: 0,
            ),
          ),
        ),
        GoRoute(
          name: "login",
          path: '/login',
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          name: "register",
          path: "/register",
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: "/splash",
          builder: (context, state) => const SplashScreenView(),
        ),
        GoRoute(
          name: "settings",
          path: "/settings",
          builder: (context, state) =>
              SettingsView(controller: settingsController),
        ),
        GoRoute(
          path: '/folder',
          builder: (context, state) {
            final data = state.extra
                as CredentialListWidgetData; // Access the passed object
            return FolderView(
              data: data,
            );
          },
        ),
        GoRoute(
          path: '/folderDetail',
          builder: (context, state) {
            final folder = state.extra as Folder; // Access the passed object
            return FolderEditWidget(
              folder: folder,
            );
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        bool isAuthenticated = false;

        try {
          isAuthenticated = (await AuthService.getAuthenticationCredentials())
                  .accessToken
                  ?.token !=
              null;
        } on NoCredentialException catch (e) {
          if (kDebugMode) {
            print(e.errMsg());
          }
          isAuthenticated = false;
        }

        const storage = FlutterSecureStorage();

        //print(await AuthService.isSoftLogout());
        //print(!isAuthenticated);

        if (!isAuthenticated || await AuthService.isSoftLogout()) {
          if (await storage.containsKey(key: "password")) {
            return "/splash";
          } else if (state.fullPath == "/login") {
            return "/login";
          } else if (state.fullPath == "/register") {
            return "/register";
          } else {
            return "/login";
          }
        } else {
          // TODO checking the behavior of the app when the user is authenticated after starting the app
          return null; // return "null" to display the intended route without redirecting
        }
      },
    );
  }
}
