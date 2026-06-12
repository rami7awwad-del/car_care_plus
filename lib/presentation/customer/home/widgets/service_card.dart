import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(height: 80, alignment: Alignment.center, child: const Text('Service Card')),
    );
  }
}
