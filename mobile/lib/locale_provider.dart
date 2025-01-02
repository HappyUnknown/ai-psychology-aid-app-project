import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleChanger extends _$LocaleChanger {
  @override
  Locale build() {
    return const Locale('uk');
  }

  void changeLocale() {
    if (state == const Locale('uk')) {
      state = const Locale('en');
    } else {
      state = const Locale('uk');
    }
  }
}
