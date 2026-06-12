import 'package:flutter/material.dart';

class BookingServiceCard extends StatelessWidget {
  const BookingServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(height: 80, alignment: Alignment.center, child: const Text('Booking Service Card')),
    );
  }
}
