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
    this.pageText,
  });
  final void Function()? onFirstPressed;
  final void Function()? onPreviousPressed;
  final void Function(int pageNumber)? onPagePressed;
  final void Function()? onNextPressed;
  final void Function()? onLastPressed;
  final int? currentPage;
  final int? pageQty;
  final String? pageText;

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

  List<Widget> _buildPageButtons() {
    final int totalPages = widget.pageQty ?? 1;
    final int currentPage = widget.currentPage ?? 1;

    if (totalPages <= 10) {
      // If total pages are 10 or less, show all pages
      return List.generate(totalPages, (index) => _buildPageButton(index + 1));
    }

    // Google-style pagination: show exactly 10 page numbers when total > 10
    List<Widget> pageButtons = [];
    const int maxVisiblePages = 10;

    // Calculate start and end page numbers to show exactly 10 pages
    int startPage = (currentPage - (maxVisiblePages ~/ 2)).clamp(
      1,
      totalPages - maxVisiblePages + 1,
    );
    int endPage = startPage + maxVisiblePages - 1;

    // Ensure we don't go beyond total pages
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = (totalPages - maxVisiblePages + 1).clamp(1, totalPages);
    }

    // Always show first page if not in range
    if (startPage > 1) {
      pageButtons.add(_buildPageButton(1));
      if (startPage > 2) {
        pageButtons.add(_buildEllipsis());
      }
    }

    // Show exactly 10 pages in the middle section
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_buildPageButton(i));
    }

    // Always show last page if not in range
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(_buildEllipsis());
      }
      pageButtons.add(_buildPageButton(totalPages));
    }

    return pageButtons;
  }

  Widget _buildPageButton(int pageNumber) {
    return SizedBox(
      width: 40,
      child: TextButton(
        onPressed: () {
          widget.onPagePressed?.call(pageNumber);
          log('Page Number: $pageNumber');
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.blue.withOpacity(0.1);
            }
            return Colors.transparent;
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (widget.currentPage == pageNumber) {
              return Colors.blue.withOpacity(0.2);
            }
            return Colors.transparent;
          }),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 8),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        child: Text(
          '$pageNumber',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: widget.currentPage == pageNumber ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        width: 40,
        child: Center(
          child: Text(
            '...',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              widget.pageText.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'TrajanPro',
                // height: 4,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
        SizedBox(width: MediaQuery.sizeOf(context).width * 0.07),
        Container(
          height: 40,
          // width: 300,
          // width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.symmetric(horizontal: 5),
          margin: EdgeInsets.only(
            left: Responsive.kHZRowPaddingTB + 10,
            bottom: Responsive.kHZRowPaddingTB,
            right: Responsive.kHZRowPaddingTB,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFeeeeee),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                _scrollController.jumpTo(
                  (_scrollController.offset + pointerSignal.scrollDelta.dy)
                      .clamp(0.0, _scrollController.position.maxScrollExtent),
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

                ..._buildPageButtons(),
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
        ),
      ],
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
