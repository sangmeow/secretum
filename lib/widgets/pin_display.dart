import 'package:flutter/material.dart';

class PinDisplay extends StatelessWidget {
  final int pinLength;
  final int currentLength;
  final bool isError;

  const PinDisplay({
    super.key,
    required this.pinLength,
    required this.currentLength,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pinLength,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getColor(context, index),
              border: Border.all(
                color: _getBorderColor(context, index),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(BuildContext context, int index) {
    if (isError) {
      return index < currentLength
          ? Colors.red.withValues(alpha: 0.3)
          : Colors.transparent;
    }

    return index < currentLength
        ? Theme.of(context).colorScheme.primary
        : Colors.transparent;
  }

  Color _getBorderColor(BuildContext context, int index) {
    if (isError) {
      return Colors.red;
    }

    if (index < currentLength) {
      return Theme.of(context).colorScheme.primary;
    }

    return Colors.grey[700]!;
  }
}
