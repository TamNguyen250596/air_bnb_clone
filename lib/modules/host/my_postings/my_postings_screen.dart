import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../routing/route_id.dart';
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

  void _goToUpdatePostingScreen() {
    context.pushNamed(RouteConstant.updatePosting);
  }

  // ========== Build Method ==========
  Widget _postingButton(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 12,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          Text(
            "Create a Listing",
            style: TextStyle(fontSize: 12)
          )
        ]
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'My Postings'),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: Column(
              children: [
                InkResponse(
                  onTap: _goToUpdatePostingScreen,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: _postingButton(context),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

