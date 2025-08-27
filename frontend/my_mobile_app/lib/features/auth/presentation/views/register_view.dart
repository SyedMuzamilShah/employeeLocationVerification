import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/widgets/logo_widget.dart';
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
    print("Mobile Register view");
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
        child: Padding(
          padding: EdgeInsets.all(16),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 60,
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 15,
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
                )
              ),
            
              Positioned(top: 5, left: 0, right: 0, child: AppLogoWidget()),
          
            ],
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
