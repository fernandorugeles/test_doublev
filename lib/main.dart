import 'package:doule_v/app.dart';
import 'package:doule_v/service/database_service.dart';
import 'package:doule_v/service/location_service.dart';
import 'package:doule_v/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void main() async {
  getIt.registerLazySingleton(() => DatabaseService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => LocationService());
  runApp(const MyApp());
}
