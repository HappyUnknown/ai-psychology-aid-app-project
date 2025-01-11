import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_health_app/signin/create_account_model.dart';
import 'package:mental_health_app/signin/sign_in_page.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreateAccountPageState();
  }
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  late TextEditingController _name;
  late TextEditingController _role;
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _repeatPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController();
    _role = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _repeatPassword = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _name.dispose();
    _role.dispose();
    _email.dispose();
    _password.dispose();
    _repeatPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Name:"),
              controller: _name,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Role:"),
              controller: _role,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Email:"),
              controller: _email,
            ),
            PasswordTextField(passwordController: _password),
            PasswordTextField(
                labelText: "Repeat Password",
                passwordController: _repeatPassword),
            TextButton(
                onPressed: () async {
                  //
                  print("creating account");
                  bool result = await ref.watch(createNewAccountProvider(
                          userName: _name.text,
                          role: _role.text,
                          email: _email.text,
                          password: _password.text,
                          passwordReapeated: _repeatPassword.text)
                      .future);
                  if (result) {
                    print("user has been created");
                    context.pop();
                  } else {
                    print("account has not been created");
                  }
                },
                child: const Text("Complete"))
          ],
        ),
      ),
    );
  }
}
