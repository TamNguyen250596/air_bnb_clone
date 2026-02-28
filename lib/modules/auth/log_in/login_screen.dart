import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/constants/app_constants.dart';
import '../../../routing/route_id.dart';
import '../../../commons/widgets/text_snack_bar.dart';
import '../../../commons/widgets/custom_text_field.dart';
import 'login_cubit.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _goToSignUpScreen() {
    context.pushNamed(RouteConstant.signUp);
  }

  void _signIn() {
    context.read<LoginCubit>().signIn(
      _formKey,
      _emailController.text,
      _passwordController.text,
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const SizedBox(height: 15.0),
        Text(
          "FIND STAYS & RETAILS WITH ${AppConstants.appName}".toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }

  Widget _logInButton() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 15,
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4.0,
            ),
            onPressed: state.isLoading ? null : _signIn,
            child: state.isLoading
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text("Log In", style: TextStyle(fontSize: 22.0)),
          );
        },
      ),
    );
  }

  Widget _signUpButton() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 15,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 2.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: state.isLoading ? null : _goToSignUpScreen,
            child: const Text("Sign Up", style: TextStyle(fontSize: 22.0)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (prev, curr) => curr.isFailure && curr.errorMessage != null,
      listener: (context, state) {
        if (state.errorMessage != null) {
          TextSnackBar.show(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
