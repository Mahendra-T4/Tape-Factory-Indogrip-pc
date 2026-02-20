import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:indogrip/core/responsive/responsive.dart';

class TableBottomWidget extends StatefulWidget {
  TableBottomWidget({
    super.key,
    this.onFirstPressed,
    this.onPreviousPressed,
    this.onPagePressed,
    this.onNextPressed,
    this.onLastPressed,
    this.currentPage,
    this.pageQty,
  });
  final void Function()? onFirstPressed;
  final void Function()? onPreviousPressed;
  final void Function(int pageNumber)? onPagePressed;
  final void Function()? onNextPressed;
  final void Function()? onLastPressed;
  final int? currentPage;
  final int? pageQty;

  @override
  State<TableBottomWidget> createState() => _TableBottomWidgetState();
}

class _TableBottomWidgetState extends State<TableBottomWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      // width: 300,
      // width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: Responsive.kHZRowPaddingTB - 5,
      ),
      margin: EdgeInsets.only(
        left: Responsive.kHZRowPaddingTB + 10,
        bottom: Responsive.kHZRowPaddingTB,
        right: Responsive.kHZRowPaddingTB,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Listener(
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            _scrollController.jumpTo(
              (_scrollController.offset + pointerSignal.scrollDelta.dy).clamp(
                0.0,
                _scrollController.position.maxScrollExtent,
              ),
            );
          }
        },
        child: ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            TextButton(
              onPressed: widget.onFirstPressed,
              style: buttonStyle,
              child: Text(
                'First',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),
            TextButton(
              onPressed: widget.onPreviousPressed,
              style: buttonStyle,
              child: Text(
                'Previous',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),

            ...List.generate(
              widget.pageQty != null ? widget.pageQty! : 1,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SizedBox(
                  width: 40,
                  child: TextButton(
                    onPressed: () {
                      int pageNumber = index + 1;
                      widget.onPagePressed?.call(pageNumber);
                      log('Page Number: $pageNumber');
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.blue.withOpacity(0.1);
                        }
                        return Colors.transparent;
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (widget.currentPage == index + 1) {
                            return Colors.blue.withOpacity(0.2);
                          }
                          return Colors.transparent;
                        },
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 8),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: widget.currentPage == index + 1
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),
            TextButton(
              onPressed: widget.onNextPressed,
              style: buttonStyle,
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
            const VerticalDivider(color: Colors.grey, thickness: 1),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.07,
              child: TextButton(
                onPressed: widget.onLastPressed,
                style: buttonStyle,
                child: Text(
                  'Last',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle get buttonStyle => ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.hovered)) {
        return Colors.blue.withOpacity(0.1);
      }
      return Colors.transparent;
    }),
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );
}
