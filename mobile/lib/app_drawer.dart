import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_health_app/routes/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          TextButton(
            onPressed: () {
              context.goNamed(AppRoutes.chatbot.name);
            },
            child: const Text("ChatBot"),
          ),
          TextButton(
            onPressed: () {
              context.goNamed(AppRoutes.theory.name);
            },
            child: const Text("Theory"),
          ),
          TextButton(
            onPressed: () {
              context.goNamed(AppRoutes.support.name);
            },
            child: const Text("Support"),
          ),
          TextButton(
            onPressed: () {
              context.goNamed(AppRoutes.signin.name);
            },
            child: const Text("SignIn"),
          )
        ],
      ),
    );
  }
}
