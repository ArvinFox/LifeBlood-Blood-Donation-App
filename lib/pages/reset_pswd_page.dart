// import 'package:flutter/material.dart';
// import '../widgets/custom_container.dart';
// import '../widgets/login_button.dart';

// class ResetPasswordPage extends StatefulWidget {
//   const ResetPasswordPage({super.key});

//   @override
//   State<ResetPasswordPage> createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   final TextEditingController _oldPasswordController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _verifyPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomContainer(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Forgot Password',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Image.asset('assets/images/reset_pswd.png', height: 240),
//             SizedBox(height: 20),
//             Text(
//               'Enter your new password below.',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Old Password',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _oldPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Enter your old password',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'New Password',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _newPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Enter your new password',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Verify Password',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _verifyPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Re-enter your new password',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             LoginButton(
//               text: 'Reset Password',
//               onPressed: () {
//                 // Reset password button press
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
