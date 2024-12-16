import 'package:go_router/go_router.dart';
import 'package:mental_health_app/chatbot/chatbot_page.dart';
import 'package:mental_health_app/routes/auth_wrapper.dart';
import 'package:mental_health_app/signin/sign_in_page.dart';
import 'package:mental_health_app/support/support_page.dart';
import 'package:mental_health_app/theory/theory_page.dart';


enum AppRoutes {
  theory,
  chatbot,
  support,
  signin,
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.chatbot.name,
      builder: (context, state) => const AuthWrapper(page: ChatBotPage())
    ),
    GoRoute(
      path: '/theory',
      name: AppRoutes.theory.name,
      builder: (context, state) => TheoryPage(),
    ),
    GoRoute(
      path: '/support',
      name: AppRoutes.support.name,
      builder: (context, state) => const SupportPage(),
    ),
    GoRoute(
      path: '/signin',
      name: AppRoutes.signin.name,
      builder: (context, state) => const SignInPage(),
    ),
  ],
);
