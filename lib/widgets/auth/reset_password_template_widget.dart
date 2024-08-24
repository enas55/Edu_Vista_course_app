// import 'package:edu_vista_final_project/widgets/app_elevated_button.dart';
// import 'package:flutter/material.dart';

// class ResetPasswordTemplateWidget extends StatefulWidget {
//   ResetPasswordTemplateWidget({
//     super.key,
    
//   }) 

//   @override
//   State<ResetPasswordTemplateWidget> createState() =>
//       _ResetPasswordTemplateWidgetState();
// }

// class _ResetPasswordTemplateWidgetState
//     extends State<ResetPasswordTemplateWidget> {

//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 const Text(
//                   'Reset Password',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                 ),
//                 const SizedBox(
//                   height: 100,
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: AppElevatedButton(
//                     child: _isLoading
//                         ? const CircularProgressIndicator(
//                             color: Colors.white,
//                           )
//                         : const Text('Submit'),
//                     onPressed: () async {
                      
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
