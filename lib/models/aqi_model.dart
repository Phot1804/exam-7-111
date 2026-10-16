class AqiModel {
  String? id;
  String stationId;
  String zone;
  String safetyEmail;
  double aqi;
  double pm25;

  AqiModel({
    this.id,
    required this.stationId,
    required this.zone,
    required this.safetyEmail,
    required this.aqi,
    required this.pm25,
  });

  // แปลงจาก Firestore Document เป็น AqiModel
  factory AqiModel.fromMap(String id, Map<String, dynamic> map) {
    return AqiModel(
      id: id,
      stationId: map['stationId'] ?? '',
      zone: map['zone'] ?? '',
      safetyEmail: map['safetyEmail'] ?? '',
      aqi: (map['aqi'] ?? 0).toDouble(),
      pm25: (map['pm25'] ?? 0).toDouble(),
    );
  }

  // แปลงจาก AqiModel เป็น Map เพื่อบันทึก/แก้ไขลง Firestore
  Map<String, dynamic> toMap() {
    return {
      'stationId': stationId,
      'zone': zone,
      'safetyEmail': safetyEmail,
      'aqi': aqi,
      'pm25': pm25,
      'updatedAt': DateTime.now(),
    };
  }
}