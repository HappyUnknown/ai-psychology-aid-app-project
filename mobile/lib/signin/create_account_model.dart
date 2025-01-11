import 'package:mental_health_app/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'create_account_model.g.dart';

@riverpod
Future<bool> createNewAccount(
  CreateNewAccountRef ref, {
  String? userName,
  String? role,
  String? email,
  String? password,
  String? passwordReapeated,
}) async {
  bool nameCheck = userName != null;
  bool roleCheck = role != null;
  bool emailCheck = email != null && email.length > 3 && email.contains("@", 1);
  bool passwordCheck = password != null &&
      password.contains(RegExp(
          r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")) &&
      password == passwordReapeated;
  bool result = nameCheck && roleCheck && emailCheck && passwordCheck;
  // TODO make sure to have a way to display specific errors
  // name, role, email are missing
  // email is not a proper format
  // passwords missing number/letter/special character 
  // passwords not matching
  if (result) {
    // make this return a user and once the user is returned 
    // get validate what happened and maybe display a message
    ref.read(authProvider.notifier).createAccount(
          name: userName,
          role: role,
          email: email,
          password: password,
        );
  } else {
    print ("name $nameCheck");
    print ("role $roleCheck");
    print ("email $emailCheck");
    print ("password $passwordCheck");

  }

  return result;
}
