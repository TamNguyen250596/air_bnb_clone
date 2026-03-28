import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/widgets/custom_app_bar.dart';
import '../../../routing/route_id.dart';
import '../../../commons/widgets/text_snack_bar.dart';
import 'account_cubit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void _changeHost(BuildContext context) {
    context.read<AccountCubit>().changeHost();
  }

  Future<void> _signOut(BuildContext context) async {
    context.read<AccountCubit>().signOut();
  }

  void _navigateToEditProfile(BuildContext context) {
    context.pushNamed(RouteConstant.editProfile);
  }

  Widget _avatar(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _navigateToEditProfile(context),
          child: CachedNetworkImage(
            imageUrl: state.avatarUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
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

  Widget _fullName(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Text(
          state.fullName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }

  Widget _email(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return Text(
          state.email,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );
      },
    );
  }

  Widget _businessButtonTitle(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        return _buildActionTitle(
          context,
          state.businessButtonTitle,
          Icons.add_business,
          () => _changeHost(context),
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
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountState>(
      listenWhen: (prev, curr) =>
          (curr.errorMessage != null && curr.errorMessage!.isNotEmpty) ||
          curr.routeId != null,
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          TextSnackBar.show(context, state.errorMessage!);
        }
        if (state.routeId != null) {
          context.go(state.routeId!);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Profile'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      _avatar(context),
                      const SizedBox(height: 16),
                      _fullName(context),
                      const SizedBox(height: 4),
                      _email(context),
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
                _businessButtonTitle(context),
                const SizedBox(height: 16),
                _buildActionTitle(
                  context,
                  "Log Out",
                  Icons.login_outlined,
                  () async => await _signOut(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
