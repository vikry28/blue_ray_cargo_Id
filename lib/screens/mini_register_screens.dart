import 'package:blue_raycargo_id/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniRegisScreens extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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

  MiniRegisScreens({super.key});
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
        title: 'Pendaftaran',
        subText:
            "Silahkan isi data dengan benar \n untuk membuat akun baru di BlueRay Cargo",
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
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
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
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
                        String? message = await authProvider.registerMini(
                          _emailController.text,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message!),
                            backgroundColor:
                                message ==
                                        'New user registration  is successful'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        );

                        if (message == 'New user registration  is successful') {
                          Navigator.pushReplacementNamed(
                            context,
                            '/verisikasi_kode',
                            arguments: {'email': _emailController.text},
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
            child:
                authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Daftar Sekarang"),
          ),
          const SizedBox(height: 16.0),
          Text.rich(
            TextSpan(
              text: "Dengan mendaftar, Anda menyetujui\n",
              style: TextStyle(
                height: 1.5,
                color: Theme.of(
                  context,
                  // ignore: deprecated_member_use
                ).textTheme.bodyLarge!.color!.withOpacity(0.64),
              ),
              children: [
                TextSpan(
                  text: "Syarat & Ketentuan",
                  style: TextStyle(color: Color(0xFF4285F4)),
                ),
                const TextSpan(
                  text: " dan ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: "Kebijakan Privasi",
                  style: TextStyle(color: Color(0xFF4285F4)),
                ),
                const TextSpan(
                  text: " kami.",
                  style: TextStyle(color: Colors.grey),
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
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXxmV4fOtZv4zZN6UdOlKXR42_Hw-jVnvLDtJNjdDJiHN_YggBb7P42UzkJrZ5VMbLCz0&usqp=CAU",
                  height: 100,
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
                        // ignore: deprecated_member_use
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
