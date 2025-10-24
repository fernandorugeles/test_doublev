import 'package:doule_v/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
