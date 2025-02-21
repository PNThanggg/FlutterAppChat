// import 'package:flutter/material.dart';
// import 'package:ntp/ntp.dart';
//
// class NTPWrappedWidget extends StatelessWidget {
//   const NTPWrappedWidget({
//     super.key,
//     required this.child,
//   });
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: NTP.getNtpOffset(),
//         builder: (context, AsyncSnapshot<int> snapshot) {
//           if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//             if (snapshot.data! > const Duration(minutes: 1).inMilliseconds ||
//                 snapshot.data! < -const Duration(minutes: 1).inMilliseconds) {
//               return const Material(
//                 color: Colors.white,
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 24.0),
//                     child: Text(
//                       "Your device clock time is out of sync with the server time. Please set it right to continue.",
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }
//           }
//           return child;
//         });
//   }
// }
