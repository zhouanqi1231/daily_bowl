import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';

class GlobalSaveManager extends GetxService {
  final savedIds = <int>{}.obs;

  Future<void> fetchInitialSaves() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? token = prefs.getString('api_key');

    if (userId == null || token == null || token.isEmpty) {
      savedIds.clear();
      return;
    }

    try {
      final response = await ApiClient.get('/users/$userId/saves/');
      if (response is List) {
        savedIds.clear();
        for (var item in response) {
          if (item['recipe_id'] != null) {
            savedIds.add(int.parse(item['recipe_id'].toString()));
          }
        }
      }
    } catch (e) {
      print("Global fetch saves error: $e");
    }
  }

  Future<void> toggleSave(int recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) {
      Get.snackbar('Error', 'Please login to save recipes.');
      return;
    }

    bool isCurrentlySaved = savedIds.contains(recipeId);

    try {
      if (isCurrentlySaved) {
        savedIds.remove(recipeId);
        await ApiClient.delete('/users/$userId/saves/$recipeId/');
      } else {
        savedIds.add(recipeId);
        await ApiClient.post('/users/$userId/saves/', {'recipe_id': recipeId});
      }
    } catch (e) {
      if (isCurrentlySaved) {
        savedIds.add(recipeId);
      } else {
        savedIds.remove(recipeId);
      }
      Get.snackbar('Error', 'Failed to update saved status');
    }
  }
}
