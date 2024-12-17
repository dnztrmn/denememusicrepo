import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundy/screens/player/player_screen.dart';
import 'package:soundy/services/youtube_service.dart';
import 'package:soundy/widgets/video_card.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<YoutubeService>(context, listen: false).loadSavedVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Consumer<YoutubeService>(
        builder: (context, youtubeService, child) {
          final videos = youtubeService.savedVideos;
          
          if (videos.isEmpty) {
            return const Center(
              child: Text('No saved videos'),
            );
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return VideoCard(
                title: video.title,
                subtitle: video.author,
                thumbnailUrl: video.thumbnails.mediumResUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        videoId: video.id.toString(),
                        title: video.title,
                        author: video.author,
                        thumbnailUrl: video.thumbnails.mediumResUrl,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}