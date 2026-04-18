import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/recipe_creation_model.dart';
import '../../../core/app_export.dart';

class RecipeCreationController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final recipeCreationModel = Rx<RecipeCreationModel?>(null);
  final selectedImage = Rx<File?>(null);
  final ingredientControllers = <Map<String, TextEditingController>>[].obs;

  // Form controllers
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late List<TextEditingController> stepControllers;

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
    stepControllers = List.generate(4, (index) => TextEditingController());

    // Initialize with 2 ingredient rows by default
    addIngredientRow();
    addIngredientRow();
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
      'unit': TextEditingController(),
    });
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
    if (!_validateForm()) {
      return;
    }

    isLoading.value = true;

    try {
      // Simulate recipe creation process
      await Future.delayed(Duration(seconds: 2));

      // Update model with form data
      recipeCreationModel.value?.title?.value = titleController.text.trim();

      // Collect ingredients
      List<Map<String, String>> ingredients = [];
      for (var controllerMap in ingredientControllers) {
        String name = controllerMap['name']!.text.trim();
        String quantity = controllerMap['quantity']!.text.trim();
        String unit = controllerMap['unit']!.text.trim();

        if (name.isNotEmpty && quantity.isNotEmpty && unit.isNotEmpty) {
          ingredients.add({'name': name, 'quantity': quantity, 'unit': unit});
        }
      }

      // Collect steps
      List<String> steps = [];
      for (int i = 0; i < stepControllers.length; i++) {
        String step = stepControllers[i].text.trim();
        if (step.isNotEmpty) {
          steps.add('${i + 1}. $step');
        }
      }

      isLoading.value = false;
      isSuccess.value = true;

      Get.snackbar(
        'Success',
        'Recipe created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.greenCustom,
        colorText: appTheme.whiteCustom,
      );

      // Clear form and navigate back
      _clearForm();
      await Future.delayed(Duration(seconds: 1));
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to create recipe. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.redCustom,
        colorText: appTheme.whiteCustom,
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
