import 'package:flutter/material.dart';
import 'models/stop.dart';
import 'services/data_service.dart';
import 'services/favorite_service.dart';
import 'detail_screen.dart';

void main() {
  runApp(const BusStopsApp());
}

class BusStopsApp extends StatelessWidget {
  const BusStopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Stops',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StopsListScreen(),
    );
  }
}

class StopsListScreen extends StatefulWidget {
  const StopsListScreen({super.key});

  @override
  State<StopsListScreen> createState() => _StopsListScreenState();
}

class _StopsListScreenState extends State<StopsListScreen> {
  List<Stop> stops = [];
  List<Stop> filteredStops = [];
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataService.loadStops();
    final favs = await FavoriteService.getFavorites();
    setState(() {
      stops = data;
      filteredStops = data;
      favorites = favs;
    });
  }

  void _filterStops(String query) {
    setState(() {
      filteredStops = stops
          .where((s) => s.stopname.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Stops")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search stops...",
              ),
              onChanged: _filterStops,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStops.length,
              itemBuilder: (context, index) {
                final stop = filteredStops[index];
                final isFav = favorites.contains(stop.stopname);
                return ListTile(
                  title: Text(stop.stopname),
                  subtitle: Text("ETA: ${stop.timedifference} mins"),
                  trailing: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(stop: stop),
                      ),
                    );
                    if (updated == true) _loadData();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
