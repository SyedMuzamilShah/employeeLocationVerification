import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/auth/data/models/request/register_params.dart';
import 'package:my_mobile_app/features/auth/presentation/providers/basic_auth_provider.dart';
import 'package:my_mobile_app/core/routes/routes.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/core/widgets/my_text_field.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController organizationIdController;

  late FocusNode organizationNode;
  late FocusNode userNameNode;
  late FocusNode emailNode;
  late FocusNode passwordNode;


  Map<String, String> fieldErrors = {};

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    organizationIdController = TextEditingController();

    organizationNode = FocusNode();
    userNameNode = FocusNode();
    emailNode = FocusNode();
    passwordNode = FocusNode();
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
        title: const Center(child: Text("Register")),
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
                    Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (state.isLoading) const MyLoadingWidget(),
                    
                    // Success message
                    if (state.successMessage != null)
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
                            state.successMessage!,
                            style:
                                const TextStyle(color: Colors.green, fontSize: 14),
                          ),
                        ),
                      ),


                    // Error Message
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
                      controller: organizationIdController,
                      hintText: "Organization Id",
                      focusNode: organizationNode,
                      textInputAction: TextInputAction.next,
                      errorText: fieldErrors[
                          'organizationId'], // Show validation error if exists
                    ),
                    MyCustomTextField(
                      controller: userNameController,
                      hintText: "UserName",
                      focusNode: userNameNode,
                      textInputAction: TextInputAction.next,
                      errorText: fieldErrors[
                          'userName'], // Show validation error if exists
                    ),
                    MyCustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      focusNode: emailNode,
                      textInputAction: TextInputAction.next,
                      errorText: fieldErrors['email'],
                    ),
                    MyCustomTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                      focusNode: passwordNode,
                      textInputAction: TextInputAction.done,
                      errorText: fieldErrors['password'],
                    ),
                    MyCustomButton(
                      btnText: 'register',
                      
                      onClick: () async {
                        FocusScope.of(context).unfocus();
                        final RegisterParams params = RegisterParams(
                          userName: userNameController.text
                              .trim(), // Consider removing if unnecessary,
                          organizationId: organizationIdController.text.trim(),
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
