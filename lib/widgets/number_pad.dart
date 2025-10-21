import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspace;
  final VoidCallback onReset;

  const NumberPad({
    super.key,
    required this.onNumberPressed,
    required this.onBackspace,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(context, ['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(context, ['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(context, ['7', '8', '9']),
        const SizedBox(height: 16),
        _buildRow(context, ['reset', '0', 'backspace']),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        return _buildButton(context, number);
      }).toList(),
    );
  }

  Widget _buildButton(BuildContext context, String value) {
    final isBackspace = value == 'backspace';
    final isReset = value == 'reset';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isBackspace) {
            onBackspace();
          } else if (isReset) {
            onReset();
          } else {
            onNumberPressed(value);
          }
        },
        customBorder: const CircleBorder(),
        splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF2b2d30), // number pad color
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isBackspace
                ? Icon(
                    Icons.backspace_outlined,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : isReset
                    ? Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF5F5F5),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
