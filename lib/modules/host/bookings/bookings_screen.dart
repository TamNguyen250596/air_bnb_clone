import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';

// ========== Bookings Screen Widget ==========
class BookingsPage extends StatelessWidget {
  // ========== Constructor ==========
  const BookingsPage({super.key});

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Bookings'),
      body: const Center(
        child: Text("Bookings Screen"),
      ),
    );
  }
}
