import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/feature/search_user/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:doule_v/feature/footer/app_footer.dart';
import 'package:doule_v/feature/header/app_header.dart';

class SearchUserDasboardScreen extends StatefulWidget {
  const SearchUserDasboardScreen({super.key});

  @override
  State<SearchUserDasboardScreen> createState() =>
      _SearchUserDasboardScreenState();
}

class _SearchUserDasboardScreenState extends State<SearchUserDasboardScreen> {
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
              SizedBox(height: 24),
              Expanded(child: UserListScreen()),
              AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
