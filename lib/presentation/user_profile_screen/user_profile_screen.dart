import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_recipe_card.dart';
import './controller/user_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  final UserProfileController controller = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: CustomAppBar(
          height: 70.h,
          topPadding: 0.h,
          leadingIcon: ImageConstant.imgMenu,
          onLeadingTap: () => Get.toNamed(AppRoutes.settingsMenuScreen),
          actionIcons: [
            CustomAppBarAction(
              iconPath: ImageConstant.imgShare,
              onTap: () => controller.onSharePressed(),
            ),
          ],
          backgroundColor: appTheme.white_A700,
          horizontalPadding: 16.h,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshUserProfile(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserProfileSection(),
              _buildActivityCalendarSection(),
              _buildWeeklyReportBanner(),
              _buildMyRecipesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      width: double.infinity,
      color: appTheme.white_A700,
      padding: EdgeInsets.fromLTRB(24.h, 4.h, 24.h, 16.h),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgGenericAvatar,
            height: 104.h,
            width: 104.h,
            radius: BorderRadius.circular(52.h),
            border: Border.all(
              color: appTheme.deep_purple_800,
              width: 1.h,
            ),
            margin: EdgeInsets.only(top: 6.h),
          ),
          SizedBox(width: 32.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.userProfileModel.value?.userName?.value ??
                        "Amy Perkins",
                    style: TextStyleHelper.instance.headline28RegularRoboto,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Obx(
                      () => Text(
                        "${controller.userProfileModel.value?.recipeCount?.value ?? 0} Recipes",
                        style: TextStyleHelper.instance.body14MediumRoboto
                            .copyWith(color: appTheme.blue_gray_400),
                      ),
                    ),
                    SizedBox(width: 24.h),
                    Obx(
                      () => Text(
                        "${controller.userProfileModel.value?.saveCount?.value ?? 0} Saves",
                        style: TextStyleHelper.instance.body14MediumRoboto
                            .copyWith(color: appTheme.blue_gray_400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCalendarSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 10.h, 16.h, 0),
      padding: EdgeInsets.fromLTRB(14.h, 8.h, 14.h, 8.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.gray_300,
            offset: Offset(0, 1),
            blurRadius: 4.h,
          ),
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: controller.heatmapScrollController,
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              final data = controller.activityData;
              final today = DateTime.now();
              final firstDayOfYear = DateTime(today.year, 1, 1);
              
              int startOffset = firstDayOfYear.weekday % 7;
              DateTime startDate = firstDayOfYear.subtract(Duration(days: startOffset));

              List<List<DateTime>> weeks = [];
              List<DateTime> currentWeek = [];
              DateTime iter = startDate;

              final lastDayOfYear = DateTime(today.year, 12, 31);
              while (iter.isBefore(lastDayOfYear) || (iter.year == lastDayOfYear.year && iter.month == lastDayOfYear.month && iter.day == lastDayOfYear.day)) {
                currentWeek.add(iter);
                if (currentWeek.length == 7) {
                  weeks.add(currentWeek);
                  currentWeek = [];
                }
                iter = iter.add(Duration(days: 1));
              }
              if (currentWeek.isNotEmpty) {
                DateTime fillIter = currentWeek.last.add(Duration(days: 1));
                while (currentWeek.length < 7) {
                  currentWeek.add(fillIter);
                  fillIter = fillIter.add(Duration(days: 1));
                }
                weeks.add(currentWeek);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  _buildDynamicMonthLabels(weeks, today),
                  SizedBox(height: 4.h),
                  Stack(
                    children: [
                      _buildHeatMapGridFromWeeks(weeks, data, today),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: MonthBorderPainter(
                              weeks: weeks,
                              cellSize: 16.h,
                              cellMargin: 1.h,
                              today: today,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],
              );
            }),
          ),
          Obx(() => _buildActivityPopup()),
        ],
      ),
    );
  }

  Widget _buildActivityPopup() {
    if (controller.popupDate.value == null || controller.popupActivity.value == null) {
      return SizedBox.shrink();
    }

    final date = controller.popupDate.value!;
    final activity = controller.popupActivity.value!;
    String dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: controller.showPopup.value ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          width: 140.h,
          padding: EdgeInsets.all(8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.h),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.h,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: appTheme.gray_200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateStr,
                style: TextStyleHelper.instance.label11MediumRoboto.copyWith(
                  color: appTheme.blue_gray_400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(height: 8.h, thickness: 0.5.h),
              _buildPopupRow(Icons.create, "Created: ${activity.created}"),
              _buildPopupRow(Icons.bookmark, "Saved: ${activity.saved}"),
              _buildPopupRow(Icons.restaurant, "Cooked: ${activity.cooked}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(icon, size: 10.h, color: appTheme.deep_purple_800),
          SizedBox(width: 4.h),
          Text(
            text,
            style: TextStyleHelper.instance.label11MediumRoboto.copyWith(
              fontSize: 10.h,
              color: appTheme.gray_700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicMonthLabels(List<List<DateTime>> weeks, DateTime today) {
    Map<int, int> monthStartWeeks = {};
    for (int i = 0; i < weeks.length; i++) {
      for (var day in weeks[i]) {
        if (day.year == today.year) {
          if (!monthStartWeeks.containsKey(day.month)) {
            monthStartWeeks[day.month] = i;
          }
          break;
        }
      }
    }

    List<int> sortedMonths = monthStartWeeks.keys.toList()..sort();
    double weekColumnWidth = 18.h; 

    return Container(
      height: 18.h,
      width: weeks.length * weekColumnWidth,
      child: Stack(
        children: sortedMonths.map((m) {
          return Positioned(
            left: monthStartWeeks[m]! * weekColumnWidth,
            child: _buildMonthLabel(_getMonthName(m)),
          );
        }).toList(),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildHeatMapGridFromWeeks(List<List<DateTime>> weeks, Map<DateTime, DailyActivity> data, DateTime today) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeks.map((week) {
        return Column(
          children: week.map((date) {
            final day = DateTime(date.year, date.month, date.day);
            bool isCurrentYear = day.year == today.year;
            bool isNotFuture = !day.isAfter(today);
            
            final activity = data[day] ?? DailyActivity();
            final score = (isCurrentYear && isNotFuture) ? activity.total : -1;
            
            return GestureDetector(
              onTap: score != -1 ? () => controller.onActivityTap(day, activity) : null,
              child: Obx(() {
                bool isSelected = controller.popupDate.value == day && controller.showPopup.value;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 16.h,
                  height: 16.h,
                  margin: EdgeInsets.all(1.h),
                  decoration: BoxDecoration(
                    color: _getHeatMapColor(score),
                    borderRadius: BorderRadius.circular(0.h),
                    border: Border.all(
                      color: isSelected ? appTheme.blue_gray_400 : Colors.transparent,
                      width: 1.8.h,
                    ),
                  ),
                );
              }),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Color _getHeatMapColor(int score) {
    if (score == -1) return Colors.transparent;
    if (score == 0) return Color(0xB0F3F3F3);
    if (score <= 1) return Color(0xFFACAAFF);
    if (score <= 3) return Color(0xFF7A56FF);
    return Color(0xFF5609C8);
  }

  Widget _buildMonthLabel(String month) {
    return Text(month, style: TextStyleHelper.instance.profileHeatMapMonthLabel);
  }

  Widget _buildWeeklyReportBanner() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.weeklyNutritionReportScreen),
      child: Container(
        width: double.infinity,
        height: 80.h,
        margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgCoverImage,
                width: double.infinity,
                height: 80.h,
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              Text(
                "Check Your Weekly Report!",
                style:
                    TextStyleHelper.instance.headline24RegularRozhaOne.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(0, 2),
                      blurRadius: 4.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyRecipesSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              "My Recipes",
              style: TextStyleHelper.instance.headline24RegularRoboto,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Column(
              children: List.generate(
                controller.userProfileModel.value?.recipes?.length ?? 0,
                (index) {
                  final recipe =
                      controller.userProfileModel.value?.recipes?[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Slidable(
                      key: ValueKey(recipe?.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.45,
                        children: [
                          SlidableAction(
                            onPressed: (context) => controller.onEditRecipe(index),
                            backgroundColor: Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                            borderRadius: BorderRadius.circular(12.h),
                          ),
                          SlidableAction(
                            onPressed: (context) => controller.onDeleteRecipe(index),
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                            borderRadius: BorderRadius.circular(12.h),
                          ),
                        ],
                      ),
                      child: CustomRecipeCard(
                        title:
                            recipe?.title?.value ?? "Stir-fried Tomato and Eggs",
                        description: recipe?.description?.value ??
                            "This is a simple and classic dish ...",
                        imagePath:
                            recipe?.imagePath?.value ?? ImageConstant.imgMedia,
                        onTap: () => controller.onRecipeTap(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthBorderPainter extends CustomPainter {
  final List<List<DateTime>> weeks;
  final double cellSize;
  final double cellMargin;
  final DateTime today;

  MonthBorderPainter({
    required this.weeks,
    required this.cellSize,
    required this.cellMargin,
    required this.today,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final step = cellSize + cellMargin * 2;

    for (int month = 1; month <= 12; month++) {
      Path path = Path();
      List<Offset> points = [];

      List<Point<int>> monthCells = [];
      for (int x = 0; x < weeks.length; x++) {
        for (int y = 0; y < weeks[x].length; y++) {
          if (weeks[x][y].month == month && weeks[x][y].year == today.year) {
            monthCells.add(Point(x, y));
          }
        }
      }

      if (monthCells.isEmpty) continue;

      _drawDashedMonthBorder(canvas, monthCells, step, paint);
    }
  }

  void _drawDashedMonthBorder(Canvas canvas, List<Point<int>> cells, double step, Paint paint) {
    final Set<String> cellSet = Set.from(cells.map((c) => "${c.x},${c.y}"));
    
    List<Line> edges = [];
    for (var cell in cells) {
      if (!cellSet.contains("${cell.x},${cell.y - 1}")) {
        edges.add(Line(Offset(cell.x * step, cell.y * step), Offset((cell.x + 1) * step, cell.y * step)));
      }
      if (!cellSet.contains("${cell.x},${cell.y + 1}")) {
        edges.add(Line(Offset(cell.x * step, (cell.y + 1) * step), Offset((cell.x + 1) * step, (cell.y + 1) * step)));
      }
      if (!cellSet.contains("${cell.x - 1},${cell.y}")) {
        edges.add(Line(Offset(cell.x * step, cell.y * step), Offset(cell.x * step, (cell.y + 1) * step)));
      }
      if (!cellSet.contains("${cell.x + 1},${cell.y}")) {
        edges.add(Line(Offset((cell.x + 1) * step, cell.y * step), Offset((cell.x + 1) * step, (cell.y + 1) * step)));
      }
    }

    for (var edge in edges) {
      _drawDashedLine(canvas, edge.p1, edge.p2, paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    
    double distance = (p2 - p1).distance;
    Offset direction = (p2 - p1) / distance;
    double currentDistance = 0;
    
    while (currentDistance < distance) {
      double endDist = currentDistance + dashWidth;
      if (endDist > distance) endDist = distance;
      canvas.drawLine(
        p1 + direction * currentDistance,
        p1 + direction * endDist,
        paint,
      );
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Point<T> {
  final T x, y;
  Point(this.x, this.y);
}

class Line {
  final Offset p1, p2;
  Line(this.p1, this.p2);
}
