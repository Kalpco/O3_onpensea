// ignore: depend_on_referenced_packages
import 'package:get_storage/get_storage.dart';
import 'package:http/retry.dart';

class U_StorageUtility {
  static final U_StorageUtility _instance = U_StorageUtility._internal();

  factory U_StorageUtility() {
    return _instance;
  }

  U_StorageUtility._internal();

  final _storage = GetStorage();

//generic method to save data
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  T? readData<T>(String key) {
    return _storage.read(key);
  }

  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  Future<void> clearAll() async {
    await _storage.erase();
  }
}
