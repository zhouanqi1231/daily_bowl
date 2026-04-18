import '../models/allergy_setting_model.dart';
import '../models/allergy_item_model.dart';
import '../../../core/app_export.dart';

class AllergySettingController extends GetxController {
  Rx<AllergySettingModel> allergySettingModelObj = AllergySettingModel().obs;

  RxList<AllergyItemModel> allergyItems = <AllergyItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAllergyItems();
  }

  void _initializeAllergyItems() {
    allergyItems.value = [
      AllergyItemModel(name: "Nuts".obs, isSelected: false.obs),
      AllergyItemModel(name: "Nuts".obs, isSelected: false.obs),
      AllergyItemModel(name: "Nuts".obs, isSelected: false.obs),
      AllergyItemModel(name: "Seeds".obs, isSelected: false.obs),
      AllergyItemModel(name: "Fruits".obs, isSelected: false.obs),
      AllergyItemModel(name: "Grains".obs, isSelected: false.obs),
    ];
  }

  void toggleAllergy(int index, bool value) {
    if (index >= 0 && index < allergyItems.length) {
      allergyItems[index].isSelected?.value = value;
      allergyItems.refresh();
    }
  }

  void saveAllergySettings() {
    List<String> selectedAllergies = [];
    for (var item in allergyItems) {
      if (item.isSelected?.value ?? false) {
        selectedAllergies.add(item.name?.value ?? "");
      }
    }

    // Save selected allergies to preferences or send to API
    Get.snackbar(
      "Settings Saved",
      "Your allergy preferences have been updated",
      backgroundColor: appTheme.deep_purple_800,
      colorText: appTheme.whiteCustom,
      duration: Duration(seconds: 2),
    );
  }

  List<String> getSelectedAllergies() {
    return allergyItems
        .where((item) => item.isSelected?.value ?? false)
        .map((item) => item.name?.value ?? "")
        .toList();
  }
}
