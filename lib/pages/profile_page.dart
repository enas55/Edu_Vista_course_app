import 'package:edu_vista_final_project/cubit/auth_cubit.dart';
import 'package:edu_vista_final_project/pages/cart_page.dart';
import 'package:edu_vista_final_project/utils/colors_utility.dart';
import 'package:edu_vista_final_project/widgets/app_expansion_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  late TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController(text: user?.displayName ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtility.scaffoldBackground,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartPage.id);
              },
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: Text('No Data Found'),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        var profilePictureUrl = user?.photoURL;
                        if (state is UserProfilePicUpdateLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is UserProfilePicUpdateSuccess) {
                          profilePictureUrl = state.downloadUrl;
                        }
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: 83.64,
                              backgroundImage: profilePictureUrl != null &&
                                      profilePictureUrl.isNotEmpty
                                  ? NetworkImage(profilePictureUrl)
                                  : const AssetImage(
                                      'assets/images/profile-picture.webp'),
                            ),
                            Positioned(
                              top: 110,
                              left: 90,
                              child: Card(
                                color: Colors.white,
                                elevation: 0,
                                child: IconButton(
                                  onPressed: () async {
                                    await context
                                        .read<AuthCubit>()
                                        .uploadProfilePicture(context);
                                  },
                                  icon: const Icon(
                                    Icons.photo_camera_back_outlined,
                                    size: 40,
                                    color: ColorsUtility.mediumTeal,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      user?.displayName?.toUpperCase() ?? 'No name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: ColorsUtility.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'No email',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ColorsUtility.mediumBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: AppExpansionTileWidget(
                        title: 'Edit',
                        children: [
                          Column(
                            children: [
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _showEditDialog(
                                            onSave: (value, context) async {
                                              await context
                                                  .read<AuthCubit>()
                                                  .updateDisplayName(
                                                      value, context);
                                            },
                                            context: context,
                                          );
                                        },
                                        child: const Text(
                                          'Your Name',
                                          style: TextStyle(
                                            color: ColorsUtility.mediumTeal,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child:
                          AppExpansionTileWidget(title: 'About Us', children: [
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            Text(
                              """Edu Vista is a course app designed to provide users with access to various educational content. The app features course listings, allowing users to browse and purchase courses, watch video lectures, and track their progress. It includes functionality for users to view course details, instructors, and ratings, while also offering payment integration for purchasing courses. The app supports storing cart items and completed courses, enhancing the user experience by allowing for easy course management and navigation.""",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorsUtility.mediumTeal,
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return TextButton(
                                onPressed: () => _logOutAndDeleteDialog(
                                  title: 'Are you sure you want to log out?',
                                  data: 'Log Out',
                                  onPressed: () async {
                                    await context
                                        .read<AuthCubit>()
                                        .logout(context);
                                  },
                                ),
                                child: const Text(
                                  'Log out',
                                  style: TextStyle(
                                      color: ColorsUtility.mediumTeal,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return TextButton(
                                onPressed: () => _logOutAndDeleteDialog(
                                  title:
                                      'Are You Sure You Want to Delete Account?',
                                  data: 'Delete',
                                  onPressed: () async {
                                    await context
                                        .read<AuthCubit>()
                                        .deleteAccount(context);
                                  },
                                ),
                                child: const Text(
                                  'Delete Account',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showEditDialog({
    required Future Function(String value, BuildContext context) onSave,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Enter your new name',
            style: TextStyle(
              color: ColorsUtility.mediumTeal,
            ),
          ),
          content: TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  try {
                    await onSave(_nameController.text, context);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a value')),
                  );
                }
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  void _logOutAndDeleteDialog({
    required String title,
    required void Function()? onPressed,
    required String data,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              // 'Are you sure you want to log out?',
              title,
              style: const TextStyle(
                color: ColorsUtility.mediumTeal,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  data,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
