import 'package:flutter/material.dart';
import '../../../commons/constants/app_constants.dart';
import '../../../commons/constants/route_id.dart';
import '../../../commons/views/TextSnackBar.dart';
import '../../../widgets/custom_text_field.dart';
import 'login_viewmodel.dart';

// ========== Login Screen Widget ==========
class LogInScreen extends StatefulWidget {
  // ========== Constructor ==========
  const LogInScreen({super.key, required this.viewModel});

  // ========== Properties ==========
  final LoginViewModel viewModel;

  // ========== Lifecycle ==========
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

// ========== Login Screen State ==========
class _LogInScreenState extends State<LogInScreen> {
  // ========== Properties ==========
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

  // ========== Navigation Methods ==========
  void _goToSignUpScreen() {
    Navigator.pushNamed(context, RouteId.signUpScreen);
  }

  // ========== Action Methods ==========
  void _signIn() {
    widget.viewModel.signIn(_emailController.text, _passwordController.text);
  }

  void _onViewModelUpdate() {
    if (widget.viewModel.errorMessage.isNotEmpty) {
      TextSnackBar.show(context, widget.viewModel.errorMessage);
    }
    if (widget.viewModel.isLogInSuccess) {
      Navigator.pushNamedAndRemoveUntil(context, RouteId.guestScreen, (route) => false,);
    }
  }

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                ),

                const SizedBox(height: 15.0),

                Text(
                  "FIND STAYS & RETAILS WITH ${AppConstants.appName}"
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26.0, fontWeight: .bold),
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
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 15,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4.0,
                    ),
                    onPressed: _signIn,
                    child: widget.viewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text("Log In", style: TextStyle(fontSize: 22.0)),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 15,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: widget.viewModel.isLoading
                        ? null
                        : _goToSignUpScreen,
                    child: Text("Sign Up", style: TextStyle(fontSize: 22.0)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
