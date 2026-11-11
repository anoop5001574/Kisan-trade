import 'package:flutter/material.dart';

void main() {
  runApp(const KisanTradeApp());
}

class KisanTradeApp extends StatelessWidget {
  const KisanTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kisan Trade',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

// ----------------- रजिस्ट्रेशन स्क्रीन -----------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int currentStep = 0;
  String selectedRole = 'किसान (Farmer)';
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('Kisan Trade - रजिस्ट्रेशन'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.eco, size: 55, color: Colors.green),
            const SizedBox(height: 5),
            const Text(
              "किसान का सही भाव, खरीदार का सही सामान",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (currentStep == 0) _buildPhoneStep(),
            if (currentStep == 1) _buildOtpStep(),
            if (currentStep == 2) _buildProfileStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("🌾 किसान")),
                    selected: selectedRole == 'किसान (Farmer)',
                    onSelected: (val) => setState(() => selectedRole = 'किसान (Farmer)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("💼 खरीदार")),
                    selected: selectedRole == 'खरीदार (Buyer)',
                    onSelected: (val) => setState(() => selectedRole = 'खरीदार (Buyer)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                prefixText: "+91  ",
                hintText: "10 अंकों का मोबाइल नंबर",
                border: OutlineInputBorder(),
                counterText: "",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                if (phoneController.text.length == 10) {
                  setState(() => currentStep = 1);
                } else {
                  _showMessage("कृपया 10 अंकों का नंबर लिखें");
                }
              },
              child: const Text("OTP भेजें", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpStep() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("+91 ${phoneController.text} पर भेजा गया कोड दर्ज करें:"),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, letterSpacing: 6, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(hintText: "1234", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                if (otpController.text.isNotEmpty) {
                  setState(() => currentStep = 2);
                } else {
                  _showMessage("कृपया OTP दर्ज करें");
                }
              },
              child: const Text("OTP सत्यापित करें", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStep() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("$selectedRole - प्रोफाइल पूरी करें", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "पूरा नाम", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "गाँव / मंडी / ज़िला",
                hintText: "उदा. शाहपुर, मेरठ",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location, color: Colors.green),
                  tooltip: "लोकेशन सेट करें",
                  onPressed: () {
                    locationController.text = "शाहपुर (निकटतम मंडी क्षेत्र)";
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                if (nameController.text.isEmpty || locationController.text.isEmpty) {
                  _showMessage("कृपया नाम और लोकेशन भरें");
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmerDashboard(
                      farmerName: nameController.text,
                      farmerLocation: locationController.text,
                    ),
                  ),
                );
              },
              child: const Text("डैशबोर्ड पर जाएँ (Proceed) ➔", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- किसान डैशबोर्ड और स्मार्ट कैलकुलेटर -----------------
class FarmerDashboard extends StatefulWidget {
  final String farmerName;
  final String farmerLocation;

  const FarmerDashboard({super.key, required this.farmerName, required this.farmerLocation});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  double cropQuantity = 100; // 100 क्विंटल डिफ़ॉल्ट
  String selectedCrop = 'गेहूँ (Wheat)';
  final double transportPerKm = 3.5;
  final double commissionPercent = 1.0;

  final List<Map<String, dynamic>> buyers = [
    {"name": "खरीदार A (लोकल गल्ला मंडी)", "km": 5.0, "rate": 2500.0},
    {"name": "खरीदार B (कृषि एग्रो प्रोडक्ट्स)", "km": 12.0, "rate": 2560.0},
    {"name": "खरीदार C (बड़ा व्यापारी - गोदाम)", "km": 20.0, "rate": 2620.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("नमस्ते, ${widget.farmerName}"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "आपकी लोकेशन: ${widget.farmerLocation}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("🌾 फसल और वजन दर्ज करें:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCrop,
                            items: ['गेहूँ (Wheat)', 'धान (Paddy)', 'सरसों (Mustard)', 'मक्का (Maize)']
                                .map((crop) => DropdownMenuItem(value: crop, child: Text(crop)))
                                .toList(),
                            onChanged: (val) => setState(() => selectedCrop = val!),
                            decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: cropQuantity.toInt().toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "मात्रा (क्विंटल)", border: OutlineInputBorder()),
                            onChanged: (val) => setState(() => cropQuantity = double.tryParse(val) ?? 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "📊 खरीदार (भाड़ा व कमीशन काटकर शुद्ध बचत):",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...buyers.map((buyer) {
              double grossAmount = cropQuantity * buyer['rate'];
              double transportCost = buyer['km'] * transportPerKm * (cropQuantity / 10);
              double commission = (grossAmount * commissionPercent) / 100;
              double netInHand = grossAmount - transportCost - commission;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(buyer['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Chip(label: Text("${buyer['km']} KM"), backgroundColor: Colors.blue[50]),
                        ],
                      ),
                      const Divider(),
                      Text("बोली भाव: ₹${buyer['rate'].toInt()} / क्विंटल"),
                      Text("कुल मूल्य: ₹${grossAmount.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("परिवहन खर्च (भाड़ा): - ₹${transportCost.toStringAsFixed(0)}", style: const TextStyle(color: Colors.red)),
                      Text("ऐप कमीशन (1%): - ₹${commission.toStringAsFixed(0)}", style: const TextStyle(color: Colors.orange)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("किसान को मिलेंगे (Net):", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              "₹${netInHand.toStringAsFixed(0)}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green[900]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          minimumSize: const Size(double.infinity, 42),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("सौदा पक्का! 🎉"),
                              content: Text("${buyer['name']} को $cropQuantity क्विंटल $selectedCrop का ऑर्डर भेज दिया गया है।"),
                              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ठीक है"))],
                            ),
                          );
                        },
                        child: const Text("सौदा पक्का करें (Sell Now)", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
