import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import 'inbox_viewmodel.dart';

// ========== Inbox Screen Widget ==========
class InboxScreen extends StatefulWidget {
  // ========== Constructor ==========
  const InboxScreen({super.key, required this.viewModel});

  // ========== Properties ==========
  final InboxViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

// ========== Inbox Screen State ==========
class _InboxScreenState extends State<InboxScreen> {
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
          appBar: const CustomAppBar(title: 'Inbox'),
          body: const Center(
            child: Text("Inbox Screen"),
          ),
        );
      },
    );
  }
}

