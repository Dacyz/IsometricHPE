import 'package:app_position/core/const.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Widget child;

  CustomElevatedButton({super.key, this.onPressed, required this.title, final IconData? icon})
      : child = icon == null
            ? ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.disabled) ? Colors.grey : AppConstants.colors.primary,
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              )
            : ElevatedButton.icon(
                icon: Icon(icon, color: Colors.white),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.disabled) ? Colors.grey : AppConstants.colors.primary,
                  ),
                ),
                onPressed: onPressed,
                label: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              );

  CustomElevatedButton.outlined({super.key, this.onPressed, required this.title, final IconData? icon})
      : child = icon == null
            ? ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), side: BorderSide(color: AppConstants.colors.primary)),
                  ),
                  overlayColor: const MaterialStatePropertyAll<Color>(Color(0x12000000)),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent,
                  ),
                  shadowColor: const MaterialStatePropertyAll(Colors.transparent),
                ),
                onPressed: onPressed,
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppConstants.colors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              )
            : ElevatedButton.icon(
                icon: Icon(icon, color: AppConstants.colors.primary),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  overlayColor: const MaterialStatePropertyAll<Color>(Color(0x00000000)),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.disabled) ? Colors.grey : AppConstants.colors.primary,
                  ),
                ),
                onPressed: onPressed,
                label: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
