import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../commons/constants/app_constants.dart';
import '../../../routing/route_id.dart';
import '../../../commons/widgets/text_snack_bar.dart';
import '../../../commons/widgets/custom_text_field.dart';
import 'login_viewmodel.dart';

// ========== Login Screen Widget ==========
class LogInScreen extends StatefulWidget {
  // ========== Constructor ==========
  const LogInScreen({super.key});

  // ========== Lifecycle ==========
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

// ========== Login Screen State ==========
class _LogInScreenState extends State<LogInScreen> {

  // ========== ViewModel ==========
  final _formKey = GlobalKey<FormState>();

  // ========== Properties ==========
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ========== Navigation Methods ==========
  void _goToSignUpScreen() {
    context.pushNamed(RouteConstant.signUp);
  }

  // ========== Action Methods ==========
  void _signIn() async {
    final vm = context.read<LoginViewModel>();
    await vm.signIn(_formKey, _emailController.text, _passwordController.text);
    if (!mounted) return;
    if (vm.errorMessage.isNotEmpty) {
      TextSnackBar.show(context, vm.errorMessage);
    }
  }

  // ========== Build Method ==========
  Widget _header(BuildContext context) {
    return Column(
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
      ]
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
        ],
      ),
    );
  }

  Widget _logInButton() {
    return SizedBox(
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
        child: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.isLoading ?
            const CircularProgressIndicator(color: Colors.black) :
            const Text("Log In", style: TextStyle(fontSize: 22.0));
          }
        )
      ),
    );
  }

  Widget _signUpButton() {
    final vm = context.read<LoginViewModel>();

    return SizedBox(
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
        onPressed: vm.isLoading
            ? null
            : _goToSignUpScreen,
        child: Text("Sign Up", style: TextStyle(fontSize: 22.0)),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          _header(context),
          const SizedBox(height: 20.0),
          _form(),
          const SizedBox(height: 20),
          _logInButton(),
          const SizedBox(height: 20),
          _signUpButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }
}
