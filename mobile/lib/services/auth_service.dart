import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_service.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> login({required String name, required String password}) async {
    print(name);
    print(password);
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: name, password: password);
    final user = FirebaseAuth.instance.currentUser;
    state = AsyncValue.data(user);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

@riverpod
Future<bool> isSignedIn(IsSignedInRef ref) async {
  final user = ref.watch(authProvider).when(
      data: (flag) => flag, error: (_, __) => false, loading: () => false);
  return user != null;
}
