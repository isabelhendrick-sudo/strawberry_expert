import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/plant_model.dart';

class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  // The list of plants generated based on your logic
  final List<StrawberryPlant> _plants = List.generate(50, (index) {
    if (index == 7 || index == 15) {
      return StrawberryPlant(
        tag: "R1-P$index",
        status: PlantStatus.pestDetected,
        lastPest: "Spider Mites",
        lastChecked: DateTime.now(),
      );
    } else if (index % 12 == 0 && index != 0) {
      return StrawberryPlant(
        tag: "R1-P$index",
        status: PlantStatus.harvestReady,
        brixValue: 13.2,
        lastChecked: DateTime.now(),
      );
    }
    return StrawberryPlant(
      tag: "R1-P$index",
      status: PlantStatus.healthy,
      lastChecked: DateTime.now(),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        title: Text(
          "Greenhouse A Analysis",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Switch to AI Expert tab for Scanner"),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryStats(),
          _buildLegend(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _plants.length,
              itemBuilder: (context, index) {
                final plant = _plants[index];
                return GestureDetector(
                  onTap: () => _showPlantSheet(context, plant),
                  child: Hero(
                    tag: plant.tag,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getStatusColor(plant.status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(plant.status),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getStatusIcon(plant.status),
                            color: _getStatusColor(plant.status),
                            size: 20,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plant.tag,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSummaryStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("Total", "50", Colors.blue),
          _statItem("Ready", "4", Colors.purple),
          _statItem("Issues", "2", Colors.red),
        ],
      ),
    );
  }

  Widget _statItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem("Healthy", Colors.green),
          _legendItem("Pest", Colors.red),
          _legendItem("Ready", Colors.purple),
        ],
      ),
    );
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // --- HELPERS ---

  Color _getStatusColor(PlantStatus status) {
    switch (status) {
      case PlantStatus.pestDetected:
        return Colors.red;
      case PlantStatus.nutrientDeficiency:
        return Colors.orange;
      case PlantStatus.harvestReady:
        return Colors.purple;
      case PlantStatus.overwatered:
      case PlantStatus.underwatered:
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  IconData _getStatusIcon(PlantStatus status) {
    switch (status) {
      case PlantStatus.pestDetected:
        return Icons.bug_report;
      case PlantStatus.nutrientDeficiency:
        return Icons.science;
      case PlantStatus.harvestReady:
        return Icons.auto_awesome;
      default:
        return Icons.eco;
    }
  }

  void _showPlantSheet(BuildContext context, StrawberryPlant plant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Plant ${plant.tag}",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _statusBadge(plant.status),
              ],
            ),
            const Divider(height: 32),
            _infoRow(
              "AI Brix Reading",
              "${plant.brixValue == 0.0 ? 'N/A' : plant.brixValue}°Bx",
            ),
            _infoRow("Last Pest/Disease", plant.lastPest ?? "None"),
            _infoRow("Last Sensor Sync", "2 minutes ago"),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Log Inspection",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(PlantStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
