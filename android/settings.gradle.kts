pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val propertiesFile = settingsDir.parentFile.toPath().resolve("local.properties").toFile()
        if (propertiesFile.exists()) {
            propertiesFile.reader(Charsets.UTF_8).use { properties.load(it) }
        }
        val sdkPath = properties.getProperty("flutter.sdk")
        if (sdkPath == null) {
            throw GradleException("Flutter SDK not found in local.properties")
        }
        sdkPath
    }
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}
include(":app")
