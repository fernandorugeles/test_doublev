import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/feature/create_user/user_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:doule_v/feature/footer/app_footer.dart';
import 'package:doule_v/feature/header/app_header.dart';

class CreateUserDasboardScreen extends StatefulWidget {
  const CreateUserDasboardScreen({super.key});

  @override
  State<CreateUserDasboardScreen> createState() =>
      _CreateUserDasboardScreenState();
}

class _CreateUserDasboardScreenState extends State<CreateUserDasboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppMeasures.paddingApp,
          child: Column(
            children: [
              AppHeader(),
              Expanded(child: UserFormScreen()),
              AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
