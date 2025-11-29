import 'package:flutter/material.dart';
import 'package:gold_monkey/core/theme/app_theme.dart';
import 'package:gold_monkey/viewmodels/auth_viewmodel.dart';
import 'package:gold_monkey/viewmodels/profile_viewmodel.dart';
import 'package:gold_monkey/views/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(GoldMonkeyApp());
}

class GoldMonkeyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => ProfileViewmodel()),
      ],
      child: MaterialApp(
        title: "Gold Monkey",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: LoginScreen(),
      ),
    );
  }
}
