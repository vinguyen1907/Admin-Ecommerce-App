class Utils {
  String getFullAddress(
      {required String street,
      required String state,
      required String city,
      required String country}) {
    return '$street, $city, $state, $country';
  }
}
