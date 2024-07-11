import 'package:flutter/material.dart';
import 'models/gempa.dart';

class DetailPage extends StatelessWidget {
  final Gempa gempa;

  const DetailPage({Key? key, required this.gempa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Gempa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Magnitude: ${gempa.magnitude}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Tanggal: ${gempa.tanggal}'),
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
          ],
        ),
      ),
    );
  }
}
