import 'package:flutter/material.dart';
import 'bookings_viewmodel.dart';

// ========== Bookings Screen Widget ==========
class BookingsPage extends StatefulWidget {
  // ========== Constructor ==========
  const BookingsPage({super.key, required this.viewModel});

  // ========== Properties ==========
  final BookingsViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

// ========== Bookings Screen State ==========
class _BookingsPageState extends State<BookingsPage> {
  // ========== Lifecycle ==========
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelUpdate);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelUpdate);
    super.dispose();
  }

  // ========== Action Methods ==========
  void _onViewModelUpdate() {
    if (widget.viewModel.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.errorMessage)),
      );
    }
  }

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return const Center(
          child: Text("Bookings Screen"),
        );
      },
    );
  }
}

