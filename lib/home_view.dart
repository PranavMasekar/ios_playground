import 'package:flutter/material.dart';
import 'package:ios_playground/airplay_api.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      await _loadAudio();
    } catch (e) {
      debugPrint('Audio player initialization failed: $e');
    }
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(
            'https://drive.google.com/uc?export=download&id=1Zyeml6K6h737DfebuQnQwgb8MyW95O9z',
          ),
        ),
      );
      debugPrint('Audio loaded successfully');
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        setState(() {
          _isPlaying = true;
        });
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error toggling playback: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: ShadCard(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Audio Player',
                      style: ShadTheme.of(context).textTheme.h3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShadButton(
                    onPressed: _togglePlayPause,
                    size: ShadButtonSize.lg,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(_isPlaying ? 'Pause' : 'Play'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ShadButton.secondary(
                    onPressed: () {
                      AirplayApi().startAirplay();
                    },
                    child: const Icon(Icons.airplay_rounded, size: 28),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
