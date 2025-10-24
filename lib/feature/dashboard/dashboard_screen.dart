import 'package:doule_v/feature/header/app_header.dart';
import 'package:doule_v/models/dasboard.dart';
import 'package:flutter/material.dart';
import 'package:doule_v/constants/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:doule_v/shared/extensions/context_extensions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Dashboard> menu;

  void _goTo(String screen) {
    if (screen.isEmpty) return;
    Navigator.pushNamed(context, screen);
  }

  @override
  Widget build(BuildContext context) {
    menu = [
      Dashboard(
        name: context.l10n.lbl_create_users,
        link: '/create_users',
        icon: 'assets/lottie/users.json',
      ),
      Dashboard(
        name: context.l10n.lbl_search_users,
        link: '/search_users',
        icon: 'assets/lottie/search_users.json',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppMeasures.paddingApp,
          child: Column(
            children: [
              const AppHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                  children: menu.map((item) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _goTo(item.link),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Lottie.asset(
                                  item.icon,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: AppText.body,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
