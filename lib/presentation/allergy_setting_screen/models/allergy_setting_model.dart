import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class is used in the [AllergySettingScreen] screen with GetX.
class AllergySettingModel {
  Rx<String>? screenTitle;

  AllergySettingModel({this.screenTitle}) {
    screenTitle = screenTitle ?? Rx("Food Category Selection");
  }
}
