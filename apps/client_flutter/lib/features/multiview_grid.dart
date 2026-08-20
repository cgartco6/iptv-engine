import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../ui/tv_focusable_card.dart';

class MultiViewGrid extends StatefulWidget {
  const MultiViewGrid({super.key});

  @override
  State<MultiViewGrid> createState() => _MultiViewGridState();
}

class _MultiViewGridState extends State<MultiViewGrid> {
  late List<VideoPlayerController> _controllers;

  final List<String> _sampleStreams = [
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://playertest.longtailvideo.com/adaptive/oceans/oceans.m3u8',
    'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
    'https://playertest.longtailvideo.com/adaptive/oceans/oceans.m3u8',
  ];

  @override
  void initState() {
    super.initState();
    _controllers = _sampleStreams.map((url) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      controller.initialize().then((_) => setState(() {}));
      controller.setVolume(0.0); // Mute initial multi-view cells
      controller.play();
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 16 / 9,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _controllers.length,
          itemBuilder: (context, index) {
            final controller = _controllers[index];
            return TvFocusableCard(
              onTap: () {
                // Focus audio onto selected cell
                for (var c in _controllers) {
                  c.setVolume(0.0);
                }
                controller.setVolume(1.0);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3B82F6),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
