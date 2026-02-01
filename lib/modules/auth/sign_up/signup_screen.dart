import 'package:air_bnb_clone/commons/widgets/text_snack_bar.dart';
import 'package:air_bnb_clone/modules/auth/sign_up/signup_viewmodel.dart';
import 'package:air_bnb_clone/commons/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commons/constants/app_constants.dart';

// ========== Sign Up Screen Widget ==========
class SignUpScreen extends StatefulWidget {
  // ========== Constructor ==========
  const SignUpScreen({super.key});

  // ========== Lifecycle ==========
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// ========== Sign Up Screen State ==========
class _SignUpScreenState extends State<SignUpScreen> {
  // ========== Properties ==========
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _bioController = TextEditingController();

  // ========== Action Methods ==========
  void _createAccount() async {
    final vm = context.read<SignupViewModel>();
    await vm.createAccount(
      formKey: _formKey,
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      city: _cityController.text,
      country: _countryController.text,
      bio: _bioController.text,
    );
    if (!mounted) return;
    if (vm.errorMessage.isNotEmpty) {
      TextSnackBar.show(context, vm.errorMessage);
    }
  }

  Future<void> _chooseImage() async {
    final vm = context.read<SignupViewModel>();
    await vm.chooseImage();
  }

  // ========== Build Method ==========
  Widget _header() {
    return Column(
      children: [
        Image.asset(
          'assets/images/signup.png',
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const SizedBox(height: 15.0),
        Text(
          "Start Your Journey with\n${AppConstants.appName}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26.0),
        ),
      ],
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            label: "Email",
            icon: Icons.email,
          ),
          CustomTextField(
            controller: _passwordController,
            label: "Password",
            icon: Icons.lock,
            isPassword: true,
          ),
          CustomTextField(
            controller: _firstNameController,
            label: "First Name",
            icon: Icons.person,
          ),
          CustomTextField(
            controller: _lastNameController,
            label: "Last Name",
            icon: Icons.person,
          ),
          CustomTextField(
            controller: _cityController,
            label: "City",
            icon: Icons.location_city,
          ),
          CustomTextField(
            controller: _countryController,
            label: "Country",
            icon: Icons.flag,
          ),
          CustomTextField(
            controller: _bioController,
            label: "Tell us about yourself",
            icon: Icons.edit,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _imagePicker() {
    return Consumer<SignupViewModel>(
      builder: (context, viewModel, child) {
        return MaterialButton(
          onPressed: _chooseImage,
          child: viewModel.imageFile == null
              ? const Icon(Icons.add_a_photo)
              : CircleAvatar(
            backgroundImage: FileImage(viewModel.imageFile!),
            radius: 60.0,
          ),
        );
      },
    );
  }

  Widget _signUpButton() {
    return Consumer<SignupViewModel>(
      builder: (context, viewModel, child) {
        return viewModel.isUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : MaterialButton(
          onPressed: _createAccount,
          color: Colors.white,
          height: 50.0,
          minWidth: double.infinity,
          child: const Text(
            "Sign Up",
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

  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 20.0),
          _form(),
          const SizedBox(height: 20),
          _imagePicker(),
          const SizedBox(height: 30.0),
          _signUpButton(),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: _body(),
    );
  }
}