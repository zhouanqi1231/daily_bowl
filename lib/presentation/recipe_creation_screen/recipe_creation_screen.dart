import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import './controller/recipe_creation_controller.dart';

class RecipeCreationScreen extends GetWidget<RecipeCreationController> {
  const RecipeCreationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      appBar: AppBar(
        backgroundColor: appTheme.white_A700,
        elevation: 0,
        title: Text("Create a Recipe",
            style: TextStyleHelper.instance.title22RegularRoboto),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appTheme.blackCustom),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        top: false, // AppBar handles top safety
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.h, 18.h, 24.h, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPhotoUploadSection(),
                          SizedBox(height: 20.h),
                          _buildTitleField(),
                          SizedBox(height: 20.h),
                          _buildDetailsSection(),
                          SizedBox(height: 20.h),
                          _buildIngredientsSection(),
                          SizedBox(height: 12.h),
                          _buildStepsSection(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.pickImage(),
        child: Container(
          width: double.infinity,
          height: 180.h,
          decoration: BoxDecoration(
            color: appTheme.gray_50,
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.h),
            child: controller.selectedImage.value != null
                ? Image.file(
                    controller.selectedImage.value!,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.h),
                        decoration: BoxDecoration(
                          color: appTheme.white_A700,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: appTheme.gray_500,
                          size: 32.h,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Add a photo",
                        style: TextStyleHelper.instance.body14MediumRoboto
                            .copyWith(color: appTheme.gray_500),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return CustomFloatingTextField(
      placeholder: "Title",
      controller: controller.titleController,
      validator: controller.validateTitle,
      onChanged: (value) =>
          controller.recipeCreationModel.value?.title?.value = value,
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            "Recipe Details",
            style: TextStyleHelper.instance.title22RegularRoboto,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: CustomFloatingTextField(
                placeholder: "Cuisine Type",
                controller: controller.cuisineTypeController,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
              ),
            ),
            SizedBox(width: 10.h),
            SizedBox(
              width: 100.h,
              child: CustomFloatingTextField(
                placeholder: "Servings",
                controller: controller.servingsController,
                keyboardType: TextInputType.number,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CustomFloatingTextField(
          placeholder: "Cooking Method (e.g. Frying, Steaming)",
          controller: controller.cookingMethodController,
          textStyle: TextStyleHelper.instance.body14RegularRoboto
              .copyWith(color: appTheme.gray_900),
          labelStyle: TextStyleHelper.instance.body14RegularRoboto
              .copyWith(color: appTheme.gray_600),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            "Ingredients",
            style: TextStyleHelper.instance.title22RegularRoboto,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Column(
            children: [
              ...controller.ingredientControllers.asMap().entries.map((entry) {
                var controllers = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomFloatingTextField(
                          placeholder: "Name",
                          controller: controllers['name'],
                          validator: controller.validateIngredientName,
                          textStyle: TextStyleHelper
                              .instance.body14RegularRoboto
                              .copyWith(color: appTheme.gray_900),
                          labelStyle: TextStyleHelper
                              .instance.body14RegularRoboto
                              .copyWith(color: appTheme.gray_600),
                        ),
                      ),
                      SizedBox(width: 10.h),
                      SizedBox(
                        width: 70.h,
                        child: CustomFloatingTextField(
                          placeholder: "number",
                          controller: controllers['quantity'],
                          keyboardType: CustomFloatingTextField.getKeyboardType(
                            "NUMBER_ONLY",
                          ),
                          inputFormatters:
                              CustomFloatingTextField.getInputFormatters(
                            "NUMBER_ONLY",
                          ),
                          validator: controller.validateIngredientQuantity,
                          textStyle: TextStyleHelper
                              .instance.body14RegularRoboto
                              .copyWith(color: appTheme.gray_900),
                          labelStyle: TextStyleHelper
                              .instance.body14RegularRoboto
                              .copyWith(color: appTheme.gray_600),
                        ),
                      ),
                      SizedBox(width: 10.h),
                      SizedBox(
                        width: 90.h,
                        child: DropdownButtonFormField<String>(
                          value: controllers['unit']!.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.h,
                              vertical: 12.h,
                            ),
                            filled: true,
                            fillColor: appTheme.gray_50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.h),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyleHelper.instance.body14RegularRoboto
                              .copyWith(color: appTheme.gray_900),
                          items: ["g", "ml"]
                              .map((unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controllers['unit']!.text = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        CustomButton(
          text: "Add more ingredients",
          width: double.infinity,
          backgroundColor: appTheme.deep_purple_50,
          textColor: appTheme.blue_gray_800,
          leftIcon: ImageConstant.imgIconBlueGray800,
          onPressed: () => controller.addIngredientRow(),
        ),
      ],
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            "Steps",
            style: TextStyleHelper.instance.title22RegularRoboto,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Column(
            children: [
              ...controller.stepControllers.asMap().entries.map((entry) {
                int index = entry.key;
                var stepController = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: CustomFloatingTextField(
                    placeholder: "${index + 1}.",
                    controller: stepController,
                    validator: controller.validateStep,
                    textStyle: TextStyleHelper.instance.body14RegularRoboto
                        .copyWith(color: appTheme.gray_900),
                    labelStyle: TextStyleHelper.instance.body14RegularRoboto
                        .copyWith(color: appTheme.gray_600),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        CustomButton(
          text: "Add more steps",
          width: double.infinity,
          backgroundColor: appTheme.deep_purple_50,
          textColor: appTheme.blue_gray_800,
          leftIcon: ImageConstant.imgIconBlueGray800,
          onPressed: () => controller.addStepRow(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.h, 16.h, 24.h, 16.h),
      decoration: BoxDecoration(color: appTheme.white_A700),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "Discard",
              width: double.infinity,
              backgroundColor: appTheme.gray_700,
              textColor: appTheme.white_A700,
              onPressed: () => controller.discardRecipe(),
            ),
          ),
          SizedBox(width: 20.h),
          Expanded(
            child: Obx(
              () => CustomButton(
                text: "Confirm",
                width: double.infinity,
                backgroundColor: appTheme.deep_purple_800,
                textColor: appTheme.white_A700,
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.confirmRecipe(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
