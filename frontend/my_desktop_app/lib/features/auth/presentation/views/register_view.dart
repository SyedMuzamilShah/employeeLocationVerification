import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/routes/routes.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/logo_widget.dart';
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
  final _formKey = GlobalKey<FormState>();

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
        title: const Center(child: Text("Create Account As Admin")),
        centerTitle: true,
        automaticallyImplyLeading: false,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
                width: isMobile ? double.infinity : 500,
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            if (state.isLoading) const MyLoadingWidget(),
                            if (state.errorMessage != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    state.errorMessage!,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onError, fontSize: 14),
                                  ),
                                ),
                              ),
                          ],
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

                          bool isRegister =
                              await register.register(model: params);

                          if (isRegister && context.mounted) {
                            Navigator.popAndPushNamed(
                                context, AppRoutes.dashborad);
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  register.clearState();
                                  Navigator.popAndPushNamed(context, AppRoutes.login);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          
            Positioned(top: 0, left: 0, right: 0, child: AppLogoWidget()),
          ],
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
