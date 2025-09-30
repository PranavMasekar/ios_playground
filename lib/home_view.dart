import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'haptics.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadButton(
                  onPressed: () async {
                    await HapticsApi().triggerHapticFeedback('Light');
                  },
                  child: const Text('Light'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () async {
                    await HapticsApi().triggerHapticFeedback('Medium');
                  },
                  child: const Text('Medium'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () async {
                    await HapticsApi().triggerHapticFeedback('Heavy');
                  },
                  child: const Text('Heavy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
