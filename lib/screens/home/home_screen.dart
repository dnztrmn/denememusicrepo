import 'package:flutter/material.dart';
import '../../services/youtube_service.dart';
import '../../widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final YouTubeService _youtubeService = YouTubeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Music Clone'),
      ),
      body: FutureBuilder(
        future: _youtubeService.getTrendingMusic(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final videos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return VideoCard(video: videos[index]);
            },
          );
        },
      ),
    );
  }
}
