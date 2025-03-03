import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_notes/src/rust/frb_generated.dart';
import 'package:shadow_notes/src/splash/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  
  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const ShadowNotesApp());
}

class ShadowNotesApp extends StatelessWidget {
  const ShadowNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadowNotes',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }
}