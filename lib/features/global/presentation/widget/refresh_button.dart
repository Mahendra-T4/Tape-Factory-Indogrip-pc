import 'package:flutter/material.dart';
import 'package:indogrip/core/theme/color_conts.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key, required void Function()? onPressed})
    : _onPressed = onPressed;
  final void Function()? _onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style:
          ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: kButtonColor,
            minimumSize: Size(MediaQuery.sizeOf(context).width * .23, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (states.contains(MaterialState.focused)) {
                return Colors.white.withOpacity(0.2);
              }
              return null;
            }),
          ),
      onPressed: _onPressed,
      label: Text(
        'Refresh',
        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
      ),
      icon: Icon(Icons.refresh, size: 25),
    );
  }
}
