from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    # Extract inputs with sensible defaults
    nitrogen = data.get('nitrogen', 0)
    ph = data.get('ph', 6.0)
    ec = data.get('ec', 1.5) 
    detected_objects = data.get('detections', []) 
    
    advice = []
    
    # --- 1. BIOLOGICAL & VITALITY LOGIC (YOLO) ---
    if "spider_mite" in detected_objects:
        advice.append("⚠️ PEST ALERT: Spider mites detected. Increase local humidity; consider biological control (Phytoseiulus).")
    
    if "powdery_mildew" in detected_objects:
        advice.append("⚠️ DISEASE: Powdery Mildew detected. Improve airflow and reduce leaf wetness.")

    if "ripe_strawberry" in detected_objects:
        # Brix Estimation: Base 7% + (EC impact) + (Nitrogen impact)
        # Scientifically, high Nitrogen can actually lower Brix slightly, while EC raises it.
        estimated_brix = 7.0 + (ec * 1.5) - (nitrogen * 0.01)
        advice.append(f"🍓 HARVEST: Ripe fruit detected. Estimated Brix: {estimated_brix:.1f}%.")

    # --- 2. FERTIGATION LOGIC (pH/EC) ---
    # Optimal Strawberry pH: 5.5 - 6.2
    if ph < 5.5:
        advice.append("🧪 pH LOW: Substrate too acidic. Risk of Mn toxicity. Add alkaline buffer.")
    elif ph > 6.5:
        advice.append("🧪 pH HIGH: Iron (Fe) lockout likely. Decrease pH to prevent leaf yellowing.")
    else:
        advice.append("✅ pH OPTIMAL: Nutrient availability is maximized.")

    # Optimal Strawberry EC: 1.2 - 2.0 mS/cm (depending on stage)
    if ec < 1.0:
        advice.append("💧 EC LOW: Plants are underfed. Increase fertigation concentration.")
    elif ec > 2.2:
        advice.append("🔥 EC HIGH: Risk of salt stress/root burn. Flush system with fresh water.")

    # --- 3. NUTRIENT LOGIC ---
    if nitrogen < 20:
        advice.append("🌿 NITROGEN: Level low for vegetative growth. Increase N-P-K ratio.")

    # Combine into a professional report
    full_advice = " | ".join(advice) if advice else "System Stable. Continue current fertigation program."
    
    return jsonify({'advice': full_advice})

if __name__ == '__main__':
    # Using 0.0.0.0 makes it accessible to your phone on the network
    app.run(host='0.0.0.0', port=5000, debug=True)