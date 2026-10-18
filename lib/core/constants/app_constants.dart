class AppConstants {
  // Collection names
  static const String usersCollection = 'users';
  static const String farmsCollection = 'farms';
  static const String rabbitsCollection = 'rabbits';
  static const String breedingCollection = 'breeding';
  static const String kindlingsCollection = 'kindlings';
  static const String healthRecordsCollection = 'healthRecords';
  static const String vaccinationsCollection = 'vaccinations';
  static const String feedingCollection = 'feeding';
  static const String expensesCollection = 'expenses';
  static const String inventoryCollection = 'inventory';
  static const String salesCollection = 'sales';
  static const String notificationsCollection = 'notifications';

  // Rabbit breeds
  static const List<String> rabbitBreeds = [
    'New Zealand White',
    'Californian',
    'Rex',
    'Flemish Giant',
    'Dutch',
    'Mini Rex',
    'Lionhead',
    'Holland Lop',
    'English Angora',
    'French Angora',
    'Chinchilla',
    'Harlequin',
    'Palomino',
    'Silver Fox',
    'American',
    'Beveren',
    'Checkered Giant',
    'English Spot',
    'Mini Lop',
    'Netherland Dwarf',
    'Polish',
    'Satin',
    'Standard Chinchilla',
    'White Satin',
    'Mixed Breed',
    'Other',
  ];

  // Common rabbit colors
  static const List<String> rabbitColors = [
    'White',
    'Black',
    'Brown',
    'Gray',
    'Spotted',
    'Broken',
    'Agouti',
    'Chinchilla',
    'Tan',
    'Orange',
    'Fawn',
    'Cream',
    'Blue',
    'Lilac',
    'Chocolate',
    'Other',
  ];

  // Feed units
  static const List<String> feedUnits = ['kg', 'g', 'lb', 'lbs', 'pieces', 'bags', 'bales'];

  // Inventory units
  static const List<String> inventoryUnits = [
    'kg', 'g', 'lb', 'lbs', 'ml', 'L', 'pieces', 'bags', 'bales', 'boxes', 'bottles', 'vials'
  ];

  // Gestation period
  static const int gestationDays = 31;

  // Low stock threshold (days before showing alert)
  static const int vaccinationAlertDays = 7;
  static const int medicineExpiryAlertDays = 30;

  // Pagination
  static const int pageSize = 20;

  // Date formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String monthFormat = 'MMM yyyy';
  static const String shortDateFormat = 'dd/MM/yy';

  // Validation
  static const int minPasswordLength = 6;
  static const double minWeight = 0.1;
  static const double maxWeight = 15.0;

  // Breeding methods
  static const List<String> breedingMethods = [
    'Natural',
    'Controlled',
    'Artificial Insemination',
  ];

  // Nest conditions
  static const List<String> nestConditions = ['Excellent', 'Good', 'Fair', 'Poor'];

  // Mother conditions
  static const List<String> motherConditions = ['Excellent', 'Good', 'Fair', 'Poor', 'Critical'];

  // Common symptoms
  static const List<String> commonSymptoms = [
    'Loss of appetite',
    'Weight loss',
    'Lethargy',
    'Diarrhea',
    'Sneezing',
    'Runny nose',
    'Eye discharge',
    'Skin lesions',
    'Hair loss',
    'Swollen abdomen',
    'Difficulty breathing',
    'Limping',
    'Excessive thirst',
    'Paralysis',
    'Other',
  ];

  // Common vaccines
  static const List<String> commonVaccines = [
    'Rabbit Hemorrhagic Disease (RHD)',
    'Myxomatosis',
    'RHD2',
    'Pasteurellosis',
    'Clostridium',
    'Other',
  ];

  // Currency symbol
  static const String currencySymbol = 'PKR';

  // App name
  static const String appName = 'Rabbit Track';
  static const String appTagline = 'Track. Breed. Grow.';
}
