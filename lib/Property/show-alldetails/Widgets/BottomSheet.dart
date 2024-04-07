// import "package:flutter/material.dart";
// import "package:google_fonts/google_fonts.dart";
// import "package:onpensea/Property/show-alldetails/Widgets/Countdown.dart";
//
// class BottomSheetWidget extends StatefulWidget {
//   const BottomSheetWidget({super.key});
//
//   @override
//   State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
// }
//
// class _BottomSheetWidgetState extends State<BottomSheetWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     Countdown()),
//           );
//           // showModalBottomSheet(
//           //     context: context,
//           //     builder: (BuildContext context) {
//           //       return SizedBox(
//           //         height: 1000,
//           //         child: SingleChildScrollView(
//           //           child: Center(
//           //             child: Padding(
//           //               padding: const EdgeInsets.all(16.0),
//           //               child: Column(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 mainAxisAlignment: MainAxisAlignment.center,
//           //                 children: [
//           //
//           //                   // Text(
//           //                   //   "Instructions:",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // Text(
//           //                   //   "1. Copy the private address.",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // Text(
//           //                   //   "2. Open the metamask wallet app in you mobile.",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // Text(
//           //                   //   "3. Select the property which you want to sell.",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // Text(
//           //                   //   "4. Click on send and paste the private address.",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // Text(
//           //                   //   "5. Enter the total tokens you want to sell and click sell.",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // Text(
//           //                   //   "6. Upon Successfull token transfer take the screenshot and redirect back to the o3 application.",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // Text(
//           //                   //   "7. Press close button and continue to the next screen.",
//           //                   //   style: GoogleFonts.poppins(
//           //                   //     textStyle:
//           //                   //         Theme.of(context).textTheme.headlineMedium,
//           //                   //     fontSize: 16,
//           //                   //     color: Colors.black54,
//           //                   //     fontWeight: FontWeight.w500,
//           //                   //     fontStyle: FontStyle.normal,
//           //                   //   ),
//           //                   // ),
//           //                   // const SizedBox(
//           //                   //   height: 10,
//           //                   // ),
//           //                   // ElevatedButton(
//           //                   //     onPressed: () {
//           //                   //       Navigator.pop(context);
//           //                   //     },
//           //                   //     child: const Text("close"))
//           //                 ],
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //       );
//           //     });
//         },
//         child: const Text('Transfer tokens'),
//       ),
//     );
//   }
// }
