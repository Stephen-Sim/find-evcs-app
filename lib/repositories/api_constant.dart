class APIConstant {
  static const String URL = "http://10.131.73.238:8080/find-evcs-api/public/api/";

  static String get ADMIN_LOGIN_URL => "${APIConstant.URL}admin/login";

  static String get GET_STATION_URL => "${APIConstant.URL}station/get/";
  static String get STORE_STATION_URL => "${APIConstant.URL}station/store";
  static String get EDIT_STATION_URL => "${APIConstant.URL}station/edit";
  static String get DELETE_STATION_URL => "${APIConstant.URL}station/delete/";

  static String get GET_NEAR_BY_STATION_URL => "${APIConstant.URL}station/getNearByStations";

  static String get GET_REVIEW_URL => "${APIConstant.URL}review/get/";
  static String get STORE_REVIEW_URL => "${APIConstant.URL}review/store";
}