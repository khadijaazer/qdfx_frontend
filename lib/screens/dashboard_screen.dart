import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../l10n/translations.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final lang = appState.currentLocale.languageCode;
    String t(String key) => AppTranslations.get(lang, key);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t('welcome'), style: const TextStyle(color: Colors.grey)),
                    Text(t('overview'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
                const CircleAvatar(backgroundColor: AppTheme.primaryBlue, child: Text("JD")),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Responsive Content Layout
            LayoutBuilder(
              builder: (context, constraints) {
                // If screen is wide (> 900px), split into 2 Columns
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Side: Upload Zone (Flex 2)
                      Expanded(
                        flex: 2,
                        child: _buildUploadZone(t),
                      ),
                      const SizedBox(width: 24),
                      // Right Side: Recent Analysis (Flex 1)
                      Expanded(
                        flex: 1,
                        child: _buildRecentList(t),
                      ),
                    ],
                  );
                } 
                // If screen is small, Stack them
                else {
                  return Column(
                    children: [
                      _buildUploadZone(t),
                      const SizedBox(height: 30),
                      _buildRecentList(t),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Extracted Widget for Upload Zone
  Widget _buildUploadZone(Function t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedBorder(
          color: AppTheme.primaryBlue.withOpacity(0.5),
          strokeWidth: 2,
          dashPattern: const [8, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(16),
          child: Container(
            height: 300, // Taller for desktop feel
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.cardDark.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 64, color: AppTheme.primaryBlue),
                const SizedBox(height: 16),
                Text(t('dragDrop'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(t('formats'), style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: (){}, 
                  icon: const Icon(Icons.folder_open), 
                  label: const Text("Browse Files")
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Extracted Widget for Recent List
  Widget _buildRecentList(Function t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t('recent'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _AnalysisCard("Zoom_Meeting_001.mp4", t('detected'), 89, Colors.red),
        _AnalysisCard("Interview_Clip.wav", t('authentic'), 98, Colors.green),
        _AnalysisCard("Social_Post_v2.mp4", t('processing'), 0, Colors.orange),
        _AnalysisCard("CCTV_Footage.avi", t('authentic'), 92, Colors.green),
      ],
    );
  }

  Widget _AnalysisCard(String title, String status, int confidence, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.video_file_outlined, color: Colors.white70), 
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
        subtitle: Text(DateTime.now().toString().substring(0,16), style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.5))
          ),
          child: Text(
            confidence > 0 ? "${confidence}%" : "...",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }
}