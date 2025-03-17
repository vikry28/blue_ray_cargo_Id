import 'package:blue_raycargo_id/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    // if (value.length < 8) {
    //   return 'Password minimal 8 karakter';
    // }
    // final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    // final hasDigits = value.contains(RegExp(r'[0-9]'));
    // final hasSpecialCharacters = value.contains(
    //   RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    // );
    // if (!hasUppercase || !hasDigits || !hasSpecialCharacters) {
    //   return 'Password harus mengandung huruf besar, angka, dan simbol';
    // }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXxmV4fOtZv4zZN6UdOlKXR42_Hw-jVnvLDtJNjdDJiHN_YggBb7P42UzkJrZ5VMbLCz0&usqp=CAU",
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "LOGIN",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.01),
                  Text(
                    "Silakan masuk untuk dapat menggunakan semua fitur\n Aplikasi BlueRay Cargo",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email atau nomor telepon',
                            filled: true,
                            fillColor: Color(0xFFF5FCF9),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5,
                              vertical: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: const Color(0xFFF5FCF9),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5,
                                vertical: 16.0,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              authProvider.isLoading
                                  ? null
                                  : () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      await authProvider.login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );

                                      // if (success != null) {
                                      //   ScaffoldMessenger.of(
                                      //     context,
                                      //   ).showSnackBar(
                                      //     const SnackBar(
                                      //       content: Text('Login berhasil!'),
                                      //     ),
                                      //   );
                                      //   Navigator.pushReplacementNamed(
                                      //     context,
                                      //     '/home',
                                      //   );
                                      // } else {
                                      //   ScaffoldMessenger.of(
                                      //     context,
                                      //   ).showSnackBar(
                                      //     const SnackBar(
                                      //       content: Text(
                                      //         'Login gagal! Periksa kembali email dan password',
                                      //       ),
                                      //       backgroundColor: Colors.red,
                                      //     ),
                                      //   );
                                      // }
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFF395998),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child:
                              authProvider.isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text("Login"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Lupa Password?',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: const Color(0xFF4285F4)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/registerMini');
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Tidak memiliki akun? ",
                              children: [
                                TextSpan(
                                  text: "Daftar sekarang",
                                  style: TextStyle(color: Color(0xFF4285F4)),
                                ),
                              ],
                            ),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge!.color!.withOpacity(0.64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
