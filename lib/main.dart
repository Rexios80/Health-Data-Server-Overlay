import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/firebase/firebase_utils_stub.dart'
    if (dart.library.js) 'package:hds_overlay/firebase/firebase_utils.dart';
import 'package:hds_overlay/utils/splash_fix_stub.dart'
    if (dart.library.js) 'package:hds_overlay/utils/splash_fix.dart';
import 'package:hds_overlay/utils/themes.dart';
import 'package:hds_overlay/view/routes.dart';
import 'package:hds_overlay/view/screens/credits.dart';
import 'package:hds_overlay/view/screens/overlay.dart';
import 'package:hds_overlay/view/screens/privacy_policy.dart';
import 'package:hds_overlay/view/screens/settings_view.dart';
import 'package:hds_overlay/view/screens/terms.dart';
import 'package:lifecycle/lifecycle.dart';

import 'controllers/settings_controller.dart';
import 'hive/hive_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hive = Get.put(HiveUtils());
  await hive.init();

  final SettingsController settingsController = Get.find();
  final FirebaseUtils firebase = Get.put(FirebaseUtils());

  firebase.init();

  // Only init Firebase if the user has it enabled
  if (kIsWeb && settingsController.settings.value.hdsCloud) {
    // This will not work on other platforms
    // We must check kIsWeb first of Flutter web will complain
    await firebase.signIn();
  }

  runApp(HDS());
}

class HDS extends StatelessWidget {
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = Get.put(FirebaseAnalytics());

    hideSplash();

    return GetMaterialApp(
      navigatorObservers: <NavigatorObserver>[defaultLifecycleObserver] +
          (kIsWeb ? [FirebaseAnalyticsObserver(analytics: analytics)] : []),
      title: 'Health Data Server',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: settingsController.settings.value.darkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: Routes.overlay,
      getPages: [
        GetPage(name: Routes.overlay, page: () => HDSOverlay()),
        GetPage(name: Routes.settings, page: () => SettingsView()),
        GetPage(name: Routes.privacyPolicy, page: () => PrivacyPolicy()),
        GetPage(name: Routes.terms, page: () => Terms()),
        GetPage(name: Routes.credits, page: () => Credits()),
        GetPage(name: Routes.licenses, page: () => LicensePage()),
      ],
    );
  }
}
