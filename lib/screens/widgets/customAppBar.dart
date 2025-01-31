import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading ??
              const SizedBox
                  .shrink(), // Default to an empty widget if leading is null
          title ??
              const SizedBox
                  .shrink(), // Default to an empty widget if title is null
          trailing ??
              const SizedBox
                  .shrink(), // Default to an empty widget if trailing is null
        ],
      ),
    );
  }
}
