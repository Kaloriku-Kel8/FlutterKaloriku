import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'userdatainput.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool isRegistered = false; // Status apakah pengguna sudah mendaftar

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.green[100], // Mengubah warna latar belakang dialog
            primaryColor: Colors.green, // Warna utama yang memengaruhi elemen lain seperti teks
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // Mengubah warna teks tombol
              ),
            ),
          ),
          child: AlertDialog(
            title: const Text('Pemberitahuan'),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _register(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      _showDialog(context, 'Silahkan isi terlebih dahulu');
    } else {
      // Simulasi pendaftaran
      _showDialog(context, 'Pendaftaran berhasil');
      setState(() {
        isRegistered = true; // Set status menjadi terdaftar
      });
    }
  } // <--- Tambahkan tanda kurung tutup yang hilang di sini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)), // Mengatur warna ikon jika diinginkan
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text('Register'),
        titleTextStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: Color(0xFF61CA3D),
          fontWeight: FontWeight.w100,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: 0.9,
                child: SvgPicture.asset(
                  'assets/images/Frame 13.svg', // Ganti dengan path gambar Anda
                  width: MediaQuery.of(context).size.width * 3.0,
                  height: MediaQuery.of(context).size.width * 3.0,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // Untuk Email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan Email',
                      floatingLabelStyle: const TextStyle(color: Colors.black54),
                      fillColor: const Color(0xFFFFFFFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
                      ),
                    ),
                    cursorColor: const Color(0xFF61CA3D),
                  ),

                  const SizedBox(height: 15),

                  // Untuk Username
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan Username',
                      floatingLabelStyle: const TextStyle(color: Colors.black54),
                      fillColor: const Color(0xFFFFFFFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
                      ),
                    ),
                    cursorColor: const Color(0xFF61CA3D),
                  ),

                  const SizedBox(height: 15),

                  // Untuk Password
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan Password',
                      floatingLabelStyle: const TextStyle(color: Colors.black38),
                      fillColor: const Color(0xFFFFFFFF),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF61CA3D), width: 2),
                      ),
                    ),
                    cursorColor: const Color(0xFF61CA3D),
                    obscureText: true,
                  ),

                  const SizedBox(height: 50),

                  // Tombol Sign Up ditampilkan hanya jika user belum terdaftar
                  if (!isRegistered)
                    ElevatedButton(
                      onPressed: () {
                        _register(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ).copyWith(
                        minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF61CA3D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Tombol Lanjut jika isRegistered true
                  if (isRegistered)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Atur posisi tombol
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF61CA3D),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfileInputScreen()),
                            );
                          },
                          child: const Text(
                            "Lanjut",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
