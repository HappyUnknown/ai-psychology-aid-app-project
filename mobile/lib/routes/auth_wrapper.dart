import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_health_app/services/auth_service.dart';
import 'package:mental_health_app/signin/sign_in_page.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  final Widget page;
  const AuthWrapper({super.key, required this.page});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(authProvider).when(
        data: (user) => user!= null ? widget.page : const SignInPage(),
        error: (error, stack) => Text("there has been an error$error $stack"),
        loading: () => const CircularProgressIndicator());
  }
}
