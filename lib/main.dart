import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_touch/app.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/code.dart';
import 'package:git_touch/models/notification.dart';
import 'package:git_touch/models/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://006354525fa244289c48169790fa3757@o71119.ingest.sentry.io/5814819';
    },
    // Init your App.
    appRunner: () async {
      GoogleFonts.config.allowRuntimeFetching = false;

      final notificationModel = NotificationModel();
      final themeModel = ThemeModel();
      final authModel = AuthModel();
      final codeModel = CodeModel();
      await Future.wait([
        themeModel.init(),
        authModel.init(),
        codeModel.init(),
      ]);

      // To match status bar color to app bar color
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));

      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => notificationModel),
          ChangeNotifierProvider(create: (context) => themeModel),
          ChangeNotifierProvider(create: (context) => authModel),
          ChangeNotifierProvider(create: (context) => codeModel),
        ],
        child: MyApp(),
      ));
    },
  );
}
