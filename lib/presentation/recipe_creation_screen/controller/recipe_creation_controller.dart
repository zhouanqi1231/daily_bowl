import 'package:daily_bowl/presentation/explore_screen/controller/explore_controller.dart';
import 'package:daily_bowl/presentation/user_profile_screen/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/network/api_client.dart';
import '../models/recipe_creation_model.dart';
import '../../../core/app_export.dart';

class RecipeCreationController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final recipeCreationModel = Rx<RecipeCreationModel?>(null);
  final selectedImage = Rx<File?>(null);
  final ingredientControllers = <Map<String, TextEditingController>>[].obs;
  final stepControllers = <TextEditingController>[].obs;

  // Form controllers
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController cuisineTypeController;
  late TextEditingController servingsController;
  late TextEditingController cookingMethodController;
  late TextEditingController imageUrlController;

  // List of all ingredients from server for suggestions
  final allIngredients = <String>[].obs;

  // Edit mode variables
  final isEditMode = false.obs;
  int? recipeId;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    recipeCreationModel.value = RecipeCreationModel();
    _fetchIngredients();
    
    // Check for edit mode
    if (Get.arguments != null && Get.arguments['id'] != null) {
      isEditMode.value = true;
      recipeId = Get.arguments['id'];
      _loadRecipeData(recipeId!);
    }
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    titleController = TextEditingController();
    cuisineTypeController = TextEditingController();
    servingsController = TextEditingController();
    cookingMethodController = TextEditingController();
    imageUrlController = TextEditingController();
    
    // Initialize with 1 ingredient row by default
    addIngredientRow();
    
    // Initialize with 1 step row by default
    addStepRow();
  }

  void _disposeControllers() {
    titleController.dispose();
    cuisineTypeController.dispose();
    servingsController.dispose();
    cookingMethodController.dispose();
    imageUrlController.dispose();
    for (var controller in stepControllers) {
      controller.dispose();
    }
    for (var controllerMap in ingredientControllers) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }
  }

  Future<void> _fetchIngredients() async {
    try {
      final response = await ApiClient.get('/ingredients/');
      if (response is List) {
        allIngredients.value = response
            .map((e) => e['name']?.toString() ?? "")
            .where((name) => name.isNotEmpty)
            .toList();
      }
    } catch (e) {
      print("Error fetching ingredients for suggestions: $e");
    }
  }

  Future<void> _loadRecipeData(int id) async {
    isLoading.value = true;
    try {
      final recipe = await ApiClient.get('/recipes/$id/');
      titleController.text = recipe['title'] ?? '';
      cuisineTypeController.text = recipe['cuisine_type'] ?? '';
      servingsController.text = (recipe['servings'] ?? 1).toString();
      cookingMethodController.text = recipe['cooking_method'] ?? '';
      imageUrlController.text = recipe['img_url'] ?? '';

      // Load steps
      String procedure = recipe['procedure'] ?? '';
      if (procedure.isNotEmpty) {
        stepControllers.clear();
        List<String> steps = procedure.split('\n');
        for (var step in steps) {
          // Remove "1. " numbering if present
          String cleanStep = step.replaceFirst(RegExp(r'^\d+\.\s*'), '');
          if (cleanStep.isNotEmpty) {
            stepControllers.add(TextEditingController(text: cleanStep));
          }
        }
      }

      // Load ingredients
      final ingredientsData = await ApiClient.get('/recipes/$id/ingredients/');
      if (ingredientsData is List && ingredientsData.isNotEmpty) {
        ingredientControllers.clear();
        for (var item in ingredientsData) {
          String ingredientName = '';
          int? ingredientId = item['ingredient_id'];
          if (ingredientId != null) {
            try {
              final ingDetail = await ApiClient.get('/ingredients/$ingredientId/');
              ingredientName = ingDetail['name']?.toString() ?? '';
            } catch (_) {}
          }
          ingredientControllers.add({
            'name': TextEditingController(text: ingredientName),
            'quantity': TextEditingController(text: (item['amount'] ?? '').toString()),
            'unit': TextEditingController(text: item['unit'] ?? 'g'),
          });
        }
      }
    } catch (e) {
      print("Error loading recipe for edit: $e");
      Get.snackbar('Error', 'Failed to load recipe details');
    } finally {
      isLoading.value = false;
    }
  }

  void addIngredientRow() {
    ingredientControllers.add({
      'name': TextEditingController(),
      'quantity': TextEditingController(),
      'unit': TextEditingController(text: 'g'),
    });
  }

  void addStepRow() {
    stepControllers.add(TextEditingController());
  }

  void onUploadClicked() {
    pickImage();
  }

  Future<void> pickImage() async {
    try {
      var cameraStatus = await Permission.camera.request();
      var storageStatus = await Permission.storage.request();

      if (cameraStatus.isGranted || storageStatus.isGranted) {
        final result = await Get.dialog<String>(
          AlertDialog(
            title: Text('Select Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () => Get.back(result: 'camera'),
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () => Get.back(result: 'gallery'),
                ),
              ],
            ),
          ),
        );

        if (result != null) {
          final XFile? pickedFile = await _imagePicker.pickImage(
            source: result == 'camera' ? ImageSource.camera : ImageSource.gallery,
            maxWidth: 800,
            maxHeight: 800,
            imageQuality: 85,
          );

          if (pickedFile != null) {
            selectedImage.value = File(pickedFile.path);
            recipeCreationModel.value?.imagePath?.value = pickedFile.path;
            imageUrlController.clear();
          }
        }
      } else {
        Get.snackbar('Permission Required', 'Camera and storage permissions are needed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter a recipe title';
    if (value.trim().length < 3) return 'Title must be at least 3 characters';
    return null;
  }

  String? validateIngredientName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter ingredient name';
    return null;
  }

  String? validateIngredientQuantity(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter quantity';
    if (double.tryParse(value) == null) return 'Please enter a valid number';
    return null;
  }

  String? validateStep(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter step instruction';
    if (value.trim().length < 5) return 'Step instruction too short';
    return null;
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    bool hasIngredient = ingredientControllers.any((c) => 
      c['name']!.text.trim().isNotEmpty && c['quantity']!.text.trim().isNotEmpty);

    if (!hasIngredient) {
      Get.snackbar('Incomplete Recipe', 'Please add at least one complete ingredient');
      return false;
    }

    bool hasStep = stepControllers.any((c) => c.text.trim().isNotEmpty);
    if (!hasStep) {
      Get.snackbar('Incomplete Recipe', 'Please add at least one step instruction');
      return false;
    }

    return true;
  }

  void confirmRecipe() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      String procedureStr = stepControllers
          .map((c) => c.text.trim())
          .where((step) => step.isNotEmpty)
          .toList()
          .asMap()
          .entries
          .map((e) => "${e.key + 1}. ${e.value}")
          .join('\n');

      final recipePayload = {
        'title': titleController.text.trim(),
        'cuisine_type': cuisineTypeController.text.trim(),
        'servings': int.tryParse(servingsController.text.trim()) ?? 1,
        'cooking_method': cookingMethodController.text.trim(),
        'procedure': procedureStr,
        'description': '', 
        'img_url': imageUrlController.text.trim(),
      };

      dynamic recipeResponse;
      int currentRecipeId;

      if (isEditMode.value) {
        await ApiClient.put('/recipes/$recipeId/', recipePayload);
        currentRecipeId = recipeId!;
        // Delete old ingredients to replace with new ones
        try {
           await ApiClient.delete('/recipes/$currentRecipeId/ingredients/');
        } catch (e) {
          print("Warning deleting old ingredients: $e");
        }
      } else {
        recipeResponse = await ApiClient.post('/recipes/', recipePayload);
        String? recipeLoc = recipeResponse?['location'];
        if (recipeLoc == null) throw Exception("No Location header returned from API.");
        currentRecipeId = int.parse(recipeLoc.split('/').lastWhere((e) => e.isNotEmpty));
      }

      for (var controllerMap in ingredientControllers) {
        String name = controllerMap['name']!.text.trim();
        String quantityStr = controllerMap['quantity']!.text.trim();
        String unit = controllerMap['unit']!.text.trim();

        if (name.isNotEmpty && quantityStr.isNotEmpty) {
          double amount = double.tryParse(quantityStr) ?? 0.0;
          final ingredientResponse = await ApiClient.post('/ingredients/', {'name': name});
          
          String? ingredientLoc = ingredientResponse?['location'];
          if (ingredientLoc != null) {
            int ingredientId = int.parse(ingredientLoc.split('/').lastWhere((e) => e.isNotEmpty));
            final bindingPayload = {
              'ingredient_id': ingredientId,
              'amount': amount,
              'unit': unit,
            };
            await ApiClient.post('/recipes/$currentRecipeId/ingredients/', bindingPayload);
          }
        }
      }

      isLoading.value = false;
      isSuccess.value = true;

      Get.snackbar('Success', isEditMode.value ? 'Recipe updated!' : 'Recipe created!');

      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().refreshUserProfile();
      }
      if (Get.isRegistered<ExploreController>()) {
         Get.find<ExploreController>().refreshData(); 
      }

      Get.offNamed(AppRoutes.recipeDetailScreen, arguments: {'id': currentRecipeId});

    } catch (e) {
      isLoading.value = false;
      print("Error saving recipe: $e");
      Get.snackbar('Error', 'Failed to save recipe');
    }
  }

  void discardRecipe() {
    Get.dialog(
      AlertDialog(
        title: Text(isEditMode.value ? 'Discard Changes?' : 'Discard Recipe?'),
        content: Text('Are you sure you want to discard? All unsaved changes will be lost.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: Text('Discard'),
          ),
        ],
      ),
    );
  }
}
