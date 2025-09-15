class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String aadhaarNo;
  final String phoneNo;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.aadhaarNo,
    required this.phoneNo,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "full_name": fullName,
      "email": email,
      "aadhaar_no": aadhaarNo,
      "phone_no": phoneNo,
      "created_at": createdAt,
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      fullName: map["full_name"] ?? "",
      email: map["email"] ?? "",
      aadhaarNo: map["aadhaar_no"] ?? "",
      phoneNo: map["phone_no"]?.toString() ?? "",
      createdAt: (map["created_at"]).toDate(),
    );
  }
}
