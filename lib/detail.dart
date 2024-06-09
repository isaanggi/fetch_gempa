// Halaman detail gempa
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String tanggal;
  final String jam;
  final String coordinates;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;
  final String potensi;

  const DetailPage({
    Key? key,
    required this.tanggal,
    required this.jam,
    required this.coordinates,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
    required this.potensi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Gempa'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: $tanggal'),
            Text('Jam: $jam'),
            Text('Coordinates: $coordinates'),
            Text('Lintang: $lintang'),
            Text('Bujur: $bujur'),
            Text('Magnitude: $magnitude'),
            Text('Kedalaman: $kedalaman'),
            Text('Wilayah: $wilayah'),
            Text('Potensi: $potensi'),
          ],
        ),
      ),
    );
  }
}
