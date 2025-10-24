import 'package:doule_v/models/api_response.dart';
import 'package:doule_v/models/location.dart';
import 'package:doule_v/service/database_service.dart';

class LocationService {
  final DatabaseService _dbService = DatabaseService();

  Future<ApiResponse<List<Location>>> getAllLocations() async {
    try {
      final db = await _dbService.database;
      final result = await db.query('locations');

      final locations = result.map((l) => Location.fromJson(l)).toList();

      return ApiResponse.success(locations);
    } catch (e) {
      return ApiResponse.error(
        e.toString(),
        message: 'Error getting locations',
      );
    }
  }

  Future<ApiResponse<List<Location>>> getCountries() async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        'locations',
        where: 'country IS NULL AND department IS NULL',
      );

      final countries = result.map((l) => Location.fromJson(l)).toList();
      return ApiResponse.success(countries);
    } catch (e) {
      return ApiResponse.error(
        e.toString(),
        message: 'Error getting countries',
      );
    }
  }

  Future<ApiResponse<List<Location>>> getDepartmentsByCountry(
    int countryId,
  ) async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        'locations',
        where: 'country = ? AND department IS NULL',
        whereArgs: [countryId],
      );

      final departments = result.map((l) => Location.fromJson(l)).toList();
      return ApiResponse.success(departments);
    } catch (e) {
      return ApiResponse.error(
        e.toString(),
        message: 'Error getting departments',
      );
    }
  }

  Future<ApiResponse<List<Location>>> getCitiesByDepartment(
    int departmentId,
  ) async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        'locations',
        where: 'department = ?',
        whereArgs: [departmentId],
      );

      final cities = result.map((l) => Location.fromJson(l)).toList();
      return ApiResponse.success(cities);
    } catch (e) {
      return ApiResponse.error(e.toString(), message: 'Error getting cities');
    }
  }

  Future<ApiResponse<Location?>> getLocationById(int id) async {
    try {
      final db = await _dbService.database;
      final result = await db.query(
        'locations',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) {
        return ApiResponse.success(null, message: 'Location not found');
      }

      final location = Location.fromJson(result.first);
      return ApiResponse.success(location);
    } catch (e) {
      return ApiResponse.error(e.toString(), message: 'Error getting location');
    }
  }
}
