import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'live_activity_api.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const int _maxSeconds = 20 * 60;

  final LiveActivityApi _liveActivityApi = LiveActivityApi();
  Timer? _tickTimer;
  int _remainingSeconds = _maxSeconds;
  bool _isRunning = false;
  bool _isLiveActivityActive = false;

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });

    if (!_isLiveActivityActive) {
      try {
        await _liveActivityApi.startLiveActivity();
        setState(() {
          _isLiveActivityActive = true;
        });
      } catch (_) {
        // Best-effort: keep UI responsive if platform call fails
      }
    }

    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
          _isRunning = false;
        });
        _stopLiveActivityIfActive();
      } else {
        setState(() {
          _remainingSeconds -= 1;
        });
      }
    });
  }

  Future<void> _stop() async {
    if (!_isRunning) return;
    _tickTimer?.cancel();
    _tickTimer = null;
    _remainingSeconds = _maxSeconds;
    setState(() {
      _isRunning = false;
    });
    await _stopLiveActivityIfActive();
  }

  Future<void> _stopLiveActivityIfActive() async {
    if (!_isLiveActivityActive) return;
    try {
      await _liveActivityApi.stopLiveActivity();
    } catch (_) {
      // Ignore platform errors for UI flow
    }
    setState(() {
      _isLiveActivityActive = false;
    });
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final String mm = minutes.toString().padLeft(2, '0');
    final String ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = ShadTheme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text('iOS Playground', style: textTheme.h2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_formatTime(_remainingSeconds), style: textTheme.h1),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShadButton(
                    onPressed: _isRunning ? null : _start,
                    child: Text(_isRunning ? 'Running' : 'Start'),
                  ),
                  const SizedBox(width: 16),
                  ShadButton.outline(
                    onPressed: _isRunning ? _stop : null,
                    child: const Text('Stop'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
