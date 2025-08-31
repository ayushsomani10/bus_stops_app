import 'package:flutter/material.dart';
import 'models/stop.dart';
import 'services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final Stop stop;
  const DetailScreen({super.key, required this.stop});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFav();
  }

  Future<void> _loadFav() async {
    final favs = await FavoriteService.getFavorites();
    setState(() {
      isFav = favs.contains(widget.stop.stopname);
    });
  }

  Future<void> _toggleFav() async {
    await FavoriteService.toggleFavorite(widget.stop.stopname);
    _loadFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.stop.stopname)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Latitude: ${widget.stop.latitude}"),
            Text("Longitude: ${widget.stop.longitude}"),
            Text("ETA: ${widget.stop.timedifference} mins"),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleFav,
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
              label: Text(isFav ? "Remove Favorite" : "Add Favorite"),
            ),
          ],
        ),
      ),
    );
  }
}
