class Gempa {
  final String tanggal;
  final String jam;
  final String coordinates;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;
  final String potensi;
  final String dirasakan;
  final String shakemap;
  final String shakemapUrl;
  final bool hasShakemap;

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
    required this.dirasakan,
    required this.shakemap,
    required this.shakemapUrl,
    required this.hasShakemap,
  });

  factory Gempa.fromJson(Map<String, dynamic> json) {
    return Gempa(
      tanggal: json['Tanggal'] ?? '',
      jam: json['Jam'] ?? '',
      coordinates: json['Coordinates'] ?? '',
      lintang: json['Lintang'] ?? '',
      bujur: json['Bujur'] ?? '',
      magnitude: json['Magnitude'] ?? '',
      kedalaman: json['Kedalaman'] ?? '',
      wilayah: json['Wilayah'] ?? '',
      potensi: json['Potensi'] ?? '',
      dirasakan: json['Dirasakan'] ?? '',
      shakemap: json['Shakemap'] ?? '',
      shakemapUrl: (json['Shakemap'] != null && json['Shakemap'] != '')
          ? 'https://data.bmkg.go.id/DataMKG/TEWS/${json['Shakemap']}'
          : '',
      hasShakemap: (json['Shakemap'] != null && json['Shakemap'] != ''),
    );
  }
}
