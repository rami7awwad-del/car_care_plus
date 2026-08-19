// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get session => 'Session';

  @override
  String total(Object ammount) {
    return 'Your Total is $ammount Dollars';
  }

  @override
  String get login => 'Login';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Log in to continue using your car care services';

  @override
  String get emailOrPhone => 'Email or Phone Number';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get register => 'Register';

  @override
  String get createAccountTitle => 'Create New Account';

  @override
  String get createAccountSubtitle =>
      'Join us to benefit from the best car care services';

  @override
  String get individualAccount => 'Individual Account';

  @override
  String get companyAccount => 'Company Account';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get next => 'Next';

  @override
  String get companyInfo => 'Company Information';

  @override
  String get companyInfoSubtitle =>
      'Enter company details to complete registration';

  @override
  String get companyNameEn => 'Company Name (English)';

  @override
  String get companyNameAr => 'Company Name (Arabic)';

  @override
  String get commercialReg => 'Commercial Registration Number';

  @override
  String get taxNumber => 'Tax Number';

  @override
  String get companyAddress => 'Company Address';

  @override
  String get createCompanyAccount => 'Create Company Account';

  @override
  String get forgotPasswordTitle => 'Password Recovery';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email to receive a reset code';

  @override
  String get sendOtp => 'Send Verification Code';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterOtpAndNewPassword =>
      'Enter verification code and new password';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get newPassword => 'New Password';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get pendingApprovalTitle => 'Your Request is Under Review';

  @override
  String get pendingApprovalMessage =>
      'Company account registered successfully. Your request is being reviewed and activated by management, please wait.';

  @override
  String get logoutAndReturn => 'Log Out and Return';

  @override
  String get profile => 'Profile';

  @override
  String get myProfile => 'My Profile';

  @override
  String get wallet => 'Wallet';

  @override
  String get points => 'Points';

  @override
  String get myOrders => 'My Orders';

  @override
  String get point => 'Point';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editCompanyProfile => 'Edit Company Profile';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get representativeName => 'Representative Name';

  @override
  String get contactPhone => 'Contact Phone';

  @override
  String get logout => 'Log Out';

  @override
  String get confirmLogoutTitle => 'Log Out';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String get companyInformation => 'Company Information';

  @override
  String get taxNumberLabel => 'Tax Number';

  @override
  String get commercialRegLabel => 'Commercial Registration';

  @override
  String get companyAddressLabel => 'Company Address';

  @override
  String get carBrand => 'Make';

  @override
  String get carModel => 'Model';

  @override
  String get carColor => 'Car Color (Optional)';

  @override
  String get carPlateNumber => 'ABC 4521';

  @override
  String get bookingSetup => 'Booking Setup';

  @override
  String get bookingType => 'Booking Type';

  @override
  String get instantBooking => 'Instant Booking';

  @override
  String get scheduledBooking => 'Scheduled Booking';

  @override
  String get directService => 'Direct Service';

  @override
  String get chooseDateTime => 'Choose Date and Time';

  @override
  String get vipServiceTitle => 'Premium VIP Service';

  @override
  String get vipServiceSubtitle =>
      'Priority service and specialized technicians at your service';

  @override
  String get serviceLocation => 'Service Location';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get manualLocation => 'Manual Entry';

  @override
  String get relocateCurrentPosition => 'Reset Current Location';

  @override
  String get locatingPosition => 'Locating position...';

  @override
  String get detailedAddress => 'Detailed Address';

  @override
  String get detailedAddressHint =>
      'Example: Riyadh - Al Malqa Dist. - King Fahd Road';

  @override
  String get locationServiceDisabled => 'Location service is disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied, please enable it from settings';

  @override
  String get errorOccurred => 'An error occurred while fetching location';

  @override
  String get selectWorkshop => 'Select Desired Workshop';

  @override
  String get workshopSelected => 'Selected Workshop:';

  @override
  String get chooseWorkshop => 'Tap to choose a suitable workshop';

  @override
  String get towingDestination => 'Towing Truck Destination';

  @override
  String get destinationAddress =>
      'Destination address or target workshop name';

  @override
  String get destinationAddressHint =>
      'Example: Old Industrial Area - Al Khaleej Workshop';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cash => 'Cash';

  @override
  String pointsCount(Object count) {
    return '$count Points';
  }

  @override
  String get activePackage => 'Active Package';

  @override
  String get selectPackage => 'Select Package';

  @override
  String get onlinePayment => 'Online Payment';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get notesAndRequests => 'Additional Notes & Instructions';

  @override
  String get notesHint =>
      'Write any additional details you\'d like to inform the team about...';

  @override
  String get calculateCostAndShowTotal => 'Calculate Cost & Show Total';

  @override
  String get selectPackageTitle => 'Choose Suitable Package';

  @override
  String remainingUses(Object count) {
    return 'Remaining: $count uses';
  }

  @override
  String notEnoughForCars(Object count) {
    return 'Not enough for the number of cars ($count)';
  }

  @override
  String get noActivePackages =>
      'No active packages available for this booking';

  @override
  String get bookingSummary => 'Cost Summary & Confirmation';

  @override
  String get carsCount => 'Number of Cars';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get vehicleSummary => 'Vehicle Details';

  @override
  String get serviceCost => 'Service Cost';

  @override
  String get distanceCost => 'Distance Cost';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get invoiceTotal => 'Invoice Total';

  @override
  String get totalAmount => 'Grand Total';

  @override
  String get confirmBooking => 'Confirm Booking Now';

  @override
  String get currencySyrian => 'SYP';

  @override
  String get bookingSuccess => 'Booking created successfully!';

  @override
  String get myCars => 'My Vehicles';

  @override
  String get addCar => 'Add Car';

  @override
  String get addNewCar => 'Add New Car';

  @override
  String get editCar => 'Edit Car Details';

  @override
  String get carAddedSuccess => 'Car added successfully';

  @override
  String get carUpdatedSuccess => 'Car details updated successfully';

  @override
  String get carDeletedSuccess => 'Car deleted successfully';

  @override
  String get deleteCar => 'Delete Car';

  @override
  String get confirmDeleteCar =>
      'Are you sure you want to delete this car from your vehicle list?';

  @override
  String get noCarsAdded => 'No cars added yet';

  @override
  String get noCarsSubtitle =>
      'Add your first vehicle now to easily book maintenance and care services';

  @override
  String get addCarImageHint => 'Tap to add a car photo (optional)';

  @override
  String get carType => 'Car Type';

  @override
  String get carModelHint => 'Example: Camry / Sonata';

  @override
  String get plateNumber => 'Plate Number';

  @override
  String get plateNumberHint => 'Example: ABC 1234';

  @override
  String get manufactureYear => 'Year of Manufacture';

  @override
  String get manufactureYearHint => 'Example: 2022';

  @override
  String get currentMileage => 'Mileage (Optional)';

  @override
  String get currentMileageHint => 'Example: 55000';

  @override
  String get cylindersCount => 'Cylinders Count (Optional)';

  @override
  String get cylindersCountHint => 'Example: 4 / 6 / 8';

  @override
  String get carColorHint => 'Example: White / Black';

  @override
  String get fuelType => 'Fuel Type';

  @override
  String get fuelPetrol => 'Petrol';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelHybrid => 'Hybrid';

  @override
  String get fuelElectric => 'Electric';

  @override
  String get ourBranches => 'Our Branches';

  @override
  String get branchDetails => 'Branch Details';

  @override
  String get searchBranchHint => 'Search for a branch, city, or address...';

  @override
  String distanceKm(Object distance) {
    return '$distance km';
  }

  @override
  String get workingHours => 'Working Hours';

  @override
  String get phoneCall => 'Call';

  @override
  String get locationOnMap => 'Location';

  @override
  String get openLocationOnMap => 'Open in Google Maps';

  @override
  String get copyLocationLink => 'Copy Location Link';

  @override
  String get managerName => 'Manager Name';

  @override
  String get noBranchesFound => 'No branches found matching your search';

  @override
  String get tryAnotherSearch => 'Try another name or city';

  @override
  String get addingMoreBranchesSoon => 'We will add new branches soon';

  @override
  String copiedLabel(Object label) {
    return '$label copied';
  }

  @override
  String get unableToCall => 'Unable to open phone app';

  @override
  String get unableToOpenMap => 'Unable to open map';

  @override
  String get errorLoadingBranches => 'Error occurred while loading branches';

  @override
  String get retry => 'Retry';

  @override
  String get wash => 'Wash';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get oil => 'Oil';

  @override
  String get welcome => 'Welcome 👋';

  @override
  String get chooseCarService => 'Choose your car service';

  @override
  String get specialDiscount => 'Special Discount 20%';

  @override
  String get fullCarCare => 'Complete Care for Your Car';

  @override
  String get bookWashPackageNow =>
      'Book the full wash and polishing package now';

  @override
  String get noServicesAvailable =>
      'No services currently available for this section';

  @override
  String get vip => 'VIP ⭐';

  @override
  String get defaultServiceDescription =>
      'High quality, guaranteed service with top technicians.';

  @override
  String minutesFormat(Object minutes) {
    return '$minutes mins';
  }

  @override
  String currencyJod(Object price) {
    return '$price JOD';
  }

  @override
  String get bookNow => 'Book Now';

  @override
  String get mainCategories => 'Main Categories';

  @override
  String get showAll => 'Show All';

  @override
  String get availableServices => 'Available Services';

  @override
  String get fleet => 'Fleet';

  @override
  String get home => 'Home';

  @override
  String get companyOrders => 'Company Orders';

  @override
  String get myAccount => 'My Account';

  @override
  String get garage => 'Garage';

  @override
  String get packages => 'Packages';

  @override
  String get viewDetails => 'View Details';

  @override
  String get now => 'Just now';

  @override
  String minutesAgo(Object count) {
    return '$count minutes ago';
  }

  @override
  String get twoMinutesAgo => '2 minutes ago';

  @override
  String get oneMinuteAgo => '1 minute ago';

  @override
  String hoursAgo(Object count) {
    return '$count hours ago';
  }

  @override
  String get twoHoursAgo => '2 hours ago';

  @override
  String get oneHourAgo => '1 hour ago';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String get twoDaysAgo => '2 days ago';

  @override
  String get oneDayAgo => '1 day ago';

  @override
  String get failedToFetchNotifications => 'Failed to fetch notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String unreadNotificationsCount(Object count) {
    return 'You have $count unread notifications';
  }

  @override
  String get noUnreadNotifications => 'No unread notifications';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String get all => 'All';

  @override
  String get unread => 'Unread';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get allCaughtUp => 'You\'re all caught up 👌';

  @override
  String get notificationUpdatesHint =>
      'Updates regarding your orders and wallet will appear here';

  @override
  String get package => 'Package';

  @override
  String get currencySyrianPound => 'SYP';

  @override
  String get confirm => 'Confirm';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderNumber => 'Order #';

  @override
  String get service => 'Service';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get appointment => 'Appointment';

  @override
  String get car => 'Car';

  @override
  String get workshop => 'Workshop';

  @override
  String get status => 'Status';

  @override
  String get notes => 'Notes';

  @override
  String get cancellationAvailableUntil => 'Cancellation available until';

  @override
  String get rebook => 'Rebook';

  @override
  String get rateService => 'Rate Service';

  @override
  String get cancelling => 'Cancelling...';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get newBookingCreated => 'New booking created successfully';

  @override
  String get bookingCancelledSuccessfully => 'Booking cancelled successfully';

  @override
  String get orderHistory => 'Order History';

  @override
  String get orderHistorySubTitle => 'All your previous and current orders';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get rebookTitle => 'Rebook';

  @override
  String get rebookDescription =>
      'A new copy of the order will be created — the original order remains unchanged';

  @override
  String get selectAppointmentFirst =>
      'Please select booking appointment first';

  @override
  String get futureAppointmentError => 'Must select a future appointment';

  @override
  String get selectPackagePrompt => 'Choose the package you want to use';

  @override
  String get failedToLoadRebookData => 'Failed to load rebook data';

  @override
  String get bookingTime => 'Booking Time';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get immediate => 'Immediate';

  @override
  String get immediateHint =>
      'Execution will start within an hour of confirmation';

  @override
  String get selectDateAndTime => 'Select Date and Time';

  @override
  String get noValidPackagesForBooking =>
      'No valid packages for this booking, please select another payment method';

  @override
  String get additionalDetails => 'Additional Details';

  @override
  String get vipService => 'VIP Service';

  @override
  String get vipServiceHint => 'Priority execution for an additional fee';

  @override
  String get notesForTechnicianOptional => 'Notes for Technician (Optional)';

  @override
  String get quoteExpiredError =>
      'Quote expired, please recalculate price to proceed';

  @override
  String get confirming => 'Confirming...';

  @override
  String get recalculatePrice => 'Recalculate Price';

  @override
  String get calculatingPrice => 'Calculating price...';

  @override
  String get calculatePrice => 'Calculate Price';

  @override
  String get originalService => 'Original Service';

  @override
  String get originalServiceUnchangeable =>
      'Original service cannot be changed during rebooking';

  @override
  String get newQuote => 'New Quote';

  @override
  String get quoteDynamicPriceNote =>
      'Price is calculated based on current rates and may differ from previous order';

  @override
  String get serviceValue => 'Service Value';

  @override
  String get remainingCash => 'Remaining in Cash';

  @override
  String get quoteExpired => 'Quote Expired';

  @override
  String get validDurationMinutes => 'Valid for';

  @override
  String get cancelReasonChangedMind => 'Changed my mind';

  @override
  String get cancelReasonTimeUnsuitable => 'Time is no longer suitable';

  @override
  String get cancelReasonAccidentalBooking => 'Booked by mistake';

  @override
  String get cancelReasonFoundOtherService => 'Found another service';

  @override
  String get whatHappensOnCancel => 'What happens upon cancellation?';

  @override
  String get cancelConsequenceRefund =>
      'The paid amount will be refunded based on the payment method';

  @override
  String get cancelConsequencePoints =>
      'Loyalty points earned from this order will be revoked';

  @override
  String get cancelConsequenceMaterials =>
      'Reserved materials will be returned to inventory';

  @override
  String get cancelConsequenceRecord =>
      'The order will remain in history as cancelled';

  @override
  String get cancelReasonRequiredTitle => 'Cancellation Reason (Required)';

  @override
  String get cancelReasonPlaceholder => 'Write cancellation reason here';

  @override
  String get cancelReasonRequiredError => 'Cancellation reason is required';

  @override
  String get maxReasonLengthExceeded => 'Maximum character limit exceeded';

  @override
  String get confirmCancellation => 'Confirm Cancellation';

  @override
  String get maintenanceService => 'Maintenance Service';

  @override
  String get orderStages => 'Order Stages';

  @override
  String get runningSince => 'Running since';

  @override
  String get executionDuration => 'Execution Duration';

  @override
  String get startDelay => 'Start Delay';

  @override
  String get startedEarly => 'Started Early';

  @override
  String get currentStatus => 'Current Status';

  @override
  String get notCompletedYet => 'Not completed yet';

  @override
  String get timeNotAvailable => 'Time not available';

  @override
  String get reason => 'Reason';

  @override
  String get activeSubscription => 'Active Subscription';

  @override
  String get currentPackage => 'Your Current Package';

  @override
  String get remainingServices => 'Remaining Services';

  @override
  String get remaining => 'Remaining';

  @override
  String get expiresIn => 'Expires in';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get today => 'Today';

  @override
  String get daysCount => 'Days';

  @override
  String get carCarePlusPackageSubtitle => 'Car Care Plus Service Package';

  @override
  String get servicesCount => 'Services';

  @override
  String get validityDays => 'Days';

  @override
  String get price => 'Price';

  @override
  String get activated => 'Activated';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get discountPercentage => 'Discount';

  @override
  String get packageValidity => 'Validity';

  @override
  String get aboutPackage => 'About Package';

  @override
  String get noExtraDescriptionForPackage =>
      'No extra description for this package.';

  @override
  String get alreadySubscribedToPackage =>
      'You are already subscribed to this package';

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get currentlyNotAvailable => 'Currently Not Available';

  @override
  String get confirmSubscription => 'Confirm Subscription';

  @override
  String get confirmSubscriptionDialogBody =>
      'You will subscribe to the package and the amount will be deducted from your wallet.';

  @override
  String get cannotSubscribeAnotherPackageWarning =>
      'You cannot subscribe to another package before your current subscription ends.';

  @override
  String get failedToFetchPackages => 'Failed to fetch packages';

  @override
  String get availablePackages => 'Available Packages';

  @override
  String get canSubscribeAfterCurrentEndsHint =>
      'You can subscribe to a new package after your current subscription ends';

  @override
  String get choosePackageSuitingYou =>
      'Choose the package that suits your usage';

  @override
  String get youHaveActiveSubscription => 'You have an active subscription';

  @override
  String get saveMoreWithPackagesSubtitle =>
      'Save more with maintenance and wash packages';

  @override
  String get noActiveSubscription => 'No active subscription';

  @override
  String get choosePackageToStart => 'Choose a package below to get started';

  @override
  String get noPackagesAvailableCurrently => 'No packages available currently';

  @override
  String get pleaseRateServiceFirst => 'Please rate the service first';

  @override
  String get thankYouRatingSubmitted =>
      'Thank you! Your rating has been submitted successfully';

  @override
  String get yourOpinionMatters => 'Your opinion matters to us';

  @override
  String get rateYourExperienceHint =>
      'Rate your experience with this order to help us improve';

  @override
  String get mandatory => 'Mandatory';

  @override
  String get employee => 'Employee';

  @override
  String get optional => 'Optional';

  @override
  String get additionalComments => 'Additional Comments';

  @override
  String get writeYourNotesHere => 'Write your notes here...';

  @override
  String get sendRating => 'Send Rating';

  @override
  String get totalCost => 'Total Cost';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get expectedDuration => 'Expected Duration: ';

  @override
  String get description => 'Description';

  @override
  String get preparingServiceDetails => 'Preparing service details...';

  @override
  String get selectCar => 'Select Car';

  @override
  String get subServicesAndAddons => 'Sub-services & Add-ons';

  @override
  String get addedMaterialsAndParts => 'Added Materials & Parts';

  @override
  String get pleaseSelectCarFirst => 'Please select a car first';

  @override
  String get availableBalance => 'Available Balance';

  @override
  String get currencySar => 'SAR';

  @override
  String get currencySyp => 'SYP';

  @override
  String get chargeBalance => 'Top Up Balance';

  @override
  String get balance => 'Balance ';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get paymentReceipt => 'Payment Receipt';

  @override
  String get transactionCode => 'Transaction Code';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get pointsUsed => 'Points Used';

  @override
  String get walletAndPayments => 'Wallet & Payments';

  @override
  String get walletTopupViaSupportHint =>
      'Balance top-up is currently managed via support, and funds are credited immediately upon addition';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get transactionsCount => 'Transactions';

  @override
  String get paymentsAndBalanceAdditions => 'Payments and Balance Additions';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get emptyTransactionsSubtitle =>
      'Your booking payments and added balance will appear here';

  @override
  String get chooseMaintenanceWorkshop => 'Choose Maintenance Workshop';

  @override
  String get nearbyActiveWorkshopsSubtitle =>
      'Active workshops near your location, sorted by proximity';

  @override
  String get noActiveWorkshopsNearby =>
      'No active workshops near your location';

  @override
  String get km => 'km';

  @override
  String get language => 'Language';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get aiChatGreetingTitle =>
      'Hi 👋 I am your smart assistant for diagnosing car faults.';

  @override
  String get aiChatGreetingBody =>
      'Describe the problem you are facing, then I will ask you a few short questions before giving you the diagnosis.';

  @override
  String get aiArabicContentNote =>
      'The assistant\'s questions and diagnosis are always provided in Arabic.';

  @override
  String get aiChatDescribeProblemHint => 'Describe your car problem...';

  @override
  String get aiChatAnswerHint => 'Type your answer...';

  @override
  String get aiChatFinishedHint => 'Conversation ended — start a new one';

  @override
  String get aiChatErrorHint => 'Retry or start a new conversation';

  @override
  String get aiChatAnalyzing =>
      'Analyzing the problem, this may take a minute...';

  @override
  String get aiChatPreparing => 'Preparing...';

  @override
  String get aiChatNewConversation => 'New conversation';

  @override
  String get aiChatStartNewConversation => 'Start a new conversation';

  @override
  String get aiDiagnosisResult => 'Diagnosis Result';

  @override
  String get aiPossibleCauses => 'Possible Causes';

  @override
  String get aiRecommendedService => 'Recommended Service';

  @override
  String get aiNoMatchingService =>
      'No matching service found — please contact the workshop';

  @override
  String get aiGeneratedDisclaimer =>
      'AI-generated answer that may contain errors — a workshop inspection remains the reference';

  @override
  String get aiSeverityLow => 'Low severity';

  @override
  String get aiSeverityMedium => 'Medium severity';

  @override
  String get aiSeverityHigh => 'High severity';

  @override
  String get aiAddServiceToOrder => 'Add service to order';

  @override
  String get aiServiceAddedToOrder => 'Service added to the order';

  @override
  String get aiApplyServiceConfirmTitle => 'Add Service to Order';

  @override
  String aiApplyServiceConfirmBody(Object service) {
    return 'The order\'s current service will be replaced with \"$service\" and its total price recalculated. Do you want to continue?';
  }

  @override
  String get aiServiceAppliedSuccess =>
      'The service was added to the order successfully';

  @override
  String get aiDiagnosisUnavailable =>
      'Diagnosis is unavailable right now, please try again later';

  @override
  String get aiApplyServiceFailed => 'Could not add the service to the order';

  @override
  String get aiConversationLoopError =>
      'Could not complete the conversation, please start a new one';

  @override
  String get aiUnexpectedError => 'An unexpected error occurred';
}
