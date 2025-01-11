import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_health_app/app_drawer.dart';
import 'package:mental_health_app/routes/app_router.dart';
import 'package:mental_health_app/services/auth_service.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late String passwordVal;
  late String emailVal;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSignedIn = ref.watch(authProvider).when(
        data: (flag) => flag != null,
        error: (_, __) => false,
        loading: () => false);

    late List<Widget> listView;

    if (isSignedIn) {
      listView = [
        const ListTile(title: Text("You are signed in")),
        ElevatedButton(
          onPressed: () => ref.read(authProvider.notifier).logout(),
          child: const Text("Sign Out", style: TextStyle(color: Colors.black)),
        ),
      ];
    } else {
      listView = [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: TextField(
            decoration: const InputDecoration(labelText: "Email"),
            controller: _emailController,
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: PasswordTextField(passwordController: _passwordController),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).login(
                name: _emailController.text,
                password: _passwordController.text);
          },
          child: const Text("Sign In", style: TextStyle(color: Colors.black)),
        ),
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: "Don't have an account yet?",
            children: [
              TextSpan(
                text: " Create one here",
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print('creating a new account');
                    // find a new option
                    context.pushNamed(AppRoutes.createAccount.name);
                  },
              )
            ],
            style: TextStyle(color: Colors.black),
          ),
        ),
        // TODO forgot password option

        // TextButton(
        //   onPressed: () {
        //     ref.read(authProvider.notifier).login(
        //         name: _emailController.text,
        //         password: _passwordController.text);
        //   },
        //   child: ),
        // ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        shrinkWrap: true,
        children: listView,
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.labelText = "Password",
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  final String labelText;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_passwordVisible,
      controller: widget._passwordController,
      decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )),
    );
  }
}
