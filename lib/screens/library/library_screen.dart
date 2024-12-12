import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundy/services/youtube_service.dart';
import 'package:soundy/widgets/video_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
                thumbnailUrl: video.thumbnailUrl,
                onTap: () {
                  // Navigate to player
                },
              );
            },
          );
        },
      ),
    );
  }
}
