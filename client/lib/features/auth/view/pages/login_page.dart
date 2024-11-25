import 'package:client/core/theme/app_pallette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/home_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
// import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState!.validate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authViewModelProvider.select((value) => value?.isLoading == true));
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text("Login Succesful!")));
            // Create Home Page
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (_) => false);
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });
    return Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sign In.",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 40),
                        CustomField(
                          hintText: "Email",
                          controller: emailController,
                          isObsureText: false,
                        ),
                        const SizedBox(height: 20),
                        CustomField(
                            hintText: "Password",
                            controller: passwordController,
                            isObsureText: true),
                        const SizedBox(height: 20),
                        AuthGradientButton(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                ref
                                    .read(authViewModelProvider.notifier)
                                    .loginUser(
                                        email: emailController.text,
                                        password: passwordController.text);
                              }
                            },
                            buttonText: "Sign In"),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupPage()));
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: 'Don\'t have an account?',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    children: const [
                                  TextSpan(
                                      text: " Sign Up",
                                      style: TextStyle(
                                          color: Pallete.gradient2,
                                          fontWeight: FontWeight.bold))
                                ])))
                      ]),
                ),
              ));
  }
}
