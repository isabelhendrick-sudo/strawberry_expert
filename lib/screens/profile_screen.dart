import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        title: Text("Farmer Profile", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. MEMBER INFO CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF2D6A4F),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Strawberry Pro", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Member since Feb 2026", style: GoogleFonts.inter(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. STATISTICS GRID
            GridView.count(
              shrinkWrap: true, // Needed to work inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.5,
              children: [
                _statWidget("Total Farms", "3", Icons.agriculture),
                _statWidget("Total Plants", "120", Icons.eco),
                _statWidget("Tasks Done", "45", Icons.task_alt),
                _statWidget("Harvests", "12", Icons.shopping_basket),
              ],
            ),
            const SizedBox(height: 24),

            // 3. SYNC DEVICES WIDGET
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2D6A4F), Color(0xFF40916C)]),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("IoT & Camera Sync", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Camera Stream: Active", style: TextStyle(color: Colors.white70)),
                  const Text("Soil Sensors: Synced", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {}, 
                    child: const Text("Manage Devices"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statWidget(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF2D6A4F)),
          Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}