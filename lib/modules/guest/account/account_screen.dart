import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../commons/widgets/text_snack_bar.dart';
import 'account_viewmodel.dart';

// ========== Account Screen Widget ==========
class AccountScreen extends StatefulWidget {
  // ========== Constructor ==========
  const AccountScreen({super.key});

  // ========== Lifecycle ==========
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

// ========== Account Screen State ==========
class _AccountScreenState extends State<AccountScreen> {

  // ========== Action Methods ==========
  Future<void> _changeHost() async {
    final vm = context.read<AccountViewModel>();
    await vm.changeHost();
    if (!mounted) return;
    if (vm.errorMessage.isNotEmpty) {
      TextSnackBar.show(context, vm.errorMessage);
    } else if (vm.routeId != null) {
      context.go(vm.routeId!);
    }
  }

  Future<void> _signOut() async {
    final vm = context.read<AccountViewModel>();
    await vm.signOut();
    if (!mounted) return;
    if (vm.errorMessage.isNotEmpty) {
      TextSnackBar.show(context, vm.errorMessage);
    }
  }

  // ========== Build Method ==========
  Widget _avatar() {
    return Consumer<AccountViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: () {},
          child: CachedNetworkImage(
            imageUrl: viewModel.avatarUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            imageBuilder: (context, imageProvider) => Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(90)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Colors.grey,
              radius: MediaQuery.of(context).size.width / 4.5,
              child: Icon(
                Icons.person,
                size: MediaQuery.of(context).size.width / 4.5,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fullName() {
    return Consumer<AccountViewModel>(
      builder: (context, viewModel, child) {
        return Text(
          viewModel.fullName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }

  Widget _email() {
    return Consumer<AccountViewModel>(
      builder: (context, viewModel, child) {
        return Text(
          viewModel.email,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }

  Widget _businessButtonTitle() {
    return Consumer<AccountViewModel>(
      builder: (context, viewModel, child) {
        return _buildActionTitle(
          context,
          viewModel.businessButtonTitle,
          Icons.add_business,
          _changeHost,
        );
      },
    );
  }

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          trailing: Icon(icon, size: 32),
          leading: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: .bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    _avatar(),
                    const SizedBox(height: 16),
                    _fullName(),
                    const SizedBox(height: 4),
                    _email(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildActionTitle(
                context,
                "Personal Information",
                Icons.person_pin,
                () {},
              ),
              const SizedBox(height: 16),
              _businessButtonTitle(),

              const SizedBox(height: 16),
              _buildActionTitle(
                context,
                "Log Out",
                Icons.login_outlined,
                _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
