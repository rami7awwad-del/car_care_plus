import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localization_ar.dart';
import 'app_localization_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Your Total is {ammount} Dollars'**
  String total(Object ammount);

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue using your car care services'**
  String get loginSubtitle;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get emailOrPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us to benefit from the best car care services'**
  String get createAccountSubtitle;

  /// No description provided for @individualAccount.
  ///
  /// In en, this message translates to:
  /// **'Individual Account'**
  String get individualAccount;

  /// No description provided for @companyAccount.
  ///
  /// In en, this message translates to:
  /// **'Company Account'**
  String get companyAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @companyInfo.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get companyInfo;

  /// No description provided for @companyInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter company details to complete registration'**
  String get companyInfoSubtitle;

  /// No description provided for @companyNameEn.
  ///
  /// In en, this message translates to:
  /// **'Company Name (English)'**
  String get companyNameEn;

  /// No description provided for @companyNameAr.
  ///
  /// In en, this message translates to:
  /// **'Company Name (Arabic)'**
  String get companyNameAr;

  /// No description provided for @commercialReg.
  ///
  /// In en, this message translates to:
  /// **'Commercial Registration Number'**
  String get commercialReg;

  /// No description provided for @taxNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax Number'**
  String get taxNumber;

  /// No description provided for @companyAddress.
  ///
  /// In en, this message translates to:
  /// **'Company Address'**
  String get companyAddress;

  /// No description provided for @createCompanyAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Company Account'**
  String get createCompanyAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Recovery'**
  String get forgotPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset code'**
  String get resetPasswordSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendOtp;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterOtpAndNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code and new password'**
  String get enterOtpAndNewPassword;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Request is Under Review'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Company account registered successfully. Your request is being reviewed and activated by management, please wait.'**
  String get pendingApprovalMessage;

  /// No description provided for @logoutAndReturn.
  ///
  /// In en, this message translates to:
  /// **'Log Out and Return'**
  String get logoutAndReturn;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @point.
  ///
  /// In en, this message translates to:
  /// **'Point'**
  String get point;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editCompanyProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Company Profile'**
  String get editCompanyProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @representativeName.
  ///
  /// In en, this message translates to:
  /// **'Representative Name'**
  String get representativeName;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhone;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @companyInformation.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get companyInformation;

  /// No description provided for @taxNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax Number'**
  String get taxNumberLabel;

  /// No description provided for @commercialRegLabel.
  ///
  /// In en, this message translates to:
  /// **'Commercial Registration'**
  String get commercialRegLabel;

  /// No description provided for @companyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Address'**
  String get companyAddressLabel;

  /// No description provided for @carBrand.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get carBrand;

  /// No description provided for @carModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get carModel;

  /// No description provided for @carColor.
  ///
  /// In en, this message translates to:
  /// **'Car Color (Optional)'**
  String get carColor;

  /// No description provided for @carPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'ABC 4521'**
  String get carPlateNumber;

  /// No description provided for @bookingSetup.
  ///
  /// In en, this message translates to:
  /// **'Booking Setup'**
  String get bookingSetup;

  /// No description provided for @bookingType.
  ///
  /// In en, this message translates to:
  /// **'Booking Type'**
  String get bookingType;

  /// No description provided for @instantBooking.
  ///
  /// In en, this message translates to:
  /// **'Instant Booking'**
  String get instantBooking;

  /// No description provided for @scheduledBooking.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Booking'**
  String get scheduledBooking;

  /// No description provided for @directService.
  ///
  /// In en, this message translates to:
  /// **'Direct Service'**
  String get directService;

  /// No description provided for @chooseDateTime.
  ///
  /// In en, this message translates to:
  /// **'Choose Date and Time'**
  String get chooseDateTime;

  /// No description provided for @vipServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium VIP Service'**
  String get vipServiceTitle;

  /// No description provided for @vipServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Priority service and specialized technicians at your service'**
  String get vipServiceSubtitle;

  /// No description provided for @serviceLocation.
  ///
  /// In en, this message translates to:
  /// **'Service Location'**
  String get serviceLocation;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @manualLocation.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualLocation;

  /// No description provided for @relocateCurrentPosition.
  ///
  /// In en, this message translates to:
  /// **'Reset Current Location'**
  String get relocateCurrentPosition;

  /// No description provided for @locatingPosition.
  ///
  /// In en, this message translates to:
  /// **'Locating position...'**
  String get locatingPosition;

  /// No description provided for @detailedAddress.
  ///
  /// In en, this message translates to:
  /// **'Detailed Address'**
  String get detailedAddress;

  /// No description provided for @detailedAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Riyadh - Al Malqa Dist. - King Fahd Road'**
  String get detailedAddressHint;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location service is disabled'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied, please enable it from settings'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while fetching location'**
  String get errorOccurred;

  /// No description provided for @selectWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Select Desired Workshop'**
  String get selectWorkshop;

  /// No description provided for @workshopSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected Workshop:'**
  String get workshopSelected;

  /// No description provided for @chooseWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose a suitable workshop'**
  String get chooseWorkshop;

  /// No description provided for @towingDestination.
  ///
  /// In en, this message translates to:
  /// **'Towing Truck Destination'**
  String get towingDestination;

  /// No description provided for @destinationAddress.
  ///
  /// In en, this message translates to:
  /// **'Destination address or target workshop name'**
  String get destinationAddress;

  /// No description provided for @destinationAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Old Industrial Area - Al Khaleej Workshop'**
  String get destinationAddressHint;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @pointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Points'**
  String pointsCount(Object count);

  /// No description provided for @activePackage.
  ///
  /// In en, this message translates to:
  /// **'Active Package'**
  String get activePackage;

  /// No description provided for @selectPackage.
  ///
  /// In en, this message translates to:
  /// **'Select Package'**
  String get selectPackage;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get onlinePayment;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @notesAndRequests.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes & Instructions'**
  String get notesAndRequests;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Write any additional details you\'d like to inform the team about...'**
  String get notesHint;

  /// No description provided for @calculateCostAndShowTotal.
  ///
  /// In en, this message translates to:
  /// **'Calculate Cost & Show Total'**
  String get calculateCostAndShowTotal;

  /// No description provided for @selectPackageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Suitable Package'**
  String get selectPackageTitle;

  /// No description provided for @remainingUses.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {count} uses'**
  String remainingUses(Object count);

  /// No description provided for @notEnoughForCars.
  ///
  /// In en, this message translates to:
  /// **'Not enough for the number of cars ({count})'**
  String notEnoughForCars(Object count);

  /// No description provided for @noActivePackages.
  ///
  /// In en, this message translates to:
  /// **'No active packages available for this booking'**
  String get noActivePackages;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Cost Summary & Confirmation'**
  String get bookingSummary;

  /// No description provided for @carsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Cars'**
  String get carsCount;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @vehicleSummary.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleSummary;

  /// No description provided for @serviceCost.
  ///
  /// In en, this message translates to:
  /// **'Service Cost'**
  String get serviceCost;

  /// No description provided for @distanceCost.
  ///
  /// In en, this message translates to:
  /// **'Distance Cost'**
  String get distanceCost;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @invoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'Invoice Total'**
  String get invoiceTotal;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get totalAmount;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking Now'**
  String get confirmBooking;

  /// No description provided for @currencySyrian.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySyrian;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking created successfully!'**
  String get bookingSuccess;

  /// No description provided for @myCars.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myCars;

  /// No description provided for @addCar.
  ///
  /// In en, this message translates to:
  /// **'Add Car'**
  String get addCar;

  /// No description provided for @addNewCar.
  ///
  /// In en, this message translates to:
  /// **'Add New Car'**
  String get addNewCar;

  /// No description provided for @editCar.
  ///
  /// In en, this message translates to:
  /// **'Edit Car Details'**
  String get editCar;

  /// No description provided for @carAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Car added successfully'**
  String get carAddedSuccess;

  /// No description provided for @carUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Car details updated successfully'**
  String get carUpdatedSuccess;

  /// No description provided for @carDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Car deleted successfully'**
  String get carDeletedSuccess;

  /// No description provided for @deleteCar.
  ///
  /// In en, this message translates to:
  /// **'Delete Car'**
  String get deleteCar;

  /// No description provided for @confirmDeleteCar.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this car from your vehicle list?'**
  String get confirmDeleteCar;

  /// No description provided for @noCarsAdded.
  ///
  /// In en, this message translates to:
  /// **'No cars added yet'**
  String get noCarsAdded;

  /// No description provided for @noCarsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle now to easily book maintenance and care services'**
  String get noCarsSubtitle;

  /// No description provided for @addCarImageHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a car photo (optional)'**
  String get addCarImageHint;

  /// No description provided for @carType.
  ///
  /// In en, this message translates to:
  /// **'Car Type'**
  String get carType;

  /// No description provided for @carModelHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Camry / Sonata'**
  String get carModelHint;

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// No description provided for @plateNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Example: ABC 1234'**
  String get plateNumberHint;

  /// No description provided for @manufactureYear.
  ///
  /// In en, this message translates to:
  /// **'Year of Manufacture'**
  String get manufactureYear;

  /// No description provided for @manufactureYearHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 2022'**
  String get manufactureYearHint;

  /// No description provided for @currentMileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage (Optional)'**
  String get currentMileage;

  /// No description provided for @currentMileageHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 55000'**
  String get currentMileageHint;

  /// No description provided for @cylindersCount.
  ///
  /// In en, this message translates to:
  /// **'Cylinders Count (Optional)'**
  String get cylindersCount;

  /// No description provided for @cylindersCountHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 4 / 6 / 8'**
  String get cylindersCountHint;

  /// No description provided for @carColorHint.
  ///
  /// In en, this message translates to:
  /// **'Example: White / Black'**
  String get carColorHint;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @fuelPetrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get fuelPetrol;

  /// No description provided for @fuelDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get fuelDiesel;

  /// No description provided for @fuelHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get fuelHybrid;

  /// No description provided for @fuelElectric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get fuelElectric;

  /// No description provided for @ourBranches.
  ///
  /// In en, this message translates to:
  /// **'Our Branches'**
  String get ourBranches;

  /// No description provided for @branchDetails.
  ///
  /// In en, this message translates to:
  /// **'Branch Details'**
  String get branchDetails;

  /// No description provided for @searchBranchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a branch, city, or address...'**
  String get searchBranchHint;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String distanceKm(Object distance);

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @phoneCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get phoneCall;

  /// No description provided for @locationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationOnMap;

  /// No description provided for @openLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openLocationOnMap;

  /// No description provided for @copyLocationLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Location Link'**
  String get copyLocationLink;

  /// No description provided for @managerName.
  ///
  /// In en, this message translates to:
  /// **'Manager Name'**
  String get managerName;

  /// No description provided for @noBranchesFound.
  ///
  /// In en, this message translates to:
  /// **'No branches found matching your search'**
  String get noBranchesFound;

  /// No description provided for @tryAnotherSearch.
  ///
  /// In en, this message translates to:
  /// **'Try another name or city'**
  String get tryAnotherSearch;

  /// No description provided for @addingMoreBranchesSoon.
  ///
  /// In en, this message translates to:
  /// **'We will add new branches soon'**
  String get addingMoreBranchesSoon;

  /// No description provided for @copiedLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} copied'**
  String copiedLabel(Object label);

  /// No description provided for @unableToCall.
  ///
  /// In en, this message translates to:
  /// **'Unable to open phone app'**
  String get unableToCall;

  /// No description provided for @unableToOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Unable to open map'**
  String get unableToOpenMap;

  /// No description provided for @errorLoadingBranches.
  ///
  /// In en, this message translates to:
  /// **'Error occurred while loading branches'**
  String get errorLoadingBranches;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @wash.
  ///
  /// In en, this message translates to:
  /// **'Wash'**
  String get wash;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @oil.
  ///
  /// In en, this message translates to:
  /// **'Oil'**
  String get oil;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome 👋'**
  String get welcome;

  /// No description provided for @chooseCarService.
  ///
  /// In en, this message translates to:
  /// **'Choose your car service'**
  String get chooseCarService;

  /// No description provided for @specialDiscount.
  ///
  /// In en, this message translates to:
  /// **'Special Discount 20%'**
  String get specialDiscount;

  /// No description provided for @fullCarCare.
  ///
  /// In en, this message translates to:
  /// **'Complete Care for Your Car'**
  String get fullCarCare;

  /// No description provided for @bookWashPackageNow.
  ///
  /// In en, this message translates to:
  /// **'Book the full wash and polishing package now'**
  String get bookWashPackageNow;

  /// No description provided for @noServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services currently available for this section'**
  String get noServicesAvailable;

  /// No description provided for @vip.
  ///
  /// In en, this message translates to:
  /// **'VIP ⭐'**
  String get vip;

  /// No description provided for @defaultServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'High quality, guaranteed service with top technicians.'**
  String get defaultServiceDescription;

  /// No description provided for @minutesFormat.
  ///
  /// In en, this message translates to:
  /// **'{minutes} mins'**
  String minutesFormat(Object minutes);

  /// No description provided for @currencyJod.
  ///
  /// In en, this message translates to:
  /// **'{price} JOD'**
  String currencyJod(Object price);

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @mainCategories.
  ///
  /// In en, this message translates to:
  /// **'Main Categories'**
  String get mainCategories;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @availableServices.
  ///
  /// In en, this message translates to:
  /// **'Available Services'**
  String get availableServices;

  /// No description provided for @fleet.
  ///
  /// In en, this message translates to:
  /// **'Fleet'**
  String get fleet;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @companyOrders.
  ///
  /// In en, this message translates to:
  /// **'Company Orders'**
  String get companyOrders;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get garage;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get now;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(Object count);

  /// No description provided for @twoMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'2 minutes ago'**
  String get twoMinutesAgo;

  /// No description provided for @oneMinuteAgo.
  ///
  /// In en, this message translates to:
  /// **'1 minute ago'**
  String get oneMinuteAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(Object count);

  /// No description provided for @twoHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get twoHoursAgo;

  /// No description provided for @oneHourAgo.
  ///
  /// In en, this message translates to:
  /// **'1 hour ago'**
  String get oneHourAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @twoDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get twoDaysAgo;

  /// No description provided for @oneDayAgo.
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get oneDayAgo;

  /// No description provided for @failedToFetchNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch notifications'**
  String get failedToFetchNotifications;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @unreadNotificationsCount.
  ///
  /// In en, this message translates to:
  /// **'You have {count} unread notifications'**
  String unreadNotificationsCount(Object count);

  /// No description provided for @noUnreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get noUnreadNotifications;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up 👌'**
  String get allCaughtUp;

  /// No description provided for @notificationUpdatesHint.
  ///
  /// In en, this message translates to:
  /// **'Updates regarding your orders and wallet will appear here'**
  String get notificationUpdatesHint;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @currencySyrianPound.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySyrianPound;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get orderNumber;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointment;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @workshop.
  ///
  /// In en, this message translates to:
  /// **'Workshop'**
  String get workshop;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @cancellationAvailableUntil.
  ///
  /// In en, this message translates to:
  /// **'Cancellation available until'**
  String get cancellationAvailableUntil;

  /// No description provided for @rebook.
  ///
  /// In en, this message translates to:
  /// **'Rebook'**
  String get rebook;

  /// No description provided for @rateService.
  ///
  /// In en, this message translates to:
  /// **'Rate Service'**
  String get rateService;

  /// No description provided for @cancelling.
  ///
  /// In en, this message translates to:
  /// **'Cancelling...'**
  String get cancelling;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @newBookingCreated.
  ///
  /// In en, this message translates to:
  /// **'New booking created successfully'**
  String get newBookingCreated;

  /// No description provided for @bookingCancelledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled successfully'**
  String get bookingCancelledSuccessfully;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @orderHistorySubTitle.
  ///
  /// In en, this message translates to:
  /// **'All your previous and current orders'**
  String get orderHistorySubTitle;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @rebookTitle.
  ///
  /// In en, this message translates to:
  /// **'Rebook'**
  String get rebookTitle;

  /// No description provided for @rebookDescription.
  ///
  /// In en, this message translates to:
  /// **'A new copy of the order will be created — the original order remains unchanged'**
  String get rebookDescription;

  /// No description provided for @selectAppointmentFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select booking appointment first'**
  String get selectAppointmentFirst;

  /// No description provided for @futureAppointmentError.
  ///
  /// In en, this message translates to:
  /// **'Must select a future appointment'**
  String get futureAppointmentError;

  /// No description provided for @selectPackagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose the package you want to use'**
  String get selectPackagePrompt;

  /// No description provided for @failedToLoadRebookData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load rebook data'**
  String get failedToLoadRebookData;

  /// No description provided for @bookingTime.
  ///
  /// In en, this message translates to:
  /// **'Booking Time'**
  String get bookingTime;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @immediate.
  ///
  /// In en, this message translates to:
  /// **'Immediate'**
  String get immediate;

  /// No description provided for @immediateHint.
  ///
  /// In en, this message translates to:
  /// **'Execution will start within an hour of confirmation'**
  String get immediateHint;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date and Time'**
  String get selectDateAndTime;

  /// No description provided for @noValidPackagesForBooking.
  ///
  /// In en, this message translates to:
  /// **'No valid packages for this booking, please select another payment method'**
  String get noValidPackagesForBooking;

  /// No description provided for @additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get additionalDetails;

  /// No description provided for @vipService.
  ///
  /// In en, this message translates to:
  /// **'VIP Service'**
  String get vipService;

  /// No description provided for @vipServiceHint.
  ///
  /// In en, this message translates to:
  /// **'Priority execution for an additional fee'**
  String get vipServiceHint;

  /// No description provided for @notesForTechnicianOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes for Technician (Optional)'**
  String get notesForTechnicianOptional;

  /// No description provided for @quoteExpiredError.
  ///
  /// In en, this message translates to:
  /// **'Quote expired, please recalculate price to proceed'**
  String get quoteExpiredError;

  /// No description provided for @confirming.
  ///
  /// In en, this message translates to:
  /// **'Confirming...'**
  String get confirming;

  /// No description provided for @recalculatePrice.
  ///
  /// In en, this message translates to:
  /// **'Recalculate Price'**
  String get recalculatePrice;

  /// No description provided for @calculatingPrice.
  ///
  /// In en, this message translates to:
  /// **'Calculating price...'**
  String get calculatingPrice;

  /// No description provided for @calculatePrice.
  ///
  /// In en, this message translates to:
  /// **'Calculate Price'**
  String get calculatePrice;

  /// No description provided for @originalService.
  ///
  /// In en, this message translates to:
  /// **'Original Service'**
  String get originalService;

  /// No description provided for @originalServiceUnchangeable.
  ///
  /// In en, this message translates to:
  /// **'Original service cannot be changed during rebooking'**
  String get originalServiceUnchangeable;

  /// No description provided for @newQuote.
  ///
  /// In en, this message translates to:
  /// **'New Quote'**
  String get newQuote;

  /// No description provided for @quoteDynamicPriceNote.
  ///
  /// In en, this message translates to:
  /// **'Price is calculated based on current rates and may differ from previous order'**
  String get quoteDynamicPriceNote;

  /// No description provided for @serviceValue.
  ///
  /// In en, this message translates to:
  /// **'Service Value'**
  String get serviceValue;

  /// No description provided for @remainingCash.
  ///
  /// In en, this message translates to:
  /// **'Remaining in Cash'**
  String get remainingCash;

  /// No description provided for @quoteExpired.
  ///
  /// In en, this message translates to:
  /// **'Quote Expired'**
  String get quoteExpired;

  /// No description provided for @validDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Valid for'**
  String get validDurationMinutes;

  /// No description provided for @cancelReasonChangedMind.
  ///
  /// In en, this message translates to:
  /// **'Changed my mind'**
  String get cancelReasonChangedMind;

  /// No description provided for @cancelReasonTimeUnsuitable.
  ///
  /// In en, this message translates to:
  /// **'Time is no longer suitable'**
  String get cancelReasonTimeUnsuitable;

  /// No description provided for @cancelReasonAccidentalBooking.
  ///
  /// In en, this message translates to:
  /// **'Booked by mistake'**
  String get cancelReasonAccidentalBooking;

  /// No description provided for @cancelReasonFoundOtherService.
  ///
  /// In en, this message translates to:
  /// **'Found another service'**
  String get cancelReasonFoundOtherService;

  /// No description provided for @whatHappensOnCancel.
  ///
  /// In en, this message translates to:
  /// **'What happens upon cancellation?'**
  String get whatHappensOnCancel;

  /// No description provided for @cancelConsequenceRefund.
  ///
  /// In en, this message translates to:
  /// **'The paid amount will be refunded based on the payment method'**
  String get cancelConsequenceRefund;

  /// No description provided for @cancelConsequencePoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty points earned from this order will be revoked'**
  String get cancelConsequencePoints;

  /// No description provided for @cancelConsequenceMaterials.
  ///
  /// In en, this message translates to:
  /// **'Reserved materials will be returned to inventory'**
  String get cancelConsequenceMaterials;

  /// No description provided for @cancelConsequenceRecord.
  ///
  /// In en, this message translates to:
  /// **'The order will remain in history as cancelled'**
  String get cancelConsequenceRecord;

  /// No description provided for @cancelReasonRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason (Required)'**
  String get cancelReasonRequiredTitle;

  /// No description provided for @cancelReasonPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write cancellation reason here'**
  String get cancelReasonPlaceholder;

  /// No description provided for @cancelReasonRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason is required'**
  String get cancelReasonRequiredError;

  /// No description provided for @maxReasonLengthExceeded.
  ///
  /// In en, this message translates to:
  /// **'Maximum character limit exceeded'**
  String get maxReasonLengthExceeded;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellation;

  /// No description provided for @maintenanceService.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Service'**
  String get maintenanceService;

  /// No description provided for @orderStages.
  ///
  /// In en, this message translates to:
  /// **'Order Stages'**
  String get orderStages;

  /// No description provided for @runningSince.
  ///
  /// In en, this message translates to:
  /// **'Running since'**
  String get runningSince;

  /// No description provided for @executionDuration.
  ///
  /// In en, this message translates to:
  /// **'Execution Duration'**
  String get executionDuration;

  /// No description provided for @startDelay.
  ///
  /// In en, this message translates to:
  /// **'Start Delay'**
  String get startDelay;

  /// No description provided for @startedEarly.
  ///
  /// In en, this message translates to:
  /// **'Started Early'**
  String get startedEarly;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// No description provided for @notCompletedYet.
  ///
  /// In en, this message translates to:
  /// **'Not completed yet'**
  String get notCompletedYet;

  /// No description provided for @timeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Time not available'**
  String get timeNotAvailable;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @activeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Active Subscription'**
  String get activeSubscription;

  /// No description provided for @currentPackage.
  ///
  /// In en, this message translates to:
  /// **'Your Current Package'**
  String get currentPackage;

  /// No description provided for @remainingServices.
  ///
  /// In en, this message translates to:
  /// **'Remaining Services'**
  String get remainingServices;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in'**
  String get expiresIn;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysCount;

  /// No description provided for @carCarePlusPackageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Car Care Plus Service Package'**
  String get carCarePlusPackageSubtitle;

  /// No description provided for @servicesCount.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesCount;

  /// No description provided for @validityDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get validityDays;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountPercentage;

  /// No description provided for @packageValidity.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get packageValidity;

  /// No description provided for @aboutPackage.
  ///
  /// In en, this message translates to:
  /// **'About Package'**
  String get aboutPackage;

  /// No description provided for @noExtraDescriptionForPackage.
  ///
  /// In en, this message translates to:
  /// **'No extra description for this package.'**
  String get noExtraDescriptionForPackage;

  /// No description provided for @alreadySubscribedToPackage.
  ///
  /// In en, this message translates to:
  /// **'You are already subscribed to this package'**
  String get alreadySubscribedToPackage;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @currentlyNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Currently Not Available'**
  String get currentlyNotAvailable;

  /// No description provided for @confirmSubscription.
  ///
  /// In en, this message translates to:
  /// **'Confirm Subscription'**
  String get confirmSubscription;

  /// No description provided for @confirmSubscriptionDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You will subscribe to the package and the amount will be deducted from your wallet.'**
  String get confirmSubscriptionDialogBody;

  /// No description provided for @cannotSubscribeAnotherPackageWarning.
  ///
  /// In en, this message translates to:
  /// **'You cannot subscribe to another package before your current subscription ends.'**
  String get cannotSubscribeAnotherPackageWarning;

  /// No description provided for @failedToFetchPackages.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch packages'**
  String get failedToFetchPackages;

  /// No description provided for @availablePackages.
  ///
  /// In en, this message translates to:
  /// **'Available Packages'**
  String get availablePackages;

  /// No description provided for @canSubscribeAfterCurrentEndsHint.
  ///
  /// In en, this message translates to:
  /// **'You can subscribe to a new package after your current subscription ends'**
  String get canSubscribeAfterCurrentEndsHint;

  /// No description provided for @choosePackageSuitingYou.
  ///
  /// In en, this message translates to:
  /// **'Choose the package that suits your usage'**
  String get choosePackageSuitingYou;

  /// No description provided for @youHaveActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'You have an active subscription'**
  String get youHaveActiveSubscription;

  /// No description provided for @saveMoreWithPackagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save more with maintenance and wash packages'**
  String get saveMoreWithPackagesSubtitle;

  /// No description provided for @noActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'No active subscription'**
  String get noActiveSubscription;

  /// No description provided for @choosePackageToStart.
  ///
  /// In en, this message translates to:
  /// **'Choose a package below to get started'**
  String get choosePackageToStart;

  /// No description provided for @noPackagesAvailableCurrently.
  ///
  /// In en, this message translates to:
  /// **'No packages available currently'**
  String get noPackagesAvailableCurrently;

  /// No description provided for @pleaseRateServiceFirst.
  ///
  /// In en, this message translates to:
  /// **'Please rate the service first'**
  String get pleaseRateServiceFirst;

  /// No description provided for @thankYouRatingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your rating has been submitted successfully'**
  String get thankYouRatingSubmitted;

  /// No description provided for @yourOpinionMatters.
  ///
  /// In en, this message translates to:
  /// **'Your opinion matters to us'**
  String get yourOpinionMatters;

  /// No description provided for @rateYourExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience with this order to help us improve'**
  String get rateYourExperienceHint;

  /// No description provided for @mandatory.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get mandatory;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @additionalComments.
  ///
  /// In en, this message translates to:
  /// **'Additional Comments'**
  String get additionalComments;

  /// No description provided for @writeYourNotesHere.
  ///
  /// In en, this message translates to:
  /// **'Write your notes here...'**
  String get writeYourNotesHere;

  /// No description provided for @sendRating.
  ///
  /// In en, this message translates to:
  /// **'Send Rating'**
  String get sendRating;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @expectedDuration.
  ///
  /// In en, this message translates to:
  /// **'Expected Duration: '**
  String get expectedDuration;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @preparingServiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Preparing service details...'**
  String get preparingServiceDetails;

  /// No description provided for @selectCar.
  ///
  /// In en, this message translates to:
  /// **'Select Car'**
  String get selectCar;

  /// No description provided for @subServicesAndAddons.
  ///
  /// In en, this message translates to:
  /// **'Sub-services & Add-ons'**
  String get subServicesAndAddons;

  /// No description provided for @addedMaterialsAndParts.
  ///
  /// In en, this message translates to:
  /// **'Added Materials & Parts'**
  String get addedMaterialsAndParts;

  /// No description provided for @pleaseSelectCarFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a car first'**
  String get pleaseSelectCarFirst;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @currencySar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get currencySar;

  /// No description provided for @currencySyp.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySyp;

  /// No description provided for @chargeBalance.
  ///
  /// In en, this message translates to:
  /// **'Top Up Balance'**
  String get chargeBalance;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance '**
  String get balance;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @paymentReceipt.
  ///
  /// In en, this message translates to:
  /// **'Payment Receipt'**
  String get paymentReceipt;

  /// No description provided for @transactionCode.
  ///
  /// In en, this message translates to:
  /// **'Transaction Code'**
  String get transactionCode;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pointsUsed.
  ///
  /// In en, this message translates to:
  /// **'Points Used'**
  String get pointsUsed;

  /// No description provided for @walletAndPayments.
  ///
  /// In en, this message translates to:
  /// **'Wallet & Payments'**
  String get walletAndPayments;

  /// No description provided for @walletTopupViaSupportHint.
  ///
  /// In en, this message translates to:
  /// **'Balance top-up is currently managed via support, and funds are credited immediately upon addition'**
  String get walletTopupViaSupportHint;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @transactionsCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsCount;

  /// No description provided for @paymentsAndBalanceAdditions.
  ///
  /// In en, this message translates to:
  /// **'Payments and Balance Additions'**
  String get paymentsAndBalanceAdditions;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @emptyTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking payments and added balance will appear here'**
  String get emptyTransactionsSubtitle;

  /// No description provided for @chooseMaintenanceWorkshop.
  ///
  /// In en, this message translates to:
  /// **'Choose Maintenance Workshop'**
  String get chooseMaintenanceWorkshop;

  /// No description provided for @nearbyActiveWorkshopsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active workshops near your location, sorted by proximity'**
  String get nearbyActiveWorkshopsSubtitle;

  /// No description provided for @noActiveWorkshopsNearby.
  ///
  /// In en, this message translates to:
  /// **'No active workshops near your location'**
  String get noActiveWorkshopsNearby;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @aiChatGreetingTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi 👋 I am your smart assistant for diagnosing car faults.'**
  String get aiChatGreetingTitle;

  /// No description provided for @aiChatGreetingBody.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem you are facing, then I will ask you a few short questions before giving you the diagnosis.'**
  String get aiChatGreetingBody;

  /// No description provided for @aiArabicContentNote.
  ///
  /// In en, this message translates to:
  /// **'The assistant\'s questions and diagnosis are always provided in Arabic.'**
  String get aiArabicContentNote;

  /// No description provided for @aiChatDescribeProblemHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your car problem...'**
  String get aiChatDescribeProblemHint;

  /// No description provided for @aiChatAnswerHint.
  ///
  /// In en, this message translates to:
  /// **'Type your answer...'**
  String get aiChatAnswerHint;

  /// No description provided for @aiChatFinishedHint.
  ///
  /// In en, this message translates to:
  /// **'Conversation ended — start a new one'**
  String get aiChatFinishedHint;

  /// No description provided for @aiChatErrorHint.
  ///
  /// In en, this message translates to:
  /// **'Retry or start a new conversation'**
  String get aiChatErrorHint;

  /// No description provided for @aiChatAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing the problem, this may take a minute...'**
  String get aiChatAnalyzing;

  /// No description provided for @aiChatPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get aiChatPreparing;

  /// No description provided for @aiChatNewConversation.
  ///
  /// In en, this message translates to:
  /// **'New conversation'**
  String get aiChatNewConversation;

  /// No description provided for @aiChatStartNewConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation'**
  String get aiChatStartNewConversation;

  /// No description provided for @aiDiagnosisResult.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis Result'**
  String get aiDiagnosisResult;

  /// No description provided for @aiPossibleCauses.
  ///
  /// In en, this message translates to:
  /// **'Possible Causes'**
  String get aiPossibleCauses;

  /// No description provided for @aiRecommendedService.
  ///
  /// In en, this message translates to:
  /// **'Recommended Service'**
  String get aiRecommendedService;

  /// No description provided for @aiNoMatchingService.
  ///
  /// In en, this message translates to:
  /// **'No matching service found — please contact the workshop'**
  String get aiNoMatchingService;

  /// No description provided for @aiGeneratedDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AI-generated answer that may contain errors — a workshop inspection remains the reference'**
  String get aiGeneratedDisclaimer;

  /// No description provided for @aiSeverityLow.
  ///
  /// In en, this message translates to:
  /// **'Low severity'**
  String get aiSeverityLow;

  /// No description provided for @aiSeverityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium severity'**
  String get aiSeverityMedium;

  /// No description provided for @aiSeverityHigh.
  ///
  /// In en, this message translates to:
  /// **'High severity'**
  String get aiSeverityHigh;

  /// No description provided for @aiAddServiceToOrder.
  ///
  /// In en, this message translates to:
  /// **'Add service to order'**
  String get aiAddServiceToOrder;

  /// No description provided for @aiServiceAddedToOrder.
  ///
  /// In en, this message translates to:
  /// **'Service added to the order'**
  String get aiServiceAddedToOrder;

  /// No description provided for @aiApplyServiceConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Service to Order'**
  String get aiApplyServiceConfirmTitle;

  /// No description provided for @aiApplyServiceConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The order\'s current service will be replaced with \"{service}\" and its total price recalculated. Do you want to continue?'**
  String aiApplyServiceConfirmBody(Object service);

  /// No description provided for @aiServiceAppliedSuccess.
  ///
  /// In en, this message translates to:
  /// **'The service was added to the order successfully'**
  String get aiServiceAppliedSuccess;

  /// No description provided for @aiDiagnosisUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis is unavailable right now, please try again later'**
  String get aiDiagnosisUnavailable;

  /// No description provided for @aiApplyServiceFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add the service to the order'**
  String get aiApplyServiceFailed;

  /// No description provided for @aiConversationLoopError.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the conversation, please start a new one'**
  String get aiConversationLoopError;

  /// No description provided for @aiUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get aiUnexpectedError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
