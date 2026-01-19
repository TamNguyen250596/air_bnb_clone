import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import 'trips_viewmodel.dart';

// ========== Trips Screen Widget ==========
class TripsScreen extends StatefulWidget {
  // ========== Constructor ==========
  const TripsScreen({super.key, required this.viewModel});

  // ========== Properties ==========
  final TripsViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

// ========== Trips Screen State ==========
class _TripsScreenState extends State<TripsScreen> {
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
        return Scaffold(
          appBar: const CustomAppBar(title: 'Trips'),
          body: const Center(
            child: Text("Trips Screen"),
          ),
        );
      },
    );
  }
}

