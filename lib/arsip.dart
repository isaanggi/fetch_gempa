import 'package:flutter/material.dart';
import 'models/gempa.dart';
import 'detail.dart';

class ArsipScreen extends StatelessWidget {
  final Future<List<Gempa>> arsipGempa;

  const ArsipScreen({Key? key, required this.arsipGempa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive Gempa'),
      ),
      body: FutureBuilder<List<Gempa>>(
        future: arsipGempa,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Gempa> gempas = snapshot.data!;

            return Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: gempas.length,
                itemBuilder: (context, index) {
                  final gempa = gempas[index];
                  return ListTile(
                    title: Text('Magnitude: ${gempa.magnitude}'),
                    subtitle: Text('Tanggal: ${gempa.tanggal}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            gempa: gempa,
                          ),
                        ),
                      );
                    },
                    trailing: ElevatedButton(
                      child: Text('Detail'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              gempa: gempa,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
