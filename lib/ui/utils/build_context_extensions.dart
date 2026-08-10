// extension IntExtensions on int {
//   isMoreThan5() => this > 5;
// }
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}
