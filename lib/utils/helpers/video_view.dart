import 'package:company/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key, required this.video});
  final String video;
  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final VideoPlayerController _playerController;

  final GlobalKey<State<StatefulWidget>> _videoKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    _playerController = VideoPlayerController.asset(widget.video);
    super.initState();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: transparent,
      splashColor: transparent,
      hoverColor: transparent,
      onTap: () async {
        if (!_playerController.value.isInitialized) {
          await _playerController.initialize();
        }
        _playerController.value.isPlaying ? await _playerController.pause() : await _playerController.play();
        _videoKey.currentState!.setState(() {});
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(15)),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            VideoPlayer(_playerController),
            IgnorePointer(
              child: StatefulBuilder(
                key: _videoKey,
                builder: (BuildContext context, void Function(void Function()) _) {
                  return _playerController.value.isPlaying
                      ? const Icon(
                          FontAwesome.circle_pause_solid,
                          color: white,
                          size: 48,
                        ).animate(key: ValueKey<bool>(_playerController.value.isPlaying)).fadeOut()
                      : const Icon(
                          FontAwesome.circle_play_solid,
                          color: white,
                          size: 48,
                        ).animate(key: ValueKey<bool>(_playerController.value.isPlaying)).fadeIn();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
