import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/shared/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.manage_search_outlined,
                  color: AppColors.initial,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/search_users');
                },
              ),
              Text(
                context.l10n.lbl_search_users,
                style: AppText.caption.merge(
                  AppText.fontSize(14).merge(AppText.bold),
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home_max_sharp,
                  color: AppColors.initial,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
              Text(
                context.l10n.lbl_home,
                style: AppText.caption.merge(
                  AppText.fontSize(14).merge(AppText.bold),
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.camera_front_rounded,
                  color: AppColors.initial,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/create_users');
                },
              ),
              Text(
                context.l10n.lbl_create_users,
                style: AppText.caption.merge(
                  AppText.fontSize(14).merge(AppText.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
