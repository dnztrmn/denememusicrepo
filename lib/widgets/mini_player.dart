import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/audio_service.dart';

class MiniPlayer extends StatefulWidget {
  final Video video;
  final VoidCallback onTap;

  const MiniPlayer({
    Key? key,
    required this.video,
    required this.onTap,
  }) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final AudioPlayerService _audioService = AudioPlayerService();
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 60,
        color: Theme.of(context).cardColor,
        child: Row(
          children: [
            Image.network(
              widget.video.thumbnail,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.video.channelTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
                _isPlaying ? _audioService.play() : _audioService.pause();
              },
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _audioService.stop();
                // Close mini player logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
