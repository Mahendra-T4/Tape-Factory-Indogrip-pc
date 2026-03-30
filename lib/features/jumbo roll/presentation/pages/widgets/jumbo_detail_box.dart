import 'package:flutter/material.dart';
import 'package:indogrip/core/theme/color_conts.dart';
import 'package:indogrip/core/utils/widgets/text_field.dart';

class JumboDetailBox extends StatelessWidget {
  const JumboDetailBox({
    super.key,
    required this.availableJumbo,
    required this.availableLength,
  });
  final String availableJumbo;
  final String availableLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
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
                  'Available Jumbo Rolls',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Container(
                  height: 35,
                  width: MediaQuery.sizeOf(context).width / 7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      availableJumbo,
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
            padding: const EdgeInsets.all(10.0),
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
                  'Available Length',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Container(
                  height: 35,
                  width: MediaQuery.sizeOf(context).width / 7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      availableLength,
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
