class Formatters {
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("+94")) {
      // ignore: prefer_interpolation_to_compose_strings
      return '0' + phoneNumber.substring(3);
    } else if(phoneNumber.startsWith("0")){
      // ignore: prefer_interpolation_to_compose_strings
      return '+94' + phoneNumber.substring(1);
    }

    return phoneNumber;
  }

  //format date
  static String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2,'0')}';
  }
}