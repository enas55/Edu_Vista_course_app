import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_final_project/pages/home_page.dart';
import 'package:edu_vista_final_project/pages/login_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> login({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    try {
      var credentials = await _auth.signInWithEmailAndPassword(
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
      var credentials = await _auth.createUserWithEmailAndPassword(
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
      await _auth.sendPasswordResetEmail(email: emailController.text);

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
      var credentials = _auth.currentUser;
      if (credentials == null) {
        emit(UserNameUpdateFailed('No user logged in'));
      } else {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'user_name': name,
        });

        await credentials.updateDisplayName(name);

        await credentials.reload();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('display_name', name);

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

    try {
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

          if (FirebaseAuth.instance.currentUser != null) {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              'profile_Picture': downloadUrl,
            });
          }

          SharedPreferences prefs = await SharedPreferences.getInstance();

          await prefs.setString('profile_picture_url', downloadUrl);

          emit(UserProfilePicUpdateSuccess(
              'Profile picture updated successfully'));
        } else {
          emit(UserProfilePicUpdateFailed('Failed to upload profile picture'));
        }
      }
    } catch (e) {
      emit(UserProfilePicUpdateFailed('Error uploading profile picture: $e'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading profile picture: $e')),
        );
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    emit(AuthLoading());
    try {
      await _auth.signOut();

      await _googleSignIn.signOut();

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
      var user = _auth.currentUser;
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
        Navigator.pushReplacementNamed(context, LoginPage.id);
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

  Future<void> signInWithGoogle(BuildContext context) async {
    emit(GoogleSignInLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(GoogleSignInFailed('Google sign in failed'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      emit(GoogleSignInSuccess());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in sucessfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, HomePage.id);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in failed'),
          backgroundColor: Colors.red,
        ),
      );
      log('google sign in failed: $e');
      emit(GoogleSignInFailed(e.toString()));
    }
  }
}
