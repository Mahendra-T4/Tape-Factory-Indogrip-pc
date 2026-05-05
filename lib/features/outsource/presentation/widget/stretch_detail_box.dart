import 'package:flutter/material.dart';
import 'package:indogrip/core/theme/color_conts.dart';

class StretchDetailBox extends StatelessWidget {
  const StretchDetailBox({
    super.key,
    required this.availableCarton,
    // required this.totalPieces,
    required this.totalNetWeight,
    required this.totalGrossWeight,
  });
  final String availableCarton;
  // final String totalPieces;
  final String totalNetWeight;
  final String totalGrossWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            // width: MediaQuery.sizeOf(context).width * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: Colors.grey.withOpacity(.3),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  'Available Carton',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Container(
                  height: 35,
                  width: MediaQuery.sizeOf(context).width / 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      availableCarton,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: kButtonColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //   padding: const EdgeInsets.all(5),
          //   // width: MediaQuery.sizeOf(context).width * 0.2,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(14.0),
          //     color: Colors.grey.withOpacity(.3),
          //   ),

          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     spacing: 10,
          //     children: [
          //       Text(
          //         'Total Weight',
          //         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          //       ),
          //       Container(
          //         height: 35,
          //         width: MediaQuery.sizeOf(context).width / 015,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(8.0),
          //         ),
          //         child: Center(
          //           child: Text(
          //             totalPieces,
          //             style: TextStyle(
          //               fontWeight: FontWeight.w600,
          //               fontSize: 18,
          //               color: kButtonColor,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.all(5),
            // width: MediaQuery.sizeOf(context).width * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: Colors.grey.withOpacity(.3),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  'Total Net Weight',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Container(
                  height: 35,
                  width: MediaQuery.sizeOf(context).width / 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      totalNetWeight,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: kButtonColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(5),
            // width: MediaQuery.sizeOf(context).width * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: Colors.grey.withOpacity(.3),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  'Total Gross Weight',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Container(
                  height: 35,
                  width: MediaQuery.sizeOf(context).width / 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      totalGrossWeight,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: kButtonColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
