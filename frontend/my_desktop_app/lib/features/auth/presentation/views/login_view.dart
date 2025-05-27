import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/routes/routes.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_text_field.dart';
import 'package:my_desktop_app/features/auth/data/models/request/login_params.dart';
import 'package:my_desktop_app/features/auth/presentation/providers/basic_auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> fieldErrors = {};
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final login = ref.watch(basicAuthProvider.notifier);
    final state = ref.watch(basicAuthProvider);

    login.addListener((state) {
      if (state.errorList != null) {
        fieldErrors = {for (var e in state.errorList!) e['path']: e['msg']};
      }
    });
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Login")),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: isMobile ? double.infinity : 600, // Responsive width
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // if (!isMobile)
                // Expanded(
                //   flex: 1,
                //   child: Center(child: Text("Image"),)),

                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Builder(builder: (context) {
                        return SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Text(
                                //   'Login an Account',
                                //   style: Theme.of(context)
                                //       .textTheme
                                //       .titleLarge
                                //       ?.copyWith(fontSize: isMobile ? 18 : 24),
                                // ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: SizedBox(
                                    height: 80,
                                    child: Image.asset(
                                      'assets/app_icon.png',
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        state.errorMessage!,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError,
                                            fontSize: 14),
                                      ),
                                    ),
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
                                SizedBox(height: 20),
                                MyCustomButton(
                                  btnText: 'Login',
                                  onClick: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final pramas = LoginParams(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );

                                      bool isLogin = await login.login(pramas);

                                      if (isLogin && context.mounted) {
                                        Navigator.popAndPushNamed(
                                            context, AppRoutes.dashborad);
                                      }
                                    }
                                  },
                                ),
                                SizedBox(height: 16),
                                const SizedBox(height: 20),
                                Text.rich(
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    children: [
                                      TextSpan(
                                        text: 'Register',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            login.clearState();
                                            Navigator.pushNamed(
                                                context, AppRoutes.register);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
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
