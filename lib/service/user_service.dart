import 'package:doule_v/models/api_response.dart';
import 'package:doule_v/models/user.dart';
import 'package:doule_v/models/user_address.dart';
import 'package:doule_v/service/database_service.dart';

class UserService {
  final DatabaseService _dbService = DatabaseService();

  Future<ApiResponse<int>> createUser(User user) async {
    try {
      final db = await _dbService.database;

      final userId = await db.insert('users', {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'birthDate': user.birthDate.toIso8601String(),
      });

      if (user.addresses.isNotEmpty) {
        final batch = db.batch();

        for (final addr in user.addresses) {
          batch.insert('user_addresses', {
            'userId': userId,
            'locationId': addr.locationId,
            'address': addr.address,
          });
        }

        await batch.commit(noResult: true);
      }

      return ApiResponse.success(userId, message: 'User saved successfully');
    } catch (e) {
      return ApiResponse.error(e.toString(), message: 'Error saving user');
    }
  }

  Future<ApiResponse<List<User>>> getAllUsers() async {
    try {
      final db = await _dbService.database;

      final userss = await db.query('users');
      print("Users: $userss");

      final addressess = await db.query('user_addresses');
      print("Addresses: $addressess");

      final result = await db.rawQuery('''
        SELECT 
          u.id as userId,
          u.firstName,
          u.lastName,
          u.birthDate,
          ua.id as addressId,
          ua.locationId,
          ua.address,
          city.name AS cityName,
          dept.name AS departmentName,
          country.name AS countryName
        FROM users u
        LEFT JOIN user_addresses ua ON u.id = ua.userId
        LEFT JOIN locations city ON ua.locationId = city.id
        LEFT JOIN locations dept ON city.department = dept.id
        LEFT JOIN locations country ON dept.country = country.id
      ''');

      final Map<int, User> userMap = {};

      for (var row in result) {
        final userId = row['userId'] as int;

        if (!userMap.containsKey(userId)) {
          userMap[userId] = User(
            id: userId,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            birthDate: DateTime.parse(row['birthDate'] as String),
            addresses: [],
          );
        }

        if (row['addressId'] != null) {
          final addressMap = {
            'id': row['addressId'],
            'locationId': row['locationId'],
            'address': row['address'],
            'userId': userId,
            'cityName': row['cityName'] as String?,
            'departmentName': row['departmentName'] as String?,
            'countryName': row['countryName'] as String?,
          };

          final address = UserAddress.fromJson(addressMap);
          userMap[userId]!.addresses.add(address);
        }
      }

      final users = userMap.values.toList();

      return ApiResponse.success(users);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<void>> deleteUser(int id) async {
    try {
      final db = await _dbService.database;

      await db.delete('user_addresses', where: 'userId = ?', whereArgs: [id]);
      await db.delete('users', where: 'id = ?', whereArgs: [id]);

      return ApiResponse.success(null, message: 'User deleted successfully');
    } catch (e) {
      return ApiResponse.error(e.toString(), message: 'Error deleting user');
    }
  }
}
