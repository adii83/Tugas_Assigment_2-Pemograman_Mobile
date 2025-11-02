import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Theater extends StatefulWidget {
  const Theater({super.key});

  @override
  State<Theater> createState() => _TheaterState();
}

class _TheaterState extends State<Theater> {
  String location = "Mendeteksi lokasi...";
  final List<String> theaterList = [
    "XI CINEMA",
    "PONDOK KELAPA 21",
    "CGV",
    "CINEPOLIS",
    "CP MALL",
    "HERMES",
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => location = "Service lokasi tidak aktif");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => location = "Izin lokasi ditolak");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => location = "Izin lokasi permanen ditolak");
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      location =
          "Lat: ${pos.latitude.toStringAsFixed(4)}, Lon: ${pos.longitude.toStringAsFixed(4)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("THEATER")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 10),
              Expanded(
                child: Text(location, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (var t in theaterList)
            Card(
              child: ListTile(
                title: Text(
                  t,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
        ],
      ),
    );
  }
}
