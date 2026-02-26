import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/nutrient_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/farm_screen.dart';

void main() {
  runApp(const StrawberryApp());
}

class StrawberryApp extends StatelessWidget {
  const StrawberryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strawberry AI Expert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Using a professional "Forest Green" seed color for agriculture
        colorSchemeSeed: const Color(0xFF2D6A4F),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  // The list of screens your bottom bar will navigate through
  final List<Widget> _screens = [
    const Center(
      child: Text("Home Dashboard Coming Soon", style: TextStyle(fontSize: 18)),
    ),
    const FarmScreen(),
    const NutrientPage(), // This is your AI Camera & Expert screen
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack is great: it prevents the Camera from rebuilding every time you switch tabs!
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF2D6A4F),
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType
            .fixed, // Necessary for 4 items to show labels
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass_outlined),
            activeIcon: Icon(Icons.grass),
            label: "Farms",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: "AI Expert",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
