import 'package:client/core/theme/app_pallette.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState!.validate();
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
              const Text("Sign Up.",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 40),
              CustomField(
                hintText: "Name",
                controller: nameController,
                isObsureText: false,
              ),
              const SizedBox(height: 20),
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
                onTap: () {},
                buttonText: "Sign Up",
              ),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                      text: "Already have an account?",
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                    TextSpan(
                        text: " Sign In",
                        style: TextStyle(
                            color: Pallete.gradient2,
                            fontWeight: FontWeight.bold))
                  ]))
            ]),
          ),
        ));
  }
}
