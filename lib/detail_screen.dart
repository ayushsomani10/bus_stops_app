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
      appBar: AppBar(
        title: Text(widget.stop.stopname),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📍 Latitude: ${widget.stop.latitude}",
                        style: const TextStyle(fontSize: 16)),
                    Text("📍 Longitude: ${widget.stop.longitude}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text("⏱ ETA: ${widget.stop.timedifference} mins",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                backgroundColor: isFav ? Colors.red : Colors.blueAccent,
              ),
              onPressed: _toggleFav,
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white),
              label: Text(
                isFav ? "Remove from Favorites" : "Add to Favorites",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
