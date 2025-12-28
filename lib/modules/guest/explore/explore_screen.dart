import 'package:flutter/material.dart';
import 'explore_viewmodel.dart';

// ========== Explore Screen Widget ==========
class ExploreScreen extends StatefulWidget {
  // ========== Constructor ==========
  const ExploreScreen({super.key, required this.viewModel});

  // ========== Properties ==========
  final ExploreViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

// ========== Explore Screen State ==========
class _ExploreScreenState extends State<ExploreScreen> {
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
          child: Text("Explore Screen"),
        );
      },
    );
  }
}

