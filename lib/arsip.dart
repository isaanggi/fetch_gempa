import 'package:flutter/material.dart';
import 'models/gempa.dart';
import 'detail.dart';
import 'dart:convert'; // untuk mengelola JSON
import 'package:http/http.dart' as http; // untuk request HTTP

class ArsipScreen extends StatefulWidget {
  final Future<List<Gempa>> arsipGempa;

  const ArsipScreen({Key? key, required this.arsipGempa}) : super(key: key);

  @override
  _ArsipScreenState createState() => _ArsipScreenState();
}

class _ArsipScreenState extends State<ArsipScreen> {
  late Future<List<Gempa>> _futureArsipGempa;

  @override
  void initState() {
    super.initState();
    _futureArsipGempa = widget.arsipGempa;
  }

  Future<void> _refreshArsipGempa() async {
    setState(() {
      _futureArsipGempa = fetchArsipGempa();
    });
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
          'Archive Gempa',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArsipGempa,
        child: FutureBuilder<List<Gempa>>(
          future: _futureArsipGempa,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshArsipGempa,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
