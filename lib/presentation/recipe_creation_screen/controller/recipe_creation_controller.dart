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
  

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    recipeCreationModel.value = RecipeCreationModel();
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
    
    // Initialize with 1 ingredient row by default
    addIngredientRow();
    
    // Initialize with 1 step row by default
    addStepRow();
  }

  void _disposeControllers() {
    titleController.dispose();
    for (var controller in stepControllers) {
      controller.dispose();
    }
    for (var controllerMap in ingredientControllers) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }
  }

  void addIngredientRow() {
    ingredientControllers.add({
      'name': TextEditingController(),
      'quantity': TextEditingController(),
      'unit': TextEditingController(text: 'g'), // Default unit to 'g'
    });
  }

  void addStepRow() {
    stepControllers.add(TextEditingController());
  }

  Future<void> pickImage() async {
    try {
      // Request camera permission
      var cameraStatus = await Permission.camera.request();
      var storageStatus = await Permission.storage.request();

      if (cameraStatus.isGranted || storageStatus.isGranted) {
        // Show dialog to choose between camera and gallery
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
            source: result == 'camera'
                ? ImageSource.camera
                : ImageSource.gallery,
            maxWidth: 800,
            maxHeight: 800,
            imageQuality: 85,
          );

          if (pickedFile != null) {
            selectedImage.value = File(pickedFile.path);
            recipeCreationModel.value?.imagePath?.value = pickedFile.path;
          }
        }
      } else {
        Get.snackbar(
          'Permission Required',
          'Camera and storage permissions are needed to add photos',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a recipe title';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  String? validateIngredientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter ingredient name';
    }
    return null;
  }

  String? validateIngredientQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter quantity';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateIngredientUnit(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter unit';
    }
    if (value != 'g' && value != 'ml') {
      return 'Invalid unit';
    }
    return null;
  }

  String? validateStep(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter step instruction';
    }
    if (value.trim().length < 10) {
      return 'Step instruction should be more detailed';
    }
    return null;
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Check if at least one ingredient is filled
    bool hasIngredient = false;
    for (var controllerMap in ingredientControllers) {
      if (controllerMap['name']!.text.trim().isNotEmpty &&
          controllerMap['quantity']!.text.trim().isNotEmpty &&
          controllerMap['unit']!.text.trim().isNotEmpty) {
        hasIngredient = true;
        break;
      }
    }

    if (!hasIngredient) {
      Get.snackbar(
        'Incomplete Recipe',
        'Please add at least one complete ingredient',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Check if at least one step is filled
    bool hasStep = false;
    for (var controller in stepControllers) {
      if (controller.text.trim().isNotEmpty) {
        hasStep = true;
        break;
      }
    }

    if (!hasStep) {
      Get.snackbar(
        'Incomplete Recipe',
        'Please add at least one step instruction',
        snackPosition: SnackPosition.BOTTOM,
      );
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
      };

      final recipeResponse = await ApiClient.post('/recipes/', recipePayload);
      
      String? recipeLoc = recipeResponse?['location'];
      if (recipeLoc == null) throw Exception("No Location header returned from API.");
      
      int recipeId = int.parse(recipeLoc.split('/').lastWhere((e) => e.isNotEmpty));
      print("Extracted Recipe ID: $recipeId");

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
            
            try {
              await ApiClient.post('/recipes/$recipeId/ingredients/', bindingPayload);
              print("Bound ingredient $ingredientId to recipe $recipeId");
            } catch (e) {
              print("Ingredient binding warning (maybe duplicate): $e");
            }
          }
        }
      }

      isLoading.value = false;
      isSuccess.value = true;

      Get.snackbar(
        'Success', 
        'Recipe created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().refreshUserProfile();
      }
      if (Get.isRegistered<ExploreController>()) {
         Get.find<ExploreController>().refreshData(); 
      }

      _clearForm();
      await Future.delayed(Duration(milliseconds: 800));
      Get.back();

    } catch (e) {
      isLoading.value = false;
      print("Create Recipe Error: $e");
      Get.snackbar(
        'Error', 
        'Failed to create recipe. Check console.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  void discardRecipe() {
    Get.dialog(
      AlertDialog(
        title: Text('Discard Recipe?'),
        content: Text(
          'Are you sure you want to discard this recipe? All changes will be lost.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              _clearForm();
              Get.back();
            },
            child: Text('Discard'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    titleController.clear();
    cuisineTypeController.clear();
    servingsController.clear();
    cookingMethodController.clear();
    for (var controller in stepControllers) {
      controller.clear();
    }
    for (var controllerMap in ingredientControllers) {
      controllerMap.values.forEach((controller) => controller.clear());
    }
    selectedImage.value = null;
    recipeCreationModel.value = RecipeCreationModel();
  }
}
