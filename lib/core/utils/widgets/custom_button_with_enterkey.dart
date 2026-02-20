// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:indogrip/core/theme/color_conts.dart';

class CustomEnterKeyButton extends StatefulWidget {
  const CustomEnterKeyButton({
    Key? key,

    required this.label,
    required this.onPressed,
  }) : super(key: key);
  final String label;

  final VoidCallback onPressed;

  @override
  State<CustomEnterKeyButton> createState() => _CustomEnterKeyButtonState();
}

class _CustomEnterKeyButtonState extends State<CustomEnterKeyButton> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): widget.onPressed,
        const SingleActivator(LogicalKeyboardKey.numpadEnter): widget.onPressed,
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: ElevatedButton(
            focusNode: _focusNode,
            onPressed: widget.onPressed,
            style:
                ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: kButtonColor,
                  minimumSize: const Size(470, 60),
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
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
