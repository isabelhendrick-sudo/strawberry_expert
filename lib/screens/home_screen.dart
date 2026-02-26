import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This list stores the tasks you create during the session
  final List<Map<String, dynamic>> _userTasks = [];

  void _showAddTaskModal(BuildContext context) {
    String taskName = "";
    String selectedGreenhouse = "Greenhouse A";
    String priority = "Normal";
    List<String> tags = [];
    final TextEditingController tagController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Farm Task",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Task Name (e.g., Harvesting)",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => taskName = val,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGreenhouse,
                  decoration: InputDecoration(
                    labelText: "Select Greenhouse",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: ["Greenhouse A", "Greenhouse B", "Greenhouse C"]
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setModalState(() => selectedGreenhouse = val!),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ["Urgent", "Normal", "Scheduled"]
                      .map(
                        (p) => ChoiceChip(
                          label: Text(p),
                          selected: priority == p,
                          onSelected: (selected) =>
                              setModalState(() => priority = p),
                          selectedColor: const Color(
                            0xFF2D6A4F,
                          ).withOpacity(0.2),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tagController,
                  decoration: InputDecoration(
                    hintText: "Add Tag (Press Enter)",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (tagController.text.isNotEmpty) {
                          setModalState(() => tags.add(tagController.text));
                          tagController.clear();
                        }
                      },
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: tags
                      .map(
                        (t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 10)),
                          onDeleted: () => setModalState(() => tags.remove(t)),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6A4F),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    if (taskName.isNotEmpty) {
                      setState(() {
                        _userTasks.add({
                          'name': taskName,
                          'farm': selectedGreenhouse,
                          'priority': priority,
                          'tags': List.from(tags),
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Create Task",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D6A4F),
        onPressed: () => _showAddTaskModal(context),
        child: const Icon(Icons.add_task, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherHeader(),
              const SizedBox(height: 24),
              _buildBrixCard(),
              const SizedBox(height: 24),
              Text(
                "Urgent Actions",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildUrgentTile(
                "Pest Identified",
                "Greenhouse A - Row 2",
                Icons.bug_report,
                Colors.red,
              ),
              _buildUrgentTile(
                "Low Irrigation",
                "Greenhouse B - Section 4",
                Icons.water_drop,
                Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                "Weekly Schedule",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Dynamic Task List
              if (_userTasks.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "No tasks added yet. Tap + to start.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ..._userTasks
                    .map(
                      (task) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: task['priority'] == "Urgent"
                                ? Colors.red
                                : Colors.green,
                          ),
                          title: Text("${task['name']} (${task['farm']})"),
                          subtitle: Text(
                            "Tags: ${task['tags'].isEmpty ? 'None' : task['tags'].join(', ')}",
                          ),
                          trailing: const Icon(Icons.check_circle_outline),
                        ),
                      ),
                    )
                    .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Local Climate", style: GoogleFonts.inter(color: Colors.grey)),
            Text(
              "Jeonju-si, 18°C",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Icon(Icons.wb_cloudy_outlined, size: 32, color: Colors.blueGrey),
      ],
    );
  }

  Widget _buildBrixCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D6A4F), Color(0xFF1B4332)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Yield Readiness (Brix)",
            style: GoogleFonts.inter(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "12.5°Bx",
                style: GoogleFonts.inter(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.auto_awesome, color: Colors.orangeAccent),
            ],
          ),
          const Text(
            "Average ripeness reached across 3 farms",
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentTile(String title, String loc, IconData icon, Color col) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: col.withOpacity(0.1),
          child: Icon(icon, color: col, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(loc),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}
