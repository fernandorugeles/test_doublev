class Location {
  final int? id;
  final int? country;
  final int? department;
  final int? city;
  final String? name;
  final String? address;
  final String? countryName;
  final String? departmentName;
  final String? cityName;

  Location({
    this.id,
    this.country,
    this.department,
    this.city,
    this.name,
    this.address,
    this.countryName,
    this.departmentName,
    this.cityName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int?,
      country: json['country'] as int?,
      department: json['department'] as int?,
      city: json['city'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      countryName: json['countryName'] as String?,
      departmentName: json['departmentName'] as String?,
      cityName: json['cityName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'department': department,
      'city': city,
      'name': name,
      'address': address,
      'countryName': countryName,
      'departmentName': departmentName,
      'cityName': cityName,
    };
  }
}
