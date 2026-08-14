import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import '../../logic/cars_cubit.dart';
import '../../logic/cars_state.dart';

class AddCarView extends StatefulWidget {
  const AddCarView({super.key});

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _cylindersController = TextEditingController();

  String _selectedFuelType = 'petrol';
  int? _selectedBrandId;
  int? _selectedCarTypeId;

  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // جلب البراندات والتايبس فور فتح الشاشة
    context.read<CarsCubit>().fetchBrandsAndTypes();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اختر مصدر الصورة',
              style: TextStyles.Size18
                  .withWeight(FontWeight.bold)
                  .withColor(AppColors.darkBlueBlack),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.primaryBlue),
              title: Text('المعرض', style: TextStyles.Size15.withColor(AppColors.darkBlueBlack)),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryBlue),
              title: Text('الكاميرا', style: TextStyles.Size15.withColor(AppColors.darkBlueBlack)),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _modelController.dispose();
    _plateController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _mileageController.dispose();
    _cylindersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surfaceWhite,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'إضافة مركبة جديدة',
          style: TextStyles.Size18
              .withWeight(FontWeight.bold)
              .withColor(AppColors.darkBlueBlack),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CarsCubit, CarsState>(
        listener: (context, state) {
          if (state is AddCarSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تمت إضافة السيارة بنجاح',
                  style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
                ),
                backgroundColor: AppColors.successColor,
              ),
            );
            context.read<CarsCubit>().getUserCars();
            Navigator.pop(context);
          } else if (state is CarsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
                ),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CarsCubit>();
          final isLoading = state is AddCarLoadingState;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. التقاط/اختيار صورة السيارة
                    Center(
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: 140.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.lightBlueSurface,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.primaryBlue.withOpacity(0.3),
                                  width: 1.5.w,
                                ),
                                image: _selectedImage != null
                                    ? DecorationImage(
                                        image: FileImage(File(_selectedImage!.path)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _selectedImage == null
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 40.sp,
                                          color: AppColors.primaryBlue,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'إضافة صورة السيارة',
                                          style: TextStyles.Size15
                                              .withWeight(FontWeight.w600)
                                              .withColor(AppColors.primaryBlue),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                            if (_selectedImage != null)
                              Padding(
                                padding: EdgeInsets.all(8.r),
                                child: Container(
                                  padding: EdgeInsets.all(6.r),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16.sp,
                                    color: AppColors.surfaceWhite,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // 2. قائمة الماركات (Car Brands)
                    Text(
                      'ماركة السيارة (Brand)',
                      style: TextStyles.Size15
                          .withWeight(FontWeight.bold)
                          .withColor(AppColors.darkBlueBlack),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<int>(
                      value: _selectedBrandId,
                      hint: Text(
                        'اختر ماركة السيارة',
                        style: TextStyles.Size15.withColor(AppColors.coolGrey),
                      ),
                      decoration: _getInputDecoration(Icons.branding_watermark_outlined),
                      items: cubit.carBrands.map((brand) {
                        return DropdownMenuItem<int>(
                          value: brand['id'] as int,
                          child: Text(
                            brand['name']?.toString() ?? '',
                            style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                          ),
                        );
                      }).toList(),
                      validator: (val) => val == null ? 'يرجى اختيار ماركة السيارة' : null,
                      onChanged: (val) {
                        setState(() => _selectedBrandId = val);
                      },
                    ),
                    SizedBox(height: 16.h),

                    // 3. قائمة أنواع السيارات (Car Types)
                    Text(
                      'نوع السيارة (Car Type)',
                      style: TextStyles.Size15
                          .withWeight(FontWeight.bold)
                          .withColor(AppColors.darkBlueBlack),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<int>(
                      value: _selectedCarTypeId,
                      hint: Text(
                        'اختر نوع السيارة',
                        style: TextStyles.Size15.withColor(AppColors.coolGrey),
                      ),
                      decoration: _getInputDecoration(Icons.category_outlined),
                      items: cubit.carTypes.map((type) {
                        return DropdownMenuItem<int>(
                          value: type.id as int,
                          child: Text(
                            type.nameAr?.toString().isNotEmpty == true
                                ? type.nameAr.toString()
                                : type.name.toString(),
                            style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                          ),
                        );
                      }).toList(),
                      validator: (val) => val == null ? 'يرجى اختيار نوع السيارة' : null,
                      onChanged: (val) {
                        setState(() => _selectedCarTypeId = val);
                      },
                    ),
                    SizedBox(height: 16.h),

                    // 4. الموديل ورقم اللوحة
                    _buildTextField(
                      controller: _modelController,
                      label: 'موديل السيارة (مثل: Camry, Land Cruiser)',
                      icon: Icons.directions_car_outlined,
                      validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال الموديل' : null,
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _plateController,
                      label: 'رقم اللوحة (مثل: ABC-1234)',
                      icon: Icons.subtitles_outlined,
                      validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال رقم اللوحة' : null,
                    ),
                    SizedBox(height: 16.h),

                    // 5. سنة الصنع واللون
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _yearController,
                            label: 'سنة الصنع',
                            icon: Icons.calendar_today_outlined,
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildTextField(
                            controller: _colorController,
                            label: 'اللون',
                            icon: Icons.color_lens_outlined,
                            validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // 6. قراءة العداد والسلندرات
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _mileageController,
                            label: 'المسافة (كم)',
                            icon: Icons.speed_outlined,
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildTextField(
                            controller: _cylindersController,
                            label: 'السلندرات',
                            icon: Icons.tune_outlined,
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // 7. نوع الوقود
                    Text(
                      'نوع الوقود',
                      style: TextStyles.Size15
                          .withWeight(FontWeight.bold)
                          .withColor(AppColors.darkBlueBlack),
                    ),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      value: _selectedFuelType,
                      decoration: _getInputDecoration(Icons.local_gas_station_outlined),
                      items: const [
                        DropdownMenuItem(value: 'petrol', child: Text('بنزين (Petrol)')),
                        DropdownMenuItem(value: 'diesel', child: Text('ديزل (Diesel)')),
                        DropdownMenuItem(value: 'hybrid', child: Text('هايبرايد (Hybrid)')),
                        DropdownMenuItem(value: 'electric', child: Text('كهرباء (Electric)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedFuelType = val);
                      },
                    ),
                    SizedBox(height: 30.h),

                    // 8. زر الحفظ والإضافة
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<CarsCubit>().addCar(
                                        carData: {
                                          'brand_id': _selectedBrandId.toString(),
                                          'car_type_id': _selectedCarTypeId.toString(),
                                          'plate_number': _plateController.text.trim(),
                                          'model': _modelController.text.trim(),
                                          'year': _yearController.text.trim(),
                                          'color': _colorController.text.trim(),
                                          'fuel_type': _selectedFuelType,
                                          'cylinders': _cylindersController.text.trim(),
                                          'mileage': _mileageController.text.trim(),
                                        },
                                        imagePath: _selectedImage?.path,
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: AppColors.surfaceWhite)
                            : Text(
                                'إضافة السيارة',
                                style: TextStyles.Size18
                                    .withWeight(FontWeight.bold)
                                    .withColor(AppColors.surfaceWhite),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
      decoration: _getInputDecoration(icon, label: label),
    );
  }

  InputDecoration _getInputDecoration(IconData icon, {String? label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyles.Size15.withColor(AppColors.coolGrey),
      prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20.sp),
      filled: true,
      fillColor: AppColors.surfaceWhite,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.borderGrey, width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.borderGrey, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5.w),
      ),
    );
  }
}