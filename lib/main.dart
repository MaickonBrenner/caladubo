import 'dart:io'; // Importante para detectar a plataforma
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Nova importação
import 'package:shared_preferences/shared_preferences.dart';
import 'views/dashboard.dart';
import 'views/tutorialOnboardingPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caladubo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(126, 175, 49, 1),
          primary: const Color.fromRGBO(126, 175, 49, 1),
          surface: const Color.fromRGBO(251, 236, 217, 1),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(251, 236, 217, 1),
        fontFamily: 'Montserrat',
        useMaterial3: true,
      ),
      home:
          const _StartupDecider(), // trocando WelcomePage por _StartupDecider()
      debugShowCheckedModeBanner: false,
    );
  }
}

class _StartupDecider extends StatefulWidget {
  const _StartupDecider();

  @override
  State<_StartupDecider> createState() => _StartupDeciderState();
}

class _StartupDeciderState extends State<_StartupDecider> {
  bool? _jaViuTutorial;

  @override
  void initState() {
    super.initState();
    _checarPrimeiroUso();
  }

  Future<void> _checarPrimeiroUso() async {
    final prefs = await SharedPreferences.getInstance();
    final visto = prefs.getBool('tutorial_visto') ?? false;
    if (!mounted) return;
    setState(() => _jaViuTutorial = visto);
  }

  @override
  Widget build(BuildContext context) {
    if (_jaViuTutorial == null) {
      return const Scaffold(
        backgroundColor: Color.fromRGBO(251, 236, 217, 1),
        body: Center(
          child:
              CircularProgressIndicator(color: Color.fromRGBO(126, 175, 49, 1)),
        ),
      );
    }
    return _jaViuTutorial!
        ? const WelcomePage()
        : const TutorialOnboardingPage();
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Bem vindo(a) ao',
                  style: TextStyle(
                    color: Color.fromRGBO(34, 29, 12, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  "assets/images/logo.png",
                  width: 250,
                  height: 250,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.eco,
                      size: 150,
                      color: Color.fromRGBO(126, 175, 49, 1)),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Iniciar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
