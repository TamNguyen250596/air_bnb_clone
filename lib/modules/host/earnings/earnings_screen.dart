import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';

// ========== Earnings Screen Widget ==========
class EarningsPage extends StatelessWidget {
  // ========== Constructor ==========
  const EarningsPage({super.key});

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Earnings'),
      body: const Center(
        child: Text("Earnings Screen"),
      ),
    );
  }
}
