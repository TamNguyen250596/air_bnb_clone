import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';

// ========== Saved Screen Widget ==========
class SavedScreen extends StatelessWidget {
  // ========== Constructor ==========
  const SavedScreen({super.key});

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Favorites'),
      body: const Center(
        child: Text("Saved Screen"),
      ),
    );
  }
}
