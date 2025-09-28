import 'package:flutter/material.dart';
import 'package:ios_playground/home_view.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      themeMode: ThemeMode.light,
      title: 'iOS Playground',
      home: const HomeView(),
    );
  }
}
