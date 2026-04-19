import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import '../../widgets/custom_image_view.dart';
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
        title: Text("Create a Recipe", style: TextStyleHelper.instance.title22RegularRoboto),
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
                  padding: EdgeInsets.fromLTRB(14.h, 18.h, 14.h, 0),
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
          height: 148.h,
          padding: EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(width: 2.h, color: appTheme.gray_500),
            borderRadius: BorderRadius.circular(18.h),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.selectedImage.value != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.h),
                  child: Image.file(
                    controller.selectedImage.value!,
                    width: double.infinity,
                    height: 148.h,
                    fit: BoxFit.cover,
                  ),
                )
              else
                CustomImageView(
                  imagePath: ImageConstant.imgIconGray500,
                  height: 32.h,
                  width: 32.h,
                ),
            ],
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
                int index = entry.key;
                var controllers = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomFloatingTextField(
                          placeholder: "Ingredient name",
                          controller: controllers['name'],
                          validator: controller.validateIngredientName,
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
                        ),
                      ),
                      SizedBox(width: 10.h),
                      SizedBox(
                        width: 70.h,
                        child: CustomFloatingTextField(
                          placeholder: "unit",
                          controller: controllers['unit'],
                          validator: controller.validateIngredientUnit,
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
        ...List.generate(4, (index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: CustomFloatingTextField(
              placeholder: "${index + 1}.",
              controller: controller.stepControllers[index],
              validator: controller.validateStep,
              maxLines: 3,
            ),
          );
        }),
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
