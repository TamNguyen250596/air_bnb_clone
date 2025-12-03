import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';

// ========== Inbox Screen Widget ==========
class InboxScreen extends StatelessWidget {
  // ========== Constructor ==========
  const InboxScreen({super.key});

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Inbox'),
      body: const Center(
        child: Text("Inbox Screen"),
      ),
    );
  }
}
