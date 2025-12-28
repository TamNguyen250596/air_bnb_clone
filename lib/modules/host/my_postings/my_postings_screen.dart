import 'package:flutter/material.dart';
import 'my_postings_viewmodel.dart';

// ========== My Postings Screen Widget ==========
class MyPostingsPage extends StatefulWidget {
  // ========== Constructor ==========
  const MyPostingsPage({super.key, required this.viewModel});

  // ========== Properties ==========
  final MyPostingsViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<MyPostingsPage> createState() => _MyPostingsPageState();
}

// ========== My Postings Screen State ==========
class _MyPostingsPageState extends State<MyPostingsPage> {
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
          child: Text("My Postings Screen"),
        );
      },
    );
  }
}

