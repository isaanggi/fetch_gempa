// Import library
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail.dart';

void main() {
  runApp(FetchGempa()); // Menjalankan aplikasi
}

// Kelas untuk merepresentasikan data gempa
class Gempa {
  late String tanggal;
  late String jam;
  late String coordinates;
  late String lintang;
  late String bujur;
  late String magnitude;
  late String kedalaman;
  late String wilayah;
  late String potensi;

  // Konstruktor untuk membuat objek Gempa
  Gempa({
    required this.tanggal,
    required this.jam,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
  });

  // Factory method untuk mengonversi JSON menjadi objek Gempa
  factory Gempa.fromJson(Map<String, dynamic> json) {
    return Gempa(
      tanggal: json['Tanggal'],
      jam: json['Jam'],
      coordinates: json['Coordinates'],
      lintang: json['Lintang'],
      bujur: json['Bujur'],
      magnitude: json['Magnitude'],
      kedalaman: json['Kedalaman'],
      wilayah: json['Wilayah'],
      potensi: json['Potensi'],
    );
  }
}

// Kelas utama untuk mengambil dan menampilkan data gempa
class FetchGempa extends StatefulWidget {
  @override
  _FetchGempaState createState() => _FetchGempaState();
}

// Kelas state yang mengatur tampilan dan logika FetchGempa
class _FetchGempaState extends State<FetchGempa> {
  List<Gempa> earthquakes = []; // List untuk menyimpan data gempa

  @override
  void initState() {
    super.initState();
    // Memuat data gempa saat widget pertama kali diinisialisasi
    fetchGempaData();
  }

  // Fungsi untuk Memuat data gempa dari API BMKG
  Future<void> fetchGempaData() async {
    // Mengambil data dari URL API BMKG
    final response = await http.get(
        Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/gempaterkini.json'));

    if (response.statusCode == 200) {
      List<Gempa> temp = []; // List sementara untuk menyimpan data gempa
      final jsonData = json.decode(response.body); // Dekode response JSON
      final gempa =
          // Mendapatkan daftar data gempa
          jsonData['Infogempa']['gempa'];
      for (var item in gempa) {
        // Menambahkan data gempa ke dalam list sementara
        temp.add(Gempa.fromJson(item));
      }
      setState(() {
        // Menyimpan list data gempa ke dalam state dan memperbarui tampilan
        earthquakes = temp;
      });
    } else {
      throw Exception(
          // Exception jika gagal memuat data
          'Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Gempa'),
          backgroundColor: Colors.green,
        ),
        // Membuat list
        body: ListView.builder(
          // Menyesuaikan perhitungan itemCount
          itemCount: earthquakes.isEmpty ? 0 : earthquakes.length * 2 - 1,
          itemBuilder: (BuildContext context, int index) {
            if (index.isOdd) return Divider(); // Menambahkan pembatas
            final int itemIndex = index ~/ 2; // Menghitung indeks item
            return ListTile(
              title: Text('Tanggal: ${earthquakes[itemIndex].tanggal}'),
              subtitle: Text('Wilayah: ${earthquakes[itemIndex].wilayah}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      tanggal: earthquakes[itemIndex].tanggal,
                      jam: earthquakes[itemIndex].jam,
                      coordinates: earthquakes[itemIndex].coordinates,
                      lintang: earthquakes[itemIndex].lintang,
                      bujur: earthquakes[itemIndex].bujur,
                      magnitude: earthquakes[itemIndex].magnitude,
                      kedalaman: earthquakes[itemIndex].kedalaman,
                      wilayah: earthquakes[itemIndex].wilayah,
                      potensi: earthquakes[itemIndex].potensi,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
