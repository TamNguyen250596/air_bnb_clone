import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import 'saved_viewmodel.dart';

// ========== Saved Screen Widget ==========
class SavedScreen extends StatefulWidget {
  // ========== Constructor ==========
  const SavedScreen({super.key, required this.viewModel});

  // ========== Properties ==========
  final SavedViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

// ========== Saved Screen State ==========
class _SavedScreenState extends State<SavedScreen> {
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
          appBar: const CustomAppBar(title: 'Favorites'),
          body: const Center(
            child: Text("Saved Screen"),
          ),
        );
      },
    );
  }
}

