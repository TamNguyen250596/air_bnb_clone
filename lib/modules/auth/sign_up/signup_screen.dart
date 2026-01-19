import 'package:air_bnb_clone/commons/widgets/text_snack_bar.dart';
import 'package:air_bnb_clone/modules/auth/sign_up/signup_viewmodel.dart';
import 'package:air_bnb_clone/commons/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../../../commons/constants/app_constants.dart';

// ========== Sign Up Screen Widget ==========
class SignUpScreen extends StatefulWidget {
  // ========== Constructor ==========
  const SignUpScreen({super.key, required this.viewModel});

  // ========== Properties ==========
  final SignupViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// ========== Sign Up Screen State ==========
class _SignUpScreenState extends State<SignUpScreen> {
  // ========== Properties ==========
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _bioController = TextEditingController();

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
      TextSnackBar.show(context, widget.viewModel.errorMessage);
    }
  }

  void _createAccount() {
    widget.viewModel.createAccount(
      _emailController.text,
      _passwordController.text,
      _firstNameController.text,
      _lastNameController.text,
      _cityController.text,
      _countryController.text,
      _bioController.text
    );
  }

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/signup.png',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                ),

                const SizedBox(height: 15.0),

                Text(
                  "Start Your Journey with\n${AppConstants.appName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26.0),
                ),

                const SizedBox(height: 20.0),

                Form(
                  key: widget.viewModel.formKey,
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
                ),

                const SizedBox(height: 20),

                MaterialButton(
                  onPressed: widget.viewModel.chooseImage,
                  child: widget.viewModel.imageFile == null
                      ? const Icon(Icons.add_a_photo)
                      : CircleAvatar(
                    backgroundImage:
                    FileImage(widget.viewModel.imageFile!),
                    radius: 60.0,
                  ),
                ),

                const SizedBox(height: 30.0),

                widget.viewModel.isUploading
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
                ),

                const SizedBox(height: 20.0),
              ],
            ),
          );
        },
      ),
    );
  }
}