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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
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
      appBar: AppBar(
        title: const Text("🚌 Bus Stops"),
        centerTitle: true,
        elevation: 4,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                hintText: "Search bus stops...",
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterStops,
            ),
          ),

          Expanded(
            child: filteredStops.isEmpty
                ? const Center(
                    child: Text(
                      "No stops found 🚫",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    itemCount: filteredStops.length,
                    itemBuilder: (context, index) {
                      final stop = filteredStops[index];
                      final isFav = favorites.contains(stop.stopname);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blueAccent,
                            child: const Icon(Icons.location_on, color: Colors.white),
                          ),
                          title: Text(
                            stop.stopname,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "ETA: ${stop.timedifference} mins",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          trailing: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey.shade600,
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
