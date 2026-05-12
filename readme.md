Daily Bowl

Daily Bowl is a Flutter application designed for food lovers to explore recipes, track their weekly nutrition, and manage their cooking activity. 
# Features

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
# Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Networking**: Custom API Client (REST) with integrated server validation.
- **Architecture**: Presentation-Controller-Model pattern for high performance and maintainability.

# Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest Stable Version)
- [Dart SDK](https://dart.dev/get-started/sdk)
- **Android Studio** or **VS Code**
- An Emulator or Physical Device (Android/iOS)

# Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/daily_bowl.git
   cd daily_bowl
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

# Setup

## API Configuration
Locate the API client configuration in `lib/core/network/api_client.dart` and update the `DBMS_BASE_URL` to point to your backend server:

```dart
// lib/core/network/api_client.dart
static const String DBMS_BASE_URL = "http://your-server-ip/api";
```
# Running the App

### Using CLI
To run the app on the default connected device:
```bash
flutter run
```

To run in **Release Mode**:
```bash
flutter run --release
```

### Using IDE
1. Open the project in your IDE.
2. Select your target device from the device selector.
3. Press **F5** (VS Code) or the **Run** icon (Android Studio).

# Download the App

Download the App from the Release: 

## Project Structure

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

