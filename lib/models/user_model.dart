class UserModel {
  String name;
  String email;
  String phone;
  String nim;
  String jurusan;
  String? photoUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.nim,
    required this.jurusan,
    this.photoUrl,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'nim': nim,
      'jurusan': jurusan,
      'photoUrl': photoUrl,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      nim: json['nim'] ?? '',
      jurusan: json['jurusan'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }
}
