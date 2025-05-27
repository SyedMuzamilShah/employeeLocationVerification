import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/auth/data/models/request/login_params.dart';
import 'package:my_mobile_app/features/auth/presentation/providers/basic_auth_provider.dart';
import 'package:my_mobile_app/core/routes/routes.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/core/widgets/my_text_field.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FocusNode emailNode;
  late FocusNode passwordNode;

  Map<String, String> fieldErrors = {};

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailNode = FocusNode();
    passwordNode = FocusNode();

  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> fieldErrors = {};

    final login = ref.watch(basicAuthProvider.notifier);
    final state = ref.watch(basicAuthProvider);
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    if (state.errorList != null) {
      fieldErrors = {for (var e in state.errorList!) e['path']: e['msg']};
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login As Employee')),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          width: isMobile ? double.infinity : 600, // Responsive width
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Login As Employee',
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(
                      height : 50,
                      child : Image.asset(
                        'assets/app_logo.png',
                      )
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
                      controller: emailController,
                      hintText: "Email",
                      errorText: fieldErrors['email'],
                      focusNode: emailNode,
                      textInputAction: TextInputAction.next,
                    ),
                    MyCustomTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                      errorText: fieldErrors['password'],
                      focusNode: passwordNode,
                      textInputAction: TextInputAction.done,

                    ),
                    MyCustomButton(
                      btnText: 'Login',
                      onClick: () async {
                        final LoginParams params = LoginParams(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        FocusScope.of(context).unfocus();
                        bool isRegister = await login.login(params);
                
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
                            text: 'register',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                login.clearState();
                                Navigator.pushNamed(context, AppRoutes.register);
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
