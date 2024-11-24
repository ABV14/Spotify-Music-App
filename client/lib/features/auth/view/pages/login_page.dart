import 'package:client/core/theme/app_pallette.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  onTap: () async {
                    await AuthRemoteRepository().login(
                        email: emailController.text,
                        password: passwordController.text);
                  },
                  buttonText: "Sign In"),
              const SizedBox(height: 20),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()));
                  },
                  child: RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: Theme.of(context).textTheme.titleMedium,
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
