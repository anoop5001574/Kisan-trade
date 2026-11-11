import 'package:flutter/material.dart';

void main() {
  runApp(const KisanTradeAuthApp());
}

class KisanTradeAuthApp extends StatelessWidget {
  const KisanTradeAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kisan Trade Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const RegistrationFlowScreen(),
    );
  }
}

class RegistrationFlowScreen extends StatefulWidget {
  const RegistrationFlowScreen({super.key});

  @override
  State<RegistrationFlowScreen> createState() => _RegistrationFlowScreenState();
}

class _RegistrationFlowScreenState extends State<RegistrationFlowScreen> {
  // स्टेप कंट्रोल (0: मोबाइल इनपुट, 1: OTP, 2: प्रोफाइल डिटेल)
  int currentStep = 0;

  // यूजर डेटा
  String selectedRole = 'किसान (Farmer)';
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController firmNameController = TextEditingController();

  void _verifyPhoneAndSendOtp() {
    if (phoneController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सही 10 अंकों का मोबाइल नंबर दर्ज करें!')),
      );
      return;
    }
    setState(() {
      currentStep = 1; // OTP स्क्रीन पर जाएँ
    });
  }

  void _verifyOtp() {
    if (otpController.text.trim().length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया वैध OTP दर्ज करें!')),
      );
      return;
    }
    setState(() {
      currentStep = 2; // प्रोफाइल डिटेल स्क्रीन पर जाएँ
    });
  }

  void _completeRegistration() {
    if (nameController.text.isEmpty || locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सभी जरूरी जानकारी भरें!')),
      );
      return;
    }

    // सफल रजिस्ट्रेशन
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('बधाई हो! 🎉'),
        content: Text(
          'नमस्ते ${nameController.text},\n'
          'Kisan Trade ऐप पर आपका ${selectedRole} खाता सफलतापूर्वक बन गया है!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // यहाँ से डैशबोर्ड स्क्रीन खुलेगी
            },
            child: const Text('डैशबोर्ड पर जाएँ (Proceed)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('Kisan Trade - रजिस्ट्रेशन'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ऐप लोगो व टैगलाइन
            Icon(Icons.eco, size: 60, color: Colors.green[800]),
            const SizedBox(height: 8),
            Text(
              "किसान का सही भाव, खरीदार का सही सामान",
              style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // वर्तमान स्टेप के अनुसार विजेट
            if (currentStep == 0) _buildPhoneStep(),
            if (currentStep == 1) _buildOtpStep(),
            if (currentStep == 2) _buildProfileStep(),
          ],
        ),
      ),
    );
  }

  // --- चरण 1: रोल और मोबाइल नंबर ---
  Widget _buildPhoneStep() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "आप कौन हैं? (Select Role)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("🌾 किसान (Farmer)")),
                    selected: selectedRole == 'किसान (Farmer)',
                    selectedColor: Colors.green[100],
                    onSelected: (val) {
                      setState(() => selectedRole = 'किसान (Farmer)');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text("💼 खरीदार (Buyer)")),
                    selected: selectedRole == 'खरीदार (Buyer)',
                    selectedColor: Colors.green[100],
                    onSelected: (val) {
                      setState(() => selectedRole = 'खरीदार (Buyer)');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("मोबाइल नंबर दर्ज करें", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                prefixText: "+91  ",
                hintText: "9876543210",
                counterText: "",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _verifyPhoneAndSendOtp,
                child: const Text("OTP भेजें (Get OTP)", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- चरण 2: OTP सत्यापन ---
  Widget _buildOtpStep() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("मोबाइल +91 ${phoneController.text} पर भेजा गया कोड दर्ज करें:", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: "",
                hintText: "• • • • • •",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _verifyOtp,
                child: const Text("OTP सत्यापित करें", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => currentStep = 0),
              child: const Text("नंबर बदलें (Change Number)"),
            ),
          ],
        ),
      ),
    );
  }

  // --- चरण 3: प्रोफाइल विवरण ---
  Widget _buildProfileStep() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("अपनी जानकारी दर्ज करें ($selectedRole)", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "पूरा नाम (Full Name)",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "गाँव / मंडी / ज़िला (Location)",
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location, color: Colors.green),
                  tooltip: "GPS से खोजें",
                  onPressed: () {
                    // यहाँ GPS लोकेशन ऑटो-फिल होगी
                    locationController.text = "करनाल, हरियाणा (GPS Detected)";
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            if (selectedRole == 'खरीदार (Buyer)') ...[
              const SizedBox(height: 12),
              TextField(
                controller: firmNameController,
                decoration: InputDecoration(
                  labelText: "दुकान / फर्म का नाम (Shop/Firm Name)",
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _completeRegistration,
                child: const Text("रजिस्ट्रेशन पूरा करें (Finish)", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
