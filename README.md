# 🍓 Strawberry Expert

> An AI-powered precision agriculture system for real-time strawberry health monitoring, ripeness detection, and IoT-based greenhouse environment control.

![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter)
![YOLOv8](https://img.shields.io/badge/AI-YOLOv8-FF6F00?logo=python)
![Arduino](https://img.shields.io/badge/Firmware-Arduino%20C%2B%2B-00979D?logo=arduino)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Project Overview

**Strawberry Expert** is a research-driven smart farming application developed as part of an ongoing investigation into AI-based decision support tools for high-value greenhouse crops. The system integrates computer vision (YOLOv8), IoT sensor networks, and a cross-platform mobile dashboard (Flutter) to assist farmers and agronomists in making data-driven cultivation decisions.

This project is aligned with the research focus area of **Smart Agriculture and Precision Farming**, with specific application to controlled-environment horticulture in South Korea and Southeast Asia.

### 🎯 Research Objectives

1. Detect and classify strawberry ripeness stages (unripe, semi-ripe, ripe, overripe) using YOLOv8 object detection
2. Estimate fruit volume and yield potential from visual data
3. Monitor greenhouse microclimate (temperature, humidity, soil moisture, light) via Arduino-based IoT sensors
4. Deliver real-time alerts and agronomic recommendations through a mobile-first Flutter interface
5. Explore the potential of strawberry leaf byproducts as a secondary data point for plant health assessment

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  Strawberry Expert System                │
├──────────────┬──────────────────┬───────────────────────┤
│  IoT Layer   │   AI/ML Layer    │    Application Layer   │
│  (Arduino)   │   (Python)       │    (Flutter)           │
│              │                  │                        │
│ DHT22        │  YOLOv8 Model    │  Mobile Dashboard      │
│ Soil Sensor  │  Image Capture   │  Sensor Visualisation  │
│ LUX Sensor   │  Inference       │  Alert System          │
│ CO2 Sensor   │  Data Pipeline   │  Farmer Advisory       │
└──────┬───────┴────────┬─────────┴───────────────────────┘
       │                │
       └────────────────┘
         Serial / BLE / WiFi
```

---

## 🧰 Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| Computer Vision | Python · YOLOv8 (Ultralytics) | Ripeness detection & fruit counting |
| Firmware | Arduino C++ | Sensor data acquisition & control |
| Mobile App | Flutter (Dart) | Cross-platform farmer dashboard |
| Communication | Serial / BLE / WiFi | Arduino ↔ App data relay |
| Data | JSON / CSV | Sensor logs & inference outputs |

---

## 📁 Repository Structure

```
strawberry_expert/
│
├── firmware/                   # Arduino C++ sensor code
│   ├── main.ino                # Main firmware entry point
│   ├── sensors/                # Individual sensor modules
│   │   ├── dht22.cpp           # Temperature & humidity
│   │   ├── soil_moisture.cpp   # Soil moisture sensing
│   │   ├── lux_sensor.cpp      # Light intensity
│   │   └── co2_sensor.cpp      # CO2 concentration
│   └── README.md               # Firmware setup guide
│
├── model/                      # YOLOv8 Python inference
│   ├── train.py                # Model training script
│   ├── infer.py                # Real-time inference script
│   ├── utils.py                # Helper functions
│   ├── data/                   # Dataset config
│   │   └── dataset.yaml        # YOLO dataset descriptor
│   └── README.md               # Model usage guide
│
├── lib/                        # Flutter application (Dart)
│   ├── main.dart               # App entry point
│   ├── screens/                # UI screens
│   │   ├── dashboard_screen.dart
│   │   ├── detection_screen.dart
│   │   └── sensor_screen.dart
│   ├── services/               # Data & BLE services
│   │   ├── sensor_service.dart
│   │   └── inference_service.dart
│   └── widgets/                # Reusable UI components
│
├── assets/                     # Images, icons, sample data
├── docs/                       # Architecture diagrams & research notes
├── test/                       # Unit & integration tests
│
├── pubspec.yaml                # Flutter dependencies
├── analysis_options.yaml       # Dart lint rules
└── README.md                   # ← You are here
```

---

## 🌱 IoT Sensor Modules

The firmware layer is built on Arduino C++ and reads from the following environmental sensors:

| Sensor | Parameter | Unit | Threshold (Alert) |
|---|---|---|---|
| DHT22 | Temperature | °C | < 15 or > 28 |
| DHT22 | Relative Humidity | % | < 60 or > 85 |
| Capacitive Soil Sensor | Volumetric Moisture | % | < 40 |
| LUX Sensor (BH1750) | Light Intensity | lux | < 5,000 |
| MH-Z19 / SCD30 | CO₂ Concentration | ppm | > 1,200 |

Sensor readings are transmitted via **Serial / BLE** to the Flutter app at configurable polling intervals (default: every 30 seconds).

---

## 🤖 YOLOv8 Detection Model

The computer vision module uses **YOLOv8** (Ultralytics) to perform real-time object detection on strawberry images captured either from a smartphone camera or a fixed greenhouse camera module.

### Detection Classes

| Class ID | Label | Description |
|---|---|---|
| 0 | `unripe` | Fully green fruit |
| 1 | `semi_ripe` | Partially coloured fruit |
| 2 | `ripe` | Fully red, ready to harvest |
| 3 | `overripe` | Past peak, risk of disease |
| 4 | `diseased` | Visible fungal/bacterial symptoms |

### Running Inference

```bash
# Install dependencies
pip install ultralytics opencv-python

# Run inference on a single image
python model/infer.py --source assets/sample/strawberry_01.jpg --weights model/best.pt

# Run inference on live camera feed
python model/infer.py --source 0 --weights model/best.pt
```

---

## 📱 Flutter Application

The mobile dashboard provides:

- **Live sensor readings** with threshold-based colour indicators
- **YOLOv8 detection view** via device camera or image upload
- **Historical trend charts** for temperature, humidity, and moisture
- **Push alerts** when environmental parameters exceed safe thresholds
- **Harvest recommendation engine** based on ripeness distribution

### Running the App

```bash
# Install Flutter dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Build for Android release
flutter build apk --release
```

---

## 🔬 Research Context

This project contributes to the broader field of **AI-assisted precision horticulture** and is developed in alignment with Smart Agriculture research directions at **Jeonbuk National University**, South Korea. It builds on published work in:

- YOLOv8-based fruit detection for strawberry quality grading
- IoT sensor fusion for greenhouse microclimate optimisation
- Edge AI deployment for resource-constrained farming environments

### Key Research Questions

1. Can YOLOv8 achieve ≥ 85% mAP for strawberry ripeness classification under variable greenhouse lighting?
2. How accurately can volume estimation be derived from 2D bounding box data alone?
3. What is the minimum viable sensor network for actionable microclimate alerts?

---

## 📊 Current Development Status

| Module | Status | Notes |
|---|---|---|
| Arduino firmware (DHT22) | ✅ Complete | Tested on Arduino Uno |
| Arduino firmware (soil, lux) | 🔄 In Progress | Sensor calibration ongoing |
| YOLOv8 dataset collection | 🔄 In Progress | Targeting 500+ labelled images |
| YOLOv8 model training | ⏳ Planned | Pending dataset completion |
| Flutter dashboard (UI) | 🔄 In Progress | Sensor screen complete |
| Flutter ↔ Arduino BLE bridge | ⏳ Planned | Q3 2026 milestone |
| Volume estimation module | ⏳ Planned | Research phase |

---

## 👩‍🔬 Author

**Isabel Aziz-Hendrick**
BSc GIS & Big Data — MSc Smart Agriculture (Candidate, Jeonbuk National University, Fall 2026)
Research Focus: AI-based decision tools for high-value greenhouse crops

---

## 📄 License

This project is licensed under the MIT License. See `LICENSE` for details.

---

## 🤝 Acknowledgements

- [Ultralytics YOLOv8](https://github.com/ultralytics/ultralytics)
- [Flutter](https://flutter.dev)
- [Arduino](https://www.arduino.cc)
- Jeonbuk National University, Department of Agricultural and Resource Economics
