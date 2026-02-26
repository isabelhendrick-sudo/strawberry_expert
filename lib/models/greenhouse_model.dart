class Greenhouse {
  final String id;
  final String name;
  final int rows;
  final int cols;
  // This stores environmental data from your IoT sensors
  final Map<String, double> sensorData;

  Greenhouse({
    required this.id,
    required this.name,
    required this.rows,
    required this.cols,
    this.sensorData = const {'temp': 0.0, 'rh': 0.0, 'co2': 0.0},
  });
}
