class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // ==================== Cars ====================
  static const String myCars = '/cars/indexClient';
  static const String addCar = '/cars';
  static String carShow(int id) => '/cars/show/$id';
  static String carUpdate(int id) => '/cars/update/$id';
  static String carDelete(int id) => '/cars/delete/$id';
}
