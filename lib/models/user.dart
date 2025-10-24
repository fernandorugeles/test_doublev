import 'package:doule_v/models/user_address.dart';

class User {
  int? id;
  String firstName;
  String lastName;
  DateTime birthDate;
  List<UserAddress> addresses;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.addresses = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate']),
      addresses: (json['addresses'] != null)
          ? (json['addresses'] as List)
                .map((addr) => UserAddress.fromJson(addr))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'addresses': addresses.map((addr) => addr.toJson()).toList(),
    };
  }
}
