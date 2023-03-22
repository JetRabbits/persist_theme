import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_model.dart';

class ThemeProvider extends StatelessWidget {
  final ThemeModel model;
  final Widget child;
  final bool init;
  const ThemeProvider({
    Key? key,
    /*required*/ required this.model,
    /*required*/ required this.child,
    this.init = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => model,
      child: child,
    );
  }
}
