import 'package:car_care_plus/features/branches/data/models/branch_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _branch({
  dynamic latitude = '24.4709000',
  dynamic longitude = '39.6112000',
  dynamic workingHours = const {'start': '08:00', 'end': '23:00'},
  bool isActive = true,
  bool is24h = false,
  String nameAr = 'فرع المدينة المنورة',
}) {
  return {
    'id': 3,
    'admin_id': 4,
    'manager': {
      'id': 4,
      'name': 'Sami Al-Ahmad',
      'email': 'sami@example.com',
      'phone': '0512345678',
    },
    'name': 'Madinah Branch',
    'name_ar': nameAr,
    'city': 'Madinah',
    'address': 'طريق قباء، قباء',
    'latitude': latitude,
    'longitude': longitude,
    'phone': '0515555555',
    'is_active': isActive,
    'working_hours': workingHours,
    'is_24h': is24h,
  };
}

void main() {
  group('الإحداثيات النصية', () {
    test('تُقرأ كأرقام لأنها تصل كنصوص من الباك اند', () {
      final branch = BranchModel.fromJson(_branch());

      expect(branch.latitude, 24.4709);
      expect(branch.longitude, 39.6112);
      expect(branch.hasCoordinates, isTrue);
    });

    test('الإحداثيات الفارغة لا ترمي ولا تجعل الفرع قابلاً للاختيار', () {
      final branch = BranchModel.fromJson(
        _branch(latitude: null, longitude: null),
      );

      expect(branch.latitude, isNull);
      expect(branch.hasCoordinates, isFalse);
      // فرع بلا إحداثيات لا يُختار تلقائياً كأقرب فرع
      expect(branch.isSelectable, isFalse);
    });

    test('الفرع غير الفعّال ليس قابلاً للاختيار حتى مع وجود إحداثيات', () {
      final branch = BranchModel.fromJson(_branch(isActive: false));

      expect(branch.hasCoordinates, isTrue);
      expect(branch.isSelectable, isFalse);
    });
  });

  group('حساب المسافة', () {
    test('نفس النقطة تعطي صفراً', () {
      final branch = BranchModel.fromJson(_branch());
      expect(branch.distanceKmFrom(24.4709, 39.6112), 0.0);
    });

    test('درجة عرض واحدة تساوي 111.19 كم بنصف قطر 6371', () {
      // نفس معادلة الباك اند: Haversine بنصف قطر 6371 كم مقرّبة لخانتين
      final branch = BranchModel.fromJson(
        _branch(latitude: '25.4709000', longitude: '39.6112000'),
      );

      expect(branch.distanceKmFrom(24.4709, 39.6112), 111.19);
    });

    test('تعيد null بلا موقع مستخدم أو بلا إحداثيات فرع', () {
      final withCoords = BranchModel.fromJson(_branch());
      final withoutCoords = BranchModel.fromJson(
        _branch(latitude: null, longitude: null),
      );

      expect(withCoords.distanceKmFrom(null, null), isNull);
      expect(withoutCoords.distanceKmFrom(24.4709, 39.6112), isNull);
    });
  });

  group('ساعات العمل الحرّة', () {
    test('تقرأ شكل start/end المستخدم في الـ seeder', () {
      final branch = BranchModel.fromJson(_branch());
      expect(branch.formattedWorkingHours, '08:00 - 23:00');
    });

    test('تقرأ شكل الأيام المستخدم في الـ factory', () {
      final branch = BranchModel.fromJson(
        _branch(workingHours: {'mon': '08:00-20:00', 'tue': '08:00-20:00'}),
      );

      expect(branch.formattedWorkingHours, contains('mon: 08:00-20:00'));
      expect(branch.formattedWorkingHours, contains('tue: 08:00-20:00'));
    });

    test('أي شكل غير معروف يعيد null بدل أن يكسر الواجهة', () {
      expect(
        BranchModel.fromJson(_branch(workingHours: null)).formattedWorkingHours,
        isNull,
      );
      expect(
        BranchModel.fromJson(
          _branch(workingHours: 'مفتوح دائماً'),
        ).formattedWorkingHours,
        isNull,
      );
      expect(
        BranchModel.fromJson(
          _branch(workingHours: const {'start': 8, 'end': 23}),
        ).formattedWorkingHours,
        isNull,
      );
    });
  });

  group('الاسم المعروض', () {
    test('يفضّل الاسم العربي', () {
      final branch = BranchModel.fromJson(_branch());
      expect(branch.displayName, 'فرع المدينة المنورة');
    });

    test('يعود للاسم الإنجليزي إذا كان العربي فارغاً', () {
      final branch = BranchModel.fromJson(_branch(nameAr: ''));
      expect(branch.displayName, 'Madinah Branch');
    });
  });

  group('المغلّف والترقيم', () {
    test('يقرأ القائمة والترقيم من المفتاح المجاور', () {
      final response = BranchesResponseModel.fromJson({
        'status': 1,
        'data': [_branch(), _branch(isActive: false)],
        'message': 'branches fetched successfully',
        'pagination': {
          'current_page': 1,
          'per_page': 15,
          'total': 8,
          'last_page': 1,
        },
      });

      expect(response.data, hasLength(2));
      expect(response.pagination!.hasNextPage, isFalse);
      // الفروع غير الفعّالة تصل من السيرفر ويجب تصفيتها في العميل
      expect(response.data.where((b) => b.isActive), hasLength(1));
    });

    test('استجابة بلا ترقيم أو بلا بيانات لا ترمي', () {
      final response = BranchesResponseModel.fromJson({'status': 1});

      expect(response.data, isEmpty);
      expect(response.pagination, isNull);
    });
  });
}
