import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_raycargo_id/provider/auth_provider.dart';

class RegisterMScreens extends StatefulWidget {
  const RegisterMScreens({super.key});

  @override
  State<RegisterMScreens> createState() => _RegisterMScreensState();
}

class _RegisterMScreensState extends State<RegisterMScreens> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? 'Unknown Email';
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF395998),
        foregroundColor: Colors.white,
        title: const Text("Lengkapi Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfilePic(
              image:
                  'https://img.freepik.com/premium-vector/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-vector-illustration_561158-3383.jpg',
              imageUploadBtnPress: () {},
            ),
            const Divider(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Nama Depan",
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'John',
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  UserInfoEditField(
                    text: "Nama Belakang",
                    child: TextFormField(
                      controller: lastnameController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'nash',
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama belakang wajib diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  UserInfoEditField(
                    text: "Email",
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'email@gmail.com',
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  UserInfoEditField(
                    text: "Phone",
                    child: TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: '081',
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor tidak boleh kosong';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Nomor tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  UserInfoEditField(
                    text: "Password",
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '********',
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        if (value.length < 8) {
                          return 'Password minimal 8 karakter';
                        }
                        final hasUppercase = value.contains(RegExp(r'[A-Z]'));
                        final hasDigits = value.contains(RegExp(r'[0-9]'));
                        final hasSpecialCharacters = value.contains(
                          RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                        );
                        if (!hasUppercase ||
                            !hasDigits ||
                            !hasSpecialCharacters) {
                          return 'huruf besar, angka, dan simbol';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      nameController.clear();
                      emailController.clear();
                      phoneController.clear();
                      addressController.clear();
                      passwordController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.color!.withOpacity(0.08),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF395998),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        String? message = await authProvider.register(
                          nameController.text,
                          lastnameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message!),
                            backgroundColor:
                                message == 'Customer successfully registered.'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        );
                        if (message == 'Customer successfully registered.') {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (Route<dynamic> route) => false,
                          );
                        }
                      }
                    },
                    child: const Text("Register"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(
            context,
          ).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(radius: 50, backgroundImage: NetworkImage(image)),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({super.key, required this.text, required this.child});

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(text)),
          Expanded(flex: 3, child: child),
        ],
      ),
    );
  }
}
