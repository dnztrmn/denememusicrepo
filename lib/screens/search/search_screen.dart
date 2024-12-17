import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundy/screens/player/player_screen.dart';
import 'package:soundy/services/youtube_service.dart';
import 'package:soundy/utils/error_handler.dart';
import 'package:soundy/widgets/video_card.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) => _performSearch(context),
        ),
      ),
      body: Consumer<YoutubeService>(
        builder: (context, youtubeService, child) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final searchResults = youtubeService.searchResults;
          if (searchResults.isEmpty) {
            return const Center(
              child: Text('No results'),
            );
          }

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final video = searchResults[index];
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

  Future<void> _performSearch(BuildContext context) async {
    if (_searchController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final youtubeService = Provider.of<YoutubeService>(context, listen: false);
      await youtubeService.search(_searchController.text);
    } catch (e) {
      if (!mounted) return;
      handleError(context, e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}