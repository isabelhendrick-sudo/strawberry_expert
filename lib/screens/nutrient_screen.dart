import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class NutrientPage extends StatefulWidget {
  const NutrientPage({super.key});

  @override
  State<NutrientPage> createState() => _NutrientPageState();
}

class _NutrientPageState extends State<NutrientPage> {
  late UltralyticsYoloCameraController _cameraController;
  bool _isModelLoaded = false;

  final TextEditingController _nitroController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _ecController = TextEditingController();

  String _advice = "Enter levels to start analysis";
  String _temperature = "--°C";

  WeatherFactory wf = WeatherFactory("60daa95d39fee03395262f3b2ed1f137");

  @override
  void initState() {
    super.initState();
    _initEverything();
  }

  Future<void> _initEverything() async {
    await _fetchWeather();
    await _initModel();
  }

  Future<void> _initModel() async {
    try {
      // Ensure your file is at assets/best_float32.tflite
      final model = LocalModel(assetPath: 'assets/best_float32.tflite');
      final predictor = Yolov8Predictor(model: model);

      _cameraController = UltralyticsYoloCameraController(predictor: predictor);
      await _cameraController.initialize();

      setState(() => _isModelLoaded = true);
    } catch (e) {
      debugPrint("Model failed to load: $e");
    }
  }

  Future<void> _fetchWeather() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      Weather w = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _temperature = "${w.temperature?.celsius?.toStringAsFixed(0)}°C";
      });
    } catch (e) {
      setState(() => _temperature = "N/A");
    }
  }

  Future<void> _getAdvice() async {
    List<String> currentDetections = ["ripe_strawberry"];
    // CHANGE THIS IP to your computer's current IPv4 address
    final url = Uri.parse('http://192.168.0.6:5000/predict');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nitrogen': double.tryParse(_nitroController.text) ?? 0.0,
          'ph': double.tryParse(_phController.text) ?? 6.0,
          'ec': double.tryParse(_ecController.text) ?? 1.5,
          'detections': currentDetections,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _advice = data['advice']);
      }
    } catch (e) {
      setState(
        () => _advice = "Expert System Offline. Check your Computer IP!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        title: Text(
          "Strawberry AI Expert",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                _temperature,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _isModelLoaded
                    ? UltralyticsYoloCameraPreview(
                        controller: _cameraController,
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInput(
                    _nitroController,
                    "Nitrogen (ppm)",
                    Icons.science,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          _phController,
                          "pH Level",
                          Icons.opacity,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInput(
                          _ecController,
                          "EC (mS/cm)",
                          Icons.bolt,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getAdvice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D6A4F),
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Run Expert Analysis",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                _advice,
                style: GoogleFonts.inter(fontSize: 15, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2D6A4F)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
