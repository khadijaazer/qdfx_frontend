import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';

class ScamDetectionScreen extends StatefulWidget {
  const ScamDetectionScreen({super.key});

  @override
  State<ScamDetectionScreen> createState() => _ScamDetectionScreenState();
}

class _ScamDetectionScreenState extends State<ScamDetectionScreen> {
  final TextEditingController _textCtrl = TextEditingController();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _result; // Stores the analysis result

  // --- MOCK AI ANALYSIS LOGIC (Simulating BERT) ---
  void _analyzeText() async {
    if (_textCtrl.text.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _result = null; // Reset previous result
    });

    // Simulate Network Delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    // Simple keyword check for demo purposes
    String input = _textCtrl.text.toLowerCase();
    bool isScam = input.contains('urgent') || input.contains('http') || input.contains('verify') || input.contains('winning');

    setState(() {
      _isAnalyzing = false;
      if (isScam) {
        _result = {
          "isScam": true,
          "confidence": 98,
          "language": "Mixed (English, Arabic)",
          "indicators": [
            "Suspicious URL identified",
            "Urgency keywords detected",
            "Matches known phishing patterns"
          ]
        };
      } else {
        _result = {
          "isScam": false,
          "confidence": 99,
          "language": "English",
          "indicators": ["Message appears safe"]
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = appState.isDarkMode;

    // Theme Colors
    Color bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    Color textMain = isDark ? Colors.white : Colors.black87;
    Color borderColor = isDark ? Colors.white10 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text("Multilingual Scam & Spam Detection", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textMain)),
            const SizedBox(height: 8),
            Text("Detect fraudulent messages in 41 languages using BERT.", 
              style: TextStyle(color: isDark ? Colors.grey : Colors.grey[700])),
            
            const SizedBox(height: 30),

            // --- INPUT SECTION ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Paste suspicious message here...", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  const SizedBox(height: 10),
                  
                  // Text Area
                  TextField(
                    controller: _textCtrl,
                    maxLines: 6,
                    style: TextStyle(color: textMain, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Ex: Urgent! Your account is compromised...",
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : Colors.grey[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Analyze Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E86DE), // Bright Blue
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        shadowColor: const Color(0xFF2E86DE).withOpacity(0.4),
                      ),
                      onPressed: _isAnalyzing ? null : _analyzeText,
                      child: _isAnalyzing 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("ANALYZE MESSAGE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- RESULT SECTION (Conditional) ---
            if (_result != null) 
              _buildResultCard(_result!, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result, bool isDark) {
    bool isScam = result['isScam'];
    Color statusColor = isScam ? const Color(0xFFE53935) : const Color(0xFF00C853); // Red or Green
    Color bgGlow = statusColor.withOpacity(0.1);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(color: statusColor.withOpacity(0.15), blurRadius: 30, spreadRadius: 0)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
            child: Text(
              isScam ? "ANALYSIS RESULT: POTENTIAL SCAM" : "ANALYSIS RESULT: SAFE MESSAGE",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Big Icon with Glow
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [BoxShadow(color: statusColor.withOpacity(0.4), blurRadius: 40)],
                ),
                child: Icon(
                  isScam ? Icons.warning_rounded : Icons.verified_user_rounded,
                  size: 80, color: statusColor
                ),
              ),
              const SizedBox(width: 24),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Confidence Score: ${result['confidence']}%", style: TextStyle(color: isDark?Colors.white:Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("Detected Language: ${result['language']}", style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    Text("Key Indicators:", style: TextStyle(color: isDark?Colors.white:Colors.black87, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    
                    // List of Indicators
                    ...List.generate(result['indicators'].length, (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: statusColor),
                          const SizedBox(width: 8),
                          Text(result['indicators'][index], style: TextStyle(color: isDark?Colors.grey[300]:Colors.grey[800])),
                        ],
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              if (isScam)
                ElevatedButton.icon(
                  icon: const Icon(Icons.block, size: 18),
                  label: const Text("REPORT SCAM"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {},
                ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _textCtrl.clear();
                    _result = null;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text("CLEAR"),
              )
            ],
          )
        ],
      ),
    );
  }
}