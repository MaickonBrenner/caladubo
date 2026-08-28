import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tutorialConteudo.dart';
import '../main.dart';

class TutorialOnboardingPage extends StatefulWidget {
  const TutorialOnboardingPage({super.key});

  @override
  State<TutorialOnboardingPage> createState() => _TutorialOnboardingPageState();
}

class _TutorialOnboardingPageState extends State<TutorialOnboardingPage> {
  final Color verdeCaladubo = const Color.fromRGBO(126, 175, 49, 1);
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  Future<void> _finalizarTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_visto', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool ultimaPagina = _paginaAtual == passosTutorial.length - 1;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 236, 217, 1),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _finalizarTutorial(),
                child: Text("Pular", style: TextStyle(color: verdeCaladubo)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: passosTutorial.length,
                onPageChanged: (index) => setState(() => _paginaAtual = index),
                itemBuilder: (context, index) {
                  final passo = passosTutorial[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(passo.icone, size: 100, color: verdeCaladubo),
                        const SizedBox(height: 30),
                        Text(
                          passo.titulo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          passo.descricao,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                passosTutorial.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _paginaAtual == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _paginaAtual == index
                        ? verdeCaladubo
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verdeCaladubo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (ultimaPagina) {
                      _finalizarTutorial();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    ultimaPagina ? "Começar" : "Próximo",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
