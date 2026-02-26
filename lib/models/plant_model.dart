enum PlantStatus {
  healthy,
  pestDetected,
  nutrientDeficiency,
  harvestReady,
  overwatered,
  underwatered,
}

class StrawberryPlant {
  final String tag;
  final PlantStatus status;
  final double brixValue;
  final String? lastPest;
  final DateTime lastChecked;

  StrawberryPlant({
    required this.tag,
    required this.status,
    this.brixValue = 0.0,
    this.lastPest,
    required this.lastChecked,
  });
}
