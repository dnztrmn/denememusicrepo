import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:soundy/services/youtube_service.dart';
import 'package:soundy/utils/error_handler.dart';

class PlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String author;
  final String thumbnailUrl;
  final String? localFilePath;

  const PlayerScreen({
    Key? key,
    required this.videoId,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    this.localFilePath,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      String audioUrl;
      if (widget.localFilePath != null) {
        audioUrl = widget.localFilePath!;
      } else {
        final youtubeService =
            Provider.of<YoutubeService>(context, listen: false);
        audioUrl = await youtubeService.getAudioUrl(widget.videoId);
      }

      await _audioPlayer.setUrl(audioUrl);
      _audioPlayer.durationStream.listen((d) {
        if (d != null && mounted) {
          setState(() => _duration = d);
        }
      });

      _audioPlayer.positionStream.listen((p) {
        if (mounted) {
          setState(() => _position = p);
        }
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() => _isPlaying = state.playing);
        }
      });

      setState(() => _isLoading = false);
      _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        handleError(context, e);
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  widget.thumbnailUrl,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.author,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    final position = Duration(seconds: value.toInt());
                    _audioPlayer.seek(position);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position)),
                      Text(_formatDuration(_duration)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        _audioPlayer.seek(
                          _position - const Duration(seconds: 10),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (_isPlaying) {
                          _audioPlayer.pause();
                        } else {
                          _audioPlayer.play();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        _audioPlayer.seek(
                          _position + const Duration(seconds: 10),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
