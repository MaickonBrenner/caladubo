import 'package:flutter/material.dart';
import 'gruposCulturasPage.dart';
import 'homePage.dart';
import 'analisesSalvasPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;

  final List<String> _titulos = ['CULTURAS', 'ANÁLISE', 'AJUDA'];

  void _navigateToScreen(int index) {
    setState(() {
      _index = index;
    });
  }

  Widget _buildBody() {
    switch (_index) {
      case 0: return const GruposCulturasPage();
      case 1: return const HomePage();
      case 2: return const Center(
          child: Text('Central de Ajuda\n\nEm breve tutoriais de uso.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Montserrat'),
          ),
        );
      default: return const GruposCulturasPage();
    }
  }

  Widget _buildNavItem({required IconData icon, required String title, required int index}) {
    final bool isSelected = _index == index;
    final Color verdePrincipal = const Color.fromRGBO(126, 175, 49, 1);

    return GestureDetector(
      onTap: () => _navigateToScreen(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent, 
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? verdePrincipal : Colors.white.withOpacity(0.8),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? verdePrincipal : Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color verdePrincipal = const Color.fromRGBO(126, 175, 49, 1);
    final Color verdeClaroBarra = const Color.fromRGBO(158, 215, 66, 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titulos[_index],
          style: const TextStyle(
            fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: verdePrincipal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: verdePrincipal,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, top: 40),
              child: const Text('MENU', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
            ),
            ListTile(
              leading: const Icon(Icons.folder_shared, color: Colors.green),
              title: const Text('Análises Salvas', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalisesSalvasPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Compartilhar App', style: TextStyle(fontFamily: 'Montserrat')),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.power_settings_new, color: Colors.red),
              title: const Text('Sair', style: TextStyle(fontFamily: 'Montserrat', color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: _buildBody(),

      extendBody: true,
      
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          height: 75,
          decoration: BoxDecoration(
            color: verdeClaroBarra,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(icon: Icons.eco_outlined, title: "Culturas", index: 0),
              _buildNavItem(icon: Icons.task_rounded, title: "Análise", index: 1),
              _buildNavItem(icon: Icons.help_center, title: "Ajuda", index: 2),
            ],
          ),
        ),
      ),
    );
  }
}