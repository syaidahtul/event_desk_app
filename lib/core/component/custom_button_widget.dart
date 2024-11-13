import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final IconData? icon;
  final Function() onPressed;
  final String? tooltip;
  final String? btnName;

  const CustomButtonWidget({
    super.key,
    this.icon,
    required this.onPressed,
    this.tooltip,
    this.btnName,
  });

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: onPressed,
            child: Text(
              btnName ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          )
        : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              iconColor: Colors.white70,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(
              btnName ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          );
  }
}
