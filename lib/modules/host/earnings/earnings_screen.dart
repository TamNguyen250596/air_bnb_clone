import 'package:flutter/material.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import 'earnings_viewmodel.dart';

// ========== Earnings Screen Widget ==========
class EarningsPage extends StatefulWidget {
  // ========== Constructor ==========
  const EarningsPage({super.key, required this.viewModel});

  // ========== Properties ==========
  final EarningsViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

// ========== Earnings Screen State ==========
class _EarningsPageState extends State<EarningsPage> {
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
          appBar: const CustomAppBar(title: 'Earnings'),
          body: const Center(
            child: Text("Earnings Screen"),
          ),
        );
      },
    );
  }
}

