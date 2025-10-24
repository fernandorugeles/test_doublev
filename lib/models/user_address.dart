class UserAddress {
  final int? id;
  final int? userId;
  final int locationId;
  final String address;
  final String? countryName;
  final String? cityName;
  final String? departmentName;

  UserAddress({
    this.id,
    this.userId,
    required this.locationId,
    required this.address,
    this.cityName,
    this.departmentName,
    this.countryName,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    print("row ${json}");
    return UserAddress(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      locationId: json['locationId'] as int,
      address: json['address'] as String,
      countryName: json['countryName'] as String,
      departmentName: json['departmentName'] as String,
      cityName: json['cityName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'locationId': locationId,
      'address': address,
    };
  }
}
