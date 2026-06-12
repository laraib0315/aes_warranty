pluginManagement {
    val flutterSdkPath = run {
        // First try environment variable (Codemagic sets this)
        val envSdk = System.getenv("FLUTTER_ROOT")
        if (envSdk != null) {
            envSdk
        } else {
            // Fallback to local.properties (for local development)
            val properties = java.util.Properties()
            val propertiesFile = settingsDir.parentFile.toPath().resolve("local.properties").toFile()
            if (propertiesFile.exists()) {
                propertiesFile.reader(Charsets.UTF_8).use { properties.load(it) }
                val sdkPath = properties.getProperty("flutter.sdk")
                if (sdkPath != null) {
                    sdkPath
                } else {
                    throw GradleException("Flutter SDK not found in local.properties")
                }
            } else {
                throw GradleException("Flutter SDK not found. Set FLUTTER_ROOT environment variable or create local.properties with flutter.sdk")
            }
        }
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
    id("com.android.application") version "8.9.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
}

include(":app")