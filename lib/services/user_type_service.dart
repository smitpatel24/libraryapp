import 'package:shared_preferences/shared_preferences.dart';

class UserTypeService {
  static final int READER_TYPE = 3;
  static final int ADMIN_TYPE = 2;
  static final int LIBRARIAN_TYPE = 1;

  static Future<int?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userType');
  }

  static Future<bool> isLibrarian() async {
    final userType = await getUserType();
    return userType == LIBRARIAN_TYPE;
  }

  static Future<bool> isAdmin() async {
    final userType = await getUserType();
    return userType == ADMIN_TYPE;
  }
}
