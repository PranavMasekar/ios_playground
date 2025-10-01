import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

const homeWidgetName = "com.example.streakWidget";
const streakCounter = "streak_counter";
const appGroupId = "group.streaks";

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await HomeWidget.setAppGroupId(appGroupId);
    final count = await HomeWidget.getWidgetData<int>(streakCounter) ?? 0;
    setState(() => _count = count);
  }

  Future<void> _increment() async {
    try {
      await HomeWidget.saveWidgetData<int>(streakCounter, _count + 1);
      await HomeWidget.updateWidget(iOSName: homeWidgetName);
      setState(() => _count = _count + 1);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _decrement() async {
    try {
      await HomeWidget.saveWidgetData<int>(streakCounter, _count - 1);
      await HomeWidget.updateWidget(iOSName: homeWidgetName);
      setState(() => _count = _count - 1);
    } catch (e) {
      log(e.toString());
    }
  }

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
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadButton(
                onPressed: _decrement,
                size: ShadButtonSize.lg,
                child: Icon(Icons.remove, size: 24),
              ),
              const SizedBox(width: 40),
              Text('$_count', style: ShadTheme.of(context).textTheme.h1),
              const SizedBox(width: 40),
              ShadButton(
                onPressed: _increment,
                size: ShadButtonSize.lg,
                child: Icon(Icons.add, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
