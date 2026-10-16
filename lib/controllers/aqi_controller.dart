import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/aqi_model.dart';

class AqiController {
  // อ้างอิงไปยัง Collection 'aqi_stations' บน Cloud Firestore
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('aqi_stations');

  // 1. CREATE: บันทึกข้อมูลสถานีตรวจวัดใหม่
  Future<void> addStation(AqiModel data) async {
    await _collection.add(data.toMap());
  }

  // 2. READ: ดึงข้อมูลแบบ Real-time Stream
  Stream<List<AqiModel>> getStationsStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AqiModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // 3. UPDATE: แก้ไขข้อมูลสถานีตาม Document ID
  Future<void> updateStation(String id, AqiModel data) async {
    await _collection.doc(id).update(data.toMap());
  }

  // 4. DELETE: ลบข้อมูลสถานีตาม Document ID
  Future<void> deleteStation(String id) async {
    await _collection.doc(id).delete();
  }
}