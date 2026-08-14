import 'package:car_care_plus/features/booking/data/models/booking_quote_request_body.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingQuoteRequestBody', () {
    test('scheduled bookings send booking_type as scheduled value and include scheduled_at', () {
      final formData = BookingQuoteRequestBody(
        carIds: [11],
        serviceId: 9,
        bookingType: true,
        paymentMethod: 'cash',
        scheduledAt: '20-10-2026 10:00:00',
        locationLat: 24.7136,
        locationLng: 46.6753,
        isVip: 1,
        branchId: 1,
      ).toFormData();

      expect(formData.fields, contains(
        isA<MapEntry<String, String>>().having((e) => e.key, 'key', 'booking_type'),
      ));

      final bookingTypeEntry = formData.fields.firstWhere(
        (entry) => entry.key == 'booking_type',
      );
      expect(bookingTypeEntry.value, '0');

      final scheduledAtEntry = formData.fields.firstWhere(
        (entry) => entry.key == 'scheduled_at',
      );
      expect(scheduledAtEntry.value, '20-10-2026 10:00:00');
    });

    test('immediate bookings do not send scheduled_at', () {
      final formData = BookingQuoteRequestBody(
        carIds: [11],
        serviceId: 9,
        bookingType: false,
        paymentMethod: 'cash',
        scheduledAt: '20-10-2026 10:00:00',
        locationLat: 24.7136,
        locationLng: 46.6753,
        isVip: 1,
        branchId: 1,
      ).toFormData();

      final bookingTypeEntry = formData.fields.firstWhere(
        (entry) => entry.key == 'booking_type',
      );
      expect(bookingTypeEntry.value, '1');
      expect(formData.fields.any((entry) => entry.key == 'scheduled_at'), isFalse);
    });
  });
}
