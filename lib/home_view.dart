import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'iOS Playground',
          style: ShadTheme.of(context).textTheme.h2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Pranav Masekar',
                style: ShadTheme.of(context).textTheme.h2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
