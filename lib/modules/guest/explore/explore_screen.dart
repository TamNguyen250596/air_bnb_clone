import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';

// ========== Explore Screen Widget ==========
class ExploreScreen extends StatelessWidget {
  // ========== Constructor ==========
  const ExploreScreen({super.key});

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Explore'),
      body: const Center(
        child: Text("Explore Screen"),
      ),
    );
  }
}
