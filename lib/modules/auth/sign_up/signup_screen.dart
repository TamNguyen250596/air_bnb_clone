import 'package:air_bnb_clone/commons/widgets/text_snack_bar.dart';
import 'package:air_bnb_clone/commons/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/constants/app_constants.dart';
import 'signup_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _bioController = TextEditingController();

  void _createAccount() {
    context.read<SignupCubit>().createAccount(
      formKey: _formKey,
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      city: _cityController.text,
      country: _countryController.text,
      bio: _bioController.text,
    );
  }

  Future<void> _chooseImage() async {
    await context.read<SignupCubit>().chooseImage();
  }

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
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (prev, curr) => prev.imageFile != curr.imageFile,
      builder: (context, state) {
        return MaterialButton(
          onPressed: _chooseImage,
          child: state.imageFile == null
              ? const Icon(Icons.add_a_photo)
              : CircleAvatar(
                  backgroundImage: FileImage(state.imageFile!),
                  radius: 60.0,
                ),
        );
      },
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return state.isLoading
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (prev, curr) => curr.isFailure && curr.errorMessage != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          TextSnackBar.show(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Account')),
        body: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
