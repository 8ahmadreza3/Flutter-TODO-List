# Flutter To-Do List App

A modern and intuitive To-Do List application built with Flutter, designed to help you organize and manage your daily tasks efficiently.

## Features

- 📝 Create, edit, and delete tasks
- ✅ Mark tasks as complete/incomplete
- 📅 Task organization and management
- 🎨 Clean and modern user interface
- 📱 Responsive design for both mobile and web
- 💾 Local data persistence


## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator (for testing)

### Installation

1. Clone the repository

2. Navigate to the project directory:
```bash
cd to-do-list
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── task.dart
├── screens/
│   ├── home_screen.dart
│   └── add_task_screen.dart
├── widgets/
│   └── task_tile.dart
└── utils/
    └── database_helper.dart
```

## Dependencies

- [sqflite](https://pub.dev/packages/sqflite) - For local database storage
- [provider](https://pub.dev/packages/provider) - For state management
- [intl](https://pub.dev/packages/intl) - For date formatting


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
