# Flutter Proguard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }
-keep class io.flutter.im.** { *; }

# Ignore Play Store deferred components warnings
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.**

# Keep Hive classes
-keep class com.hive.** { *; }
-dontwarn com.hive.**
