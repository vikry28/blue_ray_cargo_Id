import 'package:blue_raycargo_id/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifikasiKodeScreens extends StatefulWidget {
  const VerifikasiKodeScreens({super.key});

  @override
  State<VerifikasiKodeScreens> createState() => _VerifikasiKodeScreensState();
}

class _VerifikasiKodeScreensState extends State<VerifikasiKodeScreens> {
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? 'Unknown Email';
  }

  String? _validateKode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kode wajib diisi';
    }
    if (value.length != 6) {
      return 'Kode harus terdiri dari 6 digit';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: LogoWithTitle(
        title: 'Verifikasi Kode',
        subText:
            "Masukkan kode verifikasi yang telah dikirimkan \n ke email $email",
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _kodeController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan kode verifikasi',
                  filled: true,
                  fillColor: Color(0xFFF5FCF9),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0 * 1.5,
                    vertical: 16.0,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: _validateKode,
              ),
            ),
          ),
          ElevatedButton(
            onPressed:
                authProvider.isLoading
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String? message = await authProvider.verifyEmail(
                          email,
                          _kodeController.text,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message!),
                            backgroundColor:
                                message == 'Register code is valid.'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        );

                        if (message == 'Register code is valid.') {
                          Navigator.pushReplacementNamed(
                            context,
                            '/register_mandatory',
                            arguments: {'email': email},
                          );
                        }
                      }
                    },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF395998),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: const Text("Verifikasi"),
          ),
          const SizedBox(height: 16.0),
          Text.rich(
            TextSpan(
              text: "Tidak menerima kode? ",
              style: TextStyle(
                height: 1.5,
                color: Theme.of(
                  context,
                ).textTheme.bodyLarge!.color!.withOpacity(0.64),
              ),
              children: [
                WidgetSpan(
                  child: GestureDetector(
                    onTap:
                        authProvider.isLoading
                            ? null
                            : () async {
                              String? message = await authProvider
                                  .resendVerificationCode(email);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message!),
                                  backgroundColor:
                                      message ==
                                              'Resend registration code is success, check your code at $email'
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              );
                            },
                    child: Text(
                      "Kirim Ulang",
                      style: const TextStyle(color: Color(0xFF4285F4)),
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle({
    super.key,
    required this.title,
    this.subText = '',
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.1),
                Image.network(
                  "https://img.freepik.com/premium-vector/email-verification-with-validation-icon-with-check-mark-flat-design_614220-66.jpg",
                  height: 150,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                  width: double.infinity,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.color!.withOpacity(0.64),
                    ),
                  ),
                ),
                ...children,
              ],
            ),
          );
        },
      ),
    );
  }
}
