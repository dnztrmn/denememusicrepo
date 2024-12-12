import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final String title;
  final String author;
  final String thumbnailUrl;
  final VoidCallback onTap;

  const MiniPlayer({
    Key? key,
    required this.audioPlayer,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state.playing);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 60,
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Row(
          children: [
            Image.network(
              widget.thumbnailUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                if (_isPlaying) {
                  widget.audioPlayer.pause();
                } else {
                  widget.audioPlayer.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
