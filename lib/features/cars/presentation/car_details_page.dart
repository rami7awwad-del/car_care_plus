import 'package:flutter/material.dart';
import 'package:car_care_plus/core/network/dio_factory.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:car_care_plus/core/widgets/gradient_header.dart';
import 'package:car_care_plus/features/cars/data/car_model.dart';
import 'package:car_care_plus/features/cars/data/cars_remote_data_source.dart';
import 'package:car_care_plus/features/cars/data/cars_repository_impl.dart';

class CarDetailsPage extends StatefulWidget {
  final Car car;

  const CarDetailsPage({super.key, required this.car});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late final CarsRepositoryImpl _repository;
  late Car _car;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _car = widget.car;
    _repository = CarsRepositoryImpl(
      remoteDataSource: CarsRemoteDataSourceImpl(dio: createDio()),
    );
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final result = await _repository.getCarDetails(widget.car.id);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (car) => setState(() {
        _car = car;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueSurface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientHeader(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.surfaceWhite,
                    ),
                  ),
                ),
                _HeaderImage(imageUrl: _car.imageUrl),
                const SizedBox(height: 14),
                Text(
                  _car.model ?? 'سيارة',
                  style: TextStyles.Size24
                      .withColor(AppColors.surfaceWhite)
                      .withWeight(FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _car.plateNumber ?? '—',
                  style: TextStyles.Size15.withColor(
                    AppColors.surfaceWhite.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'تفاصيل السيارة',
                        style: TextStyles.Size18
                            .withColor(AppColors.darkBlueBlack)
                            .withWeight(FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      if (_loading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _DetailsCard(
                    rows: [
                      _DetailRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'رقم اللوحة',
                        value: _car.plateNumber,
                      ),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'سنة الصنع',
                        value: _car.year?.toString(),
                      ),
                      _DetailRow(
                        icon: Icons.palette_outlined,
                        label: 'اللون',
                        value: _car.color,
                      ),
                      _DetailRow(
                        icon: Icons.local_gas_station_outlined,
                        label: 'نوع الوقود',
                        value: _car.fuelType?.labelAr,
                      ),
                      _DetailRow(
                        icon: Icons.settings_outlined,
                        label: 'عدد الأسطوانات',
                        value: _car.cylinders?.toString(),
                      ),
                      _DetailRow(
                        icon: Icons.speed_outlined,
                        label: 'المسافة المقطوعة',
                        value: _car.mileage != null ? '${_car.mileage} كم' : null,
                      ),
                      _DetailRow(
                        icon: Icons.category_outlined,
                        label: 'نوع السيارة',
                        value: _car.carType?.nameAr ?? _car.carType?.name,
                      ),
                      _DetailRow(
                        icon: Icons.store_mall_directory_outlined,
                        label: 'الفرع',
                        value: _car.branch?.nameAr ?? _car.branch?.name,
                        isLast: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  final String? imageUrl;

  const _HeaderImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 120,
        height: 120,
        color: AppColors.surfaceWhite.withOpacity(0.12),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _HeaderImageFallback(),
              )
            : const _HeaderImageFallback(),
      ),
    );
  }
}

class _HeaderImageFallback extends StatelessWidget {
  const _HeaderImageFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.directions_car_filled_rounded,
        color: AppColors.surfaceWhite,
        size: 56,
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final List<Widget> rows;

  const _DetailsCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBlueBlack.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: rows),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 22),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyles.Size15.withColor(AppColors.coolGrey),
              ),
              const Spacer(),
              Text(
                value == null || value!.isEmpty ? '—' : value!,
                style: TextStyles.Size15
                    .withColor(AppColors.darkBlueBlack)
                    .withWeight(FontWeight.w600),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: AppColors.borderGrey),
      ],
    );
  }
}
