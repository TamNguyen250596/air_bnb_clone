import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/widgets/custom_text_field.dart';
import '../../../commons/widgets/text_snack_bar.dart';
import 'edit_profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    context.read<EditProfileCubit>().submitProfile(
          formKey: _formKey,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          city: _cityController.text,
          country: _countryController.text,
          bio: _bioController.text,
        );
  }

  Future<void> _chooseImage() async {
    await context.read<EditProfileCubit>().chooseImage();
  }

  Widget _header() {
    return GestureDetector(
        onTap: _chooseImage,
        child: _avatar()
    );
  }

  Widget _avatar() {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        if (state.imageFile != null) {
          return CircleAvatar(
            backgroundImage: FileImage(state.imageFile!),
            radius: 60.0,
          );
        } else if (state.imageUrl != null) {
          return ClipOval(
            child: CachedNetworkImage(
              imageUrl: state.imageUrl!,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                width: 70,
                height: 70,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[800],
                child: const Icon(Icons.person, color: Colors.white, size: 40),
              ),
            ),
          );
        } else {
          // Added a mandatory fallback widget in case BOTH conditions are false
          return Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          );
        }
      },
    );
  }

  Widget _form() {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _emailController,
              label: "Email",
              icon: Icons.email,
              enable: false,
              initialValue: state.email,
            ),
            CustomTextField(
              controller: _firstNameController,
              label: "First Name",
              icon: Icons.person,
              initialValue: state.firstName,
            ),
            CustomTextField(
              controller: _lastNameController,
              label: "Last Name",
              icon: Icons.person,
              initialValue: state.lastName,
            ),
            CustomTextField(
              controller: _cityController,
              label: "City",
              icon: Icons.location_city,
              initialValue: state.city,
            ),
            CustomTextField(
              controller: _countryController,
              label: "Country",
              icon: Icons.flag,
              initialValue: state.country,
            ),
            CustomTextField(
              controller: _bioController,
              label: "Tell us about yourself",
              icon: Icons.edit,
              maxLines: 3,
              initialValue: state.bio,
            ),
          ],
        ),
      ),
    );
  }

  Widget _editProfileButton() {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return state.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : MaterialButton(
          onPressed: _submitProfile,
          color: Colors.white,
          height: 50.0,
          minWidth: double.infinity,
          child: const Text(
            "Update Profile",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listenWhen: (prev, curr) => curr.errorMessage != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          TextSnackBar.show(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 20.0),
              _form(),
              const SizedBox(height: 20),
              _editProfileButton(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
