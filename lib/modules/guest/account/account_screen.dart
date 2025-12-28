import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'account_viewmodel.dart';

// ========== Account Screen Widget ==========
class AccountScreen extends StatefulWidget {
  // ========== Constructor ==========
  const AccountScreen({super.key, required this.viewModel});

  // ========== Properties ==========
  final AccountViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

// ========== Account Screen State ==========
class _AccountScreenState extends State<AccountScreen> {
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
    if (widget.viewModel.routeId != null) {
      context.go(widget.viewModel.routeId!);
    }
  }

  // ========== Build Method ==========
  Widget _buildActionTitle(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Container(
      color: Colors.white12,
      child: MaterialButton(
        onPressed: onTap,
        height: MediaQuery.of(context).size.height / 9.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          trailing: Icon(icon, size: 32),
          leading: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: .bold,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: widget.viewModel.avatarUrl.isNotEmpty ? NetworkImage(widget.viewModel.avatarUrl) : null,
                            radius: MediaQuery.of(context).size.width / 4.5,
                            child:  widget.viewModel.avatarUrl.isNotEmpty
                                ? null
                                : Icon(Icons.person, size: MediaQuery.of(context).size.width / 4.5, color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          widget.viewModel.fullName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.viewModel.email,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ]
                    )
                  ),
                  const SizedBox(height: 16),
                  _buildActionTitle(
                    context,
                    "Personal Information",
                    Icons.person_pin,
                    () {},
                  ),

                  const SizedBox(height: 16),
                  _buildActionTitle(
                    context,
                    widget.viewModel.businessButtonTitle,
                    Icons.add_business,
                    widget.viewModel.changeHost,
                  ),

                  const SizedBox(height: 16),
                  _buildActionTitle(
                    context,
                    "Log Out",
                    Icons.login_outlined,
                    widget.viewModel.signOut,
                  ),
                ],
              )
          ),
        );
      },
    );
  }
}