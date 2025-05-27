import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/routes/routes.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_text_field.dart';
import 'package:my_desktop_app/features/auth/data/models/request/register_params.dart';
import 'package:my_desktop_app/features/auth/presentation/providers/basic_auth_provider.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  Map<String, String> fieldErrors = {};

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> fieldErrors = {};

    final register = ref.watch(basicAuthProvider.notifier);
    final state = ref.watch(basicAuthProvider);
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    if (state.errorList != null) {
      fieldErrors = {for (var e in state.errorList!) e['path']: e['msg']};
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Create Account")),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          width: isMobile ? double.infinity : 600, // Responsive width
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   'Create an Account',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      height: 80,
                      child: Image.asset(
                        'assets/app_icon.png',
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            child: Icon(Icons.person),
                          );
                        },
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  if (state.isLoading) const MyLoadingWidget(),
                  if (state.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          state.errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ),
                  MyCustomTextField(
                    controller: userNameController,
                    hintText: "User name",
                    errorText: fieldErrors[
                        'userName'], // Show validation error if exists
                  ),
                  MyCustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    errorText: fieldErrors['email'],
                  ),
                  MyCustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    errorText: fieldErrors['password'],
                  ),
                  MyCustomButton(
                    btnText: 'register',
                    onClick: () async {
                      final RegisterParams params = RegisterParams(
                        userName: userNameController.text
                            .trim(), // Consider removing if unnecessary
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      bool isRegister = await register.register(model: params);

                      if (isRegister && context.mounted) {
                        Navigator.popAndPushNamed(context, AppRoutes.dashborad);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      text: "have an account? ",
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              register.clearState();
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
