import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';

// ========== Trips Screen Widget ==========
class TripsScreen extends StatelessWidget {
  // ========== Constructor ==========
  const TripsScreen({super.key});

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Trips'),
      body: const Center(
        child: Text("Trips Screen"),
      ),
    );
  }
}
