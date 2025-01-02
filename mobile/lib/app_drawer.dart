import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mental_health_app/locale_provider.dart';
import 'package:mental_health_app/routes/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            TextButton(
              onPressed: () {
                context.goNamed(AppRoutes.chatbot.name);
              },
              child: Text(
                AppLocalizations.of(context)!.chatBot,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(AppRoutes.theory.name);
              },
              child: Text(
                AppLocalizations.of(context)!.theory,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(AppRoutes.support.name);
              },
              child: Text(
                AppLocalizations.of(context)!.support,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(AppRoutes.signin.name);
              },
              child: Text(
                AppLocalizations.of(context)!.signIn,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Consumer(builder: (context, ref, child) {
              final locale = ref.watch(localeChangerProvider);
              final isUkrainian = locale == const Locale("uk");
              return GestureDetector(
                onTap: () {
                  ref.read(localeChangerProvider.notifier).changeLocale();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "UA",
                      style: TextStyle(
                        fontSize: 24,
                        decoration:
                            isUkrainian ? TextDecoration.underline : null,
                      ),
                    ),
                    Text(
                      "EN",
                      style: TextStyle(
                        fontSize: 24,
                        decoration:
                            isUkrainian ? null : TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
