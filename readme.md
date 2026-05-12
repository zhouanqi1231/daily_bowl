<div align="center">

# Daily Bowl

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![GetX](https://img.shields.io/badge/GetX-8C2CE6?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/get)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Daily Bowl is a Flutter application designed for food lovers to explore recipes, track their weekly nutrition, and manage their cooking activity. 

[Explore Features](#-features) • [Installation](#-installation) • [Project Structure](#-project-structure) • [API Setup](#-api-configuration)

</div>

# 1 Features

- Recipe Discovery & Browsing
	- **Explore**: Scroll to discovery recipes.
	- **Categories**: Category browsing (Cuisine types like Italian, Chinese, etc.) with real-time recipe counts.
	- **Detail View**: Rich recipe details including ingredient lists, step-by-step instructions and nutrition composition
	- **Save Recipes**: Save your favorite recipes to a collection.
![](https://github.com/zhouanqi1231/daily_bowl/blob/main/pics/IMG_20260512_172945.jpg?raw=true)
- Personalized Profile & Activity
	- **Activity Heatmap**: A visualization of your cooking, saving, and recipe creation history over the past year.
	- **Recipe Management**: Create, edit, and delete your own recipes from your profile.
	- **Allergy Protection**: Configure your allergies in settings to receive real-time "Allergy Alerts" on any recipe detail page that contains sensitive ingredients.
![](https://github.com/zhouanqi1231/daily_bowl/blob/main/pics/IMG_20260512_175051.jpg?raw=true)
![](https://github.com/zhouanqi1231/daily_bowl/blob/main/pics/IMG_20260512_174941.jpg?raw=true)
- Weekly Nutrition Report
	- **Automatic Summary**: Generates a nutritional summary of your cooking activity for the current week.
	- **Interactive History**: View a list of recipes cooked this week, including cooking times.
	- **Nutritional Analysis**: Visualizes your calorie and macro-nutrient (Protein, Carbs, Fat) consumption using dynamic charts.
# 2 Project Structure

```text
lib/
├── core/               # Global managers (SaveManager), network clients, and app exports
├── theme/              # Centralized styling, color palettes, and text helpers
├── widgets/            # Reusable UI components (RecipeCards, AppBars, Buttons)
├── presentation/       # Screen-specific Logic
│   ├── explore_screen/ # Discovery feed logic
│   ├── category_screen/# Immersive cuisine navigation
│   ├── recipe_detail/  # Interactive recipe actions and allergy logic
│   ├── weekly_report/  # ISO 8601 filtering and nutrition logic
│   └── user_profile/   # Activity tracking and heatmap refactoring
├── routes/             # App routing and named navigation
└── main.dart           # App entry point
```

# 3 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Networking**: Custom API Client (REST) with integrated server validation.
- **Architecture**: Presentation-Controller-Model pattern for high performance and maintainability.

# 4 Installation

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest Stable Version)
- [Dart SDK](https://dart.dev/get-started/sdk)
- **Android Studio** or **VS Code**
- An Emulator or Physical Device (Android/iOS)

To run the project, first clone the repository:

```bash
git clone https://github.com/zhouanqi1231/daily_bowl.git
```

then Install dependencies:

```bash
flutter pub get
```

# 5 API Configuration

Locate the API client configuration in `lib/core/network/api_client.dart` and update the `DBMS_BASE_URL` to point to your backend server:

```dart
// lib/core/network/api_client.dart
static const String DBMS_BASE_URL = "http://your-server-ip/api";
```

❗️It's recommended that you config the server in a local env file.

The documentation of the API we are using: https://34.24.220.134:10013/api/docs/
The source code of the API we are using: https://github.com/TirpitzLing/PWP

# 6 Running the App

## 6.1 CLI
Run the app on the default connected device:
```bash
flutter run
```
## 6.2 IDE
1. Open the project in your IDE.
2. Select your target device from the device selector.
3. Press **F5** (VS Code) or the **Run** icon (Android Studio).

# 7 Download the App

Download the Released Apk from the Release.



