class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'Admin' หรือ 'Operator'

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  // Alias สำหรับเรียกใช้ user.id
  String get id => uid;

  // แปลงจาก Firestore Map เป็น UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Operator',
    );
  }

  // แปลงจาก UserModel เป็น Map เพื่อบันทึกลง Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}