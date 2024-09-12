import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:edu_vista_final_project/pages/home_page.dart';
import 'package:edu_vista_final_project/pages/login_page.dart';
import 'package:edu_vista_final_project/pages/sign_up_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  

  Future<void> login({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    try {
      var credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (credentials.user != null) {

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Logged in sucessfully'),
            ),
          );

          Navigator.pushReplacementNamed(context, HomePage.id);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for this email'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password'),
          ),
        );
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User disabled'),
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credential'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
      }
    }
  }

  Future<void> signUp({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    try {
      var credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (credentials.user != null) {
        credentials.user!.updateDisplayName(nameController.text);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Account created sucessfully'),
            ),
          );

          Navigator.pushReplacementNamed(context, HomePage.id);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The email provided is already existing'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Sign upexception : $e'),
          ),
        );
      }
    }
  }

  Future<void> forgotPassword({
    required TextEditingController emailController,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);

      emit(PasswordResetEmailSent());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Password reset email sent'),
          ),
        );

        Navigator.pushReplacementNamed(
          context,
          LoginPage.id,
          arguments: emailController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(PasswordResetFailed(e.message ?? "Unknown error"));

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to send password reset email'),
        ),
      );
    } catch (e) {
      emit(PasswordResetFailed('Something went wrong'));
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  Future<void> checkUserStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool firstLogin = prefs.getBool('first_login') ?? true;

      log('First login status: $firstLogin');

      if (firstLogin) {
        emit(NewUser());
        await prefs.setBool('first_login', false);
        log('Emitted NewUser and updated first_login to false');
      } else {
        emit(OldUser());
        log('Emitted OldUser');
      }
    } catch (e) {
      emit(AuthFailure('Failed to check user status: $e'));
      log('Error checking user status: $e');
    }
  }

  Future<void> updateDisplayName(String name, BuildContext context) async {
    emit(UserNameUpdateLoading());
    try {
      var credentials = FirebaseAuth.instance.currentUser;
      if (credentials == null) {
        emit(UserNameUpdateFailed('No user logged in'));
      } else {
        await credentials.updateDisplayName(name);
        await credentials.reload();
        log('Name updated to: ${credentials.displayName}');
        emit(UserNameUpdateSuccess('Name updated successfully'));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Name updated successfully'),
            ),
          );
        }
      }
    } catch (e) {
      emit(UserNameUpdateFailed(e.toString()));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating name: $e')),
      );
    }
  }

  Future<void> uploadProfilePicture(BuildContext context) async {
    emit(UserProfilePicUpdateLoading());

    var imageResult = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);

    if (imageResult != null) {
      var storageRef = FirebaseStorage.instance
          .ref('images/${imageResult.files.first.name}');

      var uploadResult = await storageRef.putData(
          imageResult.files.first.bytes!,
          SettableMetadata(
            contentType:
                'image/${imageResult.files.first.name.split('.').last}',
          ));
      if (uploadResult.state == TaskState.success) {
        var downloadUrl = await uploadResult.ref.getDownloadURL();
        log('Image upload $downloadUrl');

        emit(UserProfilePicUpdateSuccess(
            'Profile picture updated successfully'));
      } else {
        emit(UserProfilePicUpdateFailed('Failed to upload profile picture'));
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();

      bool firstLogin = prefs.getBool('first_login') ?? true;
      await prefs.clear();
      await prefs.setBool('first_login', firstLogin);

      emit(AuthLogoutSuccess('Logged out'));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged Out'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, LoginPage.id);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log out : $e'),
          backgroundColor: Colors.red,
        ),
      );
      emit(AuthLogoutFailed('Logout failed: $e'));
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    emit(AuthDeleteLoading());

    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AuthDeleteFailed('No user is logged in.'));
        return;
      }

      await user.delete();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      emit(AuthDeleteSuccess('Account deleted successfully'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, SignUpPage.id);
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthDeleteFailed(
          e.message ?? 'An error occurred while deleting the account.'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Failed to delete account'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      emit(AuthDeleteFailed('Something went wrong'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
