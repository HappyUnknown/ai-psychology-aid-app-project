import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    ref.invalidateSelf();
  }

  Future<void> createAccount({
    required String name,
    required String role,
    required String email,
    required String password,
  }) async {
    // call into firebase to create a user with name and email

    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      print("user signed in successful ${userCredential.additionalUserInfo}");

      // do a call into firestore
      DocumentReference doc =
          await FirebaseFirestore.instance.collection("users").add({
        "uid": userCredential.user!.uid,
        "name": name,
        "role": role,
        "email": email,
      });

      if (doc.get() != null) {
        // doc has been successfuly created
        print("user has been added to firestore and allat");
        state = AsyncValue.data(userCredential.user);
      }

      state = AsyncValue.data(userCredential.user);
    } else {
      print("user signed in failed ${userCredential.additionalUserInfo}");
    }
  }
}

@riverpod
String currentUid(CurrentUidRef ref) {
  try {
    return FirebaseAuth.instance.currentUser!.uid;
  } catch (e) {
    print(
        "there has been an exception when using FirebaseAuth current user is null error: $e");
    return "none";
  }
}
