import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/core/routes/route.dart';
import 'package:newsapp/core/theme/app_theme.dart';
import 'package:newsapp/core/theme/theme_cubit.dart';
import 'package:newsapp/features/homescreen/data/repo.dart';
import 'package:newsapp/features/homescreen/data/webservices.dart';
import 'package:newsapp/features/homescreen/logic/cubit/get_news_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();

  final savedtheme = pref.getString('theme');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  GetNewsCubit(Repo(Webservices()))..fetchnews('general'),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(pref: pref, inittheme: savedtheme),
        ),
      ],
      child: MyApp(router: RouterOfPages()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final RouterOfPages router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          onGenerateRoute: router.generator,
        );
      },
    );
  }
}

//---------------

// To delete the
// .gradle/caches folder when files are "in use," you must stop the background processes that are locking them. On Windows, this is typically the Gradle Daemon or the OpenJDK Platform Binary. 
// Step 1: Force Stop All Background Processes
// Run this command in your terminal (VS Code or Command Prompt) to kill every active Java and Gradle process:
// cmd

// taskkill /F /IM java.exe

// Use code with caution.

//     Why? This stops the Gradle Daemon, which is likely the process keeping those 8.10.2 and modules-2 folders open.
//     Alternative: If that doesn't work, run gradlew --stop in your project's android folder to signal a clean shutdown. 

// Step 2: Handle OneDrive Interference
// Since your project is in C:\Users\Basse\OneDrive\Desktop, OneDrive itself might be locking the files while it tries to sync your 2.28 GB cache. 

//     Right-click the OneDrive icon in your taskbar.
//     Select Pause syncing.
//     Try deleting the .gradle/caches folder again.

// Step 3: Delete the Folder
// Once the processes are killed and OneDrive is paused:

//     Navigate to C:\Users\Basse\.gradle.
//     Delete the caches and daemon folders.
//     Restart your computer if Windows still refuses to delete them; a reboot is the fastest way to clear all hidden file locks. 

// Why these folders exist:

//     8.10.2: Contains data specific to the Gradle version you are using.
//     modules-2: This is where all your project's library dependencies (like Flutter plugins) are stored.
//     journal-1: A log that tracks changes to the cache; it often gets corrupted and prevents builds. 

// Important: Deleting these is safe, but your next build will take much longer because Gradle has to re-download everything from scratch. 
// Would you like to know how to prevent OneDrive from syncing your large .gradle folders in the future?






// Since
// explorer.exe is shown as holding a handle to the flutter\bin\cache folder, Windows is treating that folder as "in use" because you have it open in a window or the preview pane is active. 
// To break this lock and allow the update to proceed without deleting the SDK, follow these steps:
// 1. Kill the Locking Handles

//     Close all File Explorer windows that are currently viewing any part of the Flutter SDK or your project.
//     In your Resource Monitor (where you found the handles), right-click each explorer.exe entry that points to the Flutter cache and select End Process.
//         Note: Your taskbar and desktop icons will disappear momentarily. This is normal.
//     In the top menu of Task Manager, go to File -> Run new task, type explorer.exe, and hit Enter to bring your desktop back. 

// 2. Close PowerShell and the IDE 
// Since you saw powershell.exe holding a handle inside your project, it will also block the update. 

//     Close VS Code and any standalone PowerShell or Command Prompt windows.
//     Check Task Manager one more time for any hidden dart.exe or flutter.exe processes and end them. 

// 3. Run the Update from a "Neutral" Terminal 
// Instead of running it inside your project (where PowerShell is locking files), run it from a fresh, administrative terminal:

//     Open PowerShell as Administrator.
//     Do not cd into your project folder.
//     Run the command:
//     powershell

//     flutter doctor

//     Use code with caution.
//     This forces Flutter to finish the Dart SDK download and rename the folder while no project files are active. 

// 4. If it still fails: The "Safe" Rename
// If Windows still refuses the rename, you can manually "help" it:

//     Go to C:\Users\Basse\AppData\Local\flutter\bin\cache\.
//     Manually rename the dart-sdk folder to dart-sdk_old.
//     Run flutter doctor again. It will see the folder is "missing" and download a fresh, correctly named one. Once it works, you can safely delete dart-sdk_old. 

// Did restarting the explorer.exe process or manually renaming the folder allow flutter doctor to finish?