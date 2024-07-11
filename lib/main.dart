import 'package:flutter/material.dart'; // untuk paket dasar material Flutter
import 'dart:convert'; // untuk mengelola JSON
import 'package:http/http.dart' as http; // untuk request HTTP
import 'models/gempa.dart'; // import model
import 'arsip.dart'; // import halaman arsip
import 'detail.dart'; // import halaman detail

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Gempa', // Judul
      theme: ThemeData(
        primarySwatch: Colors.blue, // Warna tema
      ),
      home: GempaScreen(), // Halaman utama
    );
  }
}

class GempaScreen extends StatefulWidget {
  @override
  _GempaScreenState createState() => _GempaScreenState();
}

class _GempaScreenState extends State<GempaScreen> {
  late Future<Gempa> _baruGempa; // untuk data gempa terbaru
  late Future<List<Gempa>> _arsipGempa; // untuk data arsip gempa

  @override
  void initState() {
    super.initState();
    _baruGempa = fetchBaruGempa();
    _arsipGempa = fetchArsipGempa();
  }

  Future<Gempa> fetchBaruGempa() async {
    // HTTP GET request ke endpoint untuk gempa terbaru
    final response = await http
        .get(Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body); // Mendekode response JSON
      final gempaData = jsonData['Infogempa']['gempa']; // Mendapatkan data

      return Gempa.fromJson(gempaData);
    } else {
      // Jika gagal
      throw Exception('Gagal untuk load Gempa Terbaru'); // Exception error
    }
  }

  Future<List<Gempa>> fetchArsipGempa() async {
    // HTTP GET request ke endpoint untuk arsip gempa
    final response = await http.get(
        Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> gempasData = jsonData['Infogempa']['gempa'];

      return gempasData.map((e) => Gempa.fromJson(e)).toList();
    } else {
      throw Exception('Gagal untuk load Arsip Gempa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fetch Gempa',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        // Untuk menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ArsipScreen(arsipGempa: _arsipGempa)));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Gempa>(
              future: _baruGempa,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final gempa = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Magnitude: ${gempa.magnitude}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5), // Jarak 5 piksel
                      Text('Tanggal: ${gempa.tanggal}'), // Tanggal gempa
                      SizedBox(height: 5),
                      Text('Jam: ${gempa.jam}'),
                      SizedBox(height: 5),
                      Text('Koordinat: ${gempa.coordinates}'),
                      SizedBox(height: 5),
                      Text('Lintang: ${gempa.lintang}'),
                      SizedBox(height: 5),
                      Text('Bujur: ${gempa.bujur}'),
                      SizedBox(height: 5),
                      Text('Kedalaman: ${gempa.kedalaman}'),
                      SizedBox(height: 5),
                      Text('Wilayah: ${gempa.wilayah}'),
                      SizedBox(height: 5),
                      Text('Potensi: ${gempa.potensi}'),
                      SizedBox(height: 5),
                      Text('Dirasakan: ${gempa.dirasakan}'),
                      SizedBox(height: 5),
                      if (gempa.shakemap.isNotEmpty)
                        Image.network(
                          'https://data.bmkg.go.id/DataMKG/TEWS/${gempa.shakemap}',
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Gagal untuk load Shakemap Gempa'),
                        ),
                    ],
                  );
                } else {
                  return Center(child: Text('Tidak ada Data Gempa'));
                }
              },
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _baruGempa = fetchBaruGempa(); // Memuat ulang data gempa
                  });
                },
                child: Text('Refresh'), // Tombol refresh
              ),
            ),
          ],
        ),
      ),
    );
  }
}
