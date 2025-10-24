import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/shared/extensions/context_extensions.dart';
import 'package:doule_v/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(context.l10n.lbl_welcome, style: AppText.body),
            Text(DateFormatter.toShortDate(), style: AppText.body),
          ],
        ),
        Column(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: ClipOval(
                child: Lottie.asset(
                  'assets/lottie/profile.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
