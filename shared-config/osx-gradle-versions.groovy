initscript {
    repositories {
        gradlePluginPortal()
    }

    dependencies {
        classpath("com.github.ben-manes:gradle-versions-plugin:0.51.0")
    }
}

allprojects {
    afterEvaluate {
        if (!plugins.hasPlugin("com.github.ben-manes.versions") && !plugins.hasPlugin(com.github.benmanes.gradle.versions.VersionsPlugin::class.java)) {
            applyTo<com.github.benmanes.gradle.versions.VersionsPlugin>(project)
            tasks.named("dependencyUpdates").configure {
            }
        }
    }
}