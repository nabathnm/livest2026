// import 'package:flutter/material.dart';
// import 'package:livest/features/auth/pages/otp_page.dart';
// import 'package:livest/features/auth/services/auth_service.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _authService = AuthService();
//   final _phone = TextEditingController();

//   @override
//   void dispose() {
//     _phone.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: _phone,
//               decoration: InputDecoration(label: Text("Phone")),
//             ),
//             Text(""),
//             ElevatedButton(
//               onPressed: () {
//                 final phone = _phone.text.trim();
//                 if (phone.isEmpty) return;

//                 _authService.register(_phone.text);

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => OtpPage()),
//                 );
//               },
//               child: Text("Next"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
