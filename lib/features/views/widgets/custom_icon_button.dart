import 'package:app_position/core/const.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
    this.icon, {
    super.key,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.color,
  });
  final void Function()? onTap;
  final IconData icon;
  final Color? backgroundColor;
  final Color? color;
  final BoxBorder? border;

  factory CustomIconButton.outlined(
    IconData icon, {
    Color? backgroundColor,
    required void Function() onTap,
    BoxBorder? border,
  }) {
    return CustomIconButton(
      icon,
      onTap: onTap,
      backgroundColor: backgroundColor ?? Colors.transparent,
      border: border ?? Border.all(color: AppConstants.colors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      highlightShape: BoxShape.circle,
      highlightColor: null,
      splashFactory: null,
      radius: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
          color: backgroundColor ?? AppConstants.colors.disabled,
        ),
        child: Icon(
          icon,
          color: color ?? AppConstants.colors.primary,
        ),
      ),
    );
  }
}
