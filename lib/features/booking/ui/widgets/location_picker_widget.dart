import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
class LocationPickerWidget extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final Function(double lat, double lng, String? address) onLocationChanged;

  const LocationPickerWidget({
    super.key,
    required this.initialLat,
    required this.initialLng,
    required this.onLocationChanged,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  bool _isAutomatic = true;
  bool _isLoadingLocation = false;
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showSnackBar('خدمة الموقع الجغرافي معطلة على الجهاز', AppColors.warningColor);
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            _showSnackBar('تم رفض إذن الوصول للموقع الجغرافي', AppColors.errorColor);
          }
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          _showSnackBar('إذن الموقع مرفوض دائمًا، يرجى تفعيله من الإعدادات', AppColors.errorColor);
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      widget.onLocationChanged(position.latitude, position.longitude, null);

      if (mounted) {
        _showSnackBar('تم تحديد الموقع الجغرافي بنجاح', AppColors.successColor);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('حدث خطأ أثناء جلب الموقع: $e', AppColors.errorColor);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.Size15.withColor(Colors.white)),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تحديد الموقع الجغرافي',
            style: TextStyles.Size18.withWeight(FontWeight.bold).withColor(AppColors.darkBlueBlack),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Text('تلقائي (موقعي)', style: TextStyles.Size15),
                  selected: _isAutomatic,
                  selectedColor: AppColors.primaryBlue.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: _isAutomatic ? AppColors.primaryBlue : AppColors.coolGrey,
                    fontWeight: _isAutomatic ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    setState(() => _isAutomatic = true);
                    _getCurrentLocation();
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ChoiceChip(
                  label: Text('يدوي (إدخال)', style: TextStyles.Size15),
                  selected: !_isAutomatic,
                  selectedColor: AppColors.primaryBlue.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: !_isAutomatic ? AppColors.primaryBlue : AppColors.coolGrey,
                    fontWeight: !_isAutomatic ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    setState(() => _isAutomatic = false);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (_isAutomatic) ...[
            OutlinedButton.icon(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 48.h),
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              icon: _isLoadingLocation
                  ? SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlue),
                    )
                  : Icon(Icons.my_location_rounded, color: AppColors.primaryBlue, size: 20.r),
              label: Text(
                _isLoadingLocation ? 'جاري تحديد الموقع...' : 'إعادة تحديد الموقع الحالي',
                style: TextStyles.Size15.withWeight(FontWeight.w600).withColor(AppColors.primaryBlue),
              ),
            ),
          ] else ...[
            TextField(
              controller: _addressController,
              style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
              decoration: InputDecoration(
                labelText: 'العنوان التفصيلي',
                labelStyle: TextStyles.Size15.withColor(AppColors.coolGrey),
                hintText: 'مثال: الرياض - حي الملقا - شارع الملك فهد',
                prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.primaryBlue, size: 20.r),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              onChanged: (text) {
                widget.onLocationChanged(
                  widget.initialLat,
                  widget.initialLng,
                  text.isNotEmpty ? text : null,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}