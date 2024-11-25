import 'package:client/core/theme/app_pallette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
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
            showSnackBar(context, "Account created Successfully, Please Login");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
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
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              ref
                                  .read(authViewModelProvider.notifier)
                                  .signUpUser(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                            }
                          },
                          buttonText: "Sign Up",
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: "Already have an account?",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    children: const [
                                  TextSpan(
                                      text: " Sign In",
                                      style: TextStyle(
                                          color: Pallete.gradient2,
                                          fontWeight: FontWeight.bold))
                                ])))
                      ]),
                ),
              ));
  }
}
