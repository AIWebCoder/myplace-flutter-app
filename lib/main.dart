import 'dart:async';

import 'package:flutter/material.dart';
import 'package:x_place/auth/loginPage.dart';
import 'package:x_place/home/bottom_bar_screen.dart';
import 'package:x_place/utils/appRoutes.dart';
import 'package:x_place/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:x_place/services/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await dotenv.load();  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'X Place',
        debugShowCheckedModeBanner: false,
        theme: ThemeController().darkTheme(),
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), _checkAuthAndNavigate);
  }

  void _checkAuthAndNavigate() async {
    final auth = Provider.of<Auth>(context, listen: false);
    await auth.initAuth();

    await Future.delayed(const Duration(seconds: 2)); 

    if (!mounted) return;

    if (auth.authenticated) {
      AppRoutes.replace(context, const BottomBarScreen()); 
    } else {
      AppRoutes.replace(context, LoginPageScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0f0f0f), Color(0xff2b2b2b)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 230,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
