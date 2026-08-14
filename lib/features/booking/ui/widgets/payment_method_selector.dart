import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('طريقة الدفع', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedMethod,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'cash', child: Text('نقداً (Cash)')),
            DropdownMenuItem(value: 'card', child: Text('بطاقة إلكترونية (Card)')),
            DropdownMenuItem(value: 'wallet', child: Text('المحفظة (Wallet)')),
          ],
          onChanged: (val) => onMethodChanged(val!),
        ),
      ],
    );
  }
}