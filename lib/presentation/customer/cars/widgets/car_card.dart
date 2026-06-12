import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(height: 80, alignment: Alignment.center, child: const Text('Car Card')),
    );
  }
}
