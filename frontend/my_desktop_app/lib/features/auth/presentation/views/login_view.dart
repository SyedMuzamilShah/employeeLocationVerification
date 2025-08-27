import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/routes/routes.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/logo_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_text_field.dart';
import 'package:my_desktop_app/features/auth/data/models/request/login_params.dart';
import 'package:my_desktop_app/features/auth/presentation/providers/basic_auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  Map<String, String> fieldErrors = {};

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final authNotifier = ref.watch(basicAuthProvider.notifier);
    final authState = ref.watch(basicAuthProvider);

    if (authState.errorList != null) {
      fieldErrors = {
        for (var error in authState.errorList!) error['path']: error['msg']
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login As Admin"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                      color: Colors.black45,
                      blurStyle: BlurStyle.outer,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 80,
                        child: ListView(
                          children: [
                            SizedBox(height: 30,),
                            if (authState.isLoading) const MyLoadingWidget(),
                            if (authState.errorMessage != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  authState.errorMessage!,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      MyCustomTextField(
                        controller: emailController,
                        hintText: "Email",
                        errorText: fieldErrors['email'],
                        validatorFuncation: (value){
                          print(value == null);
                          print("Tesing the object $value");
                          if (value != null){
                            if (value.isNotEmpty){
                              return null;
                            }
                          }
                          return 'Please fill email box';
                        },
                      ),
                      MyCustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                        errorText: fieldErrors['password'],
                      ),
                      const SizedBox(height: 20),
                      MyCustomButton(
                        btnText: 'Login',
                        onClick: () async {
                          if (_formKey.currentState!.validate()) {
                            final params = LoginParams(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            final success = await authNotifier.login(params);
                            if (success && context.mounted) {
                              Navigator.popAndPushNamed(
                                  context, AppRoutes.dashborad);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  authNotifier.clearState();
                                  Navigator.popAndPushNamed(
                                      context, AppRoutes.register);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, right: 0, child: AppLogoWidget()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
