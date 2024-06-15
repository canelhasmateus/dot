apply plugin: AddMavenLocalPlugin

class AddMavenLocalPlugin implements Plugin<Gradle> {
    void apply(Gradle gradle) {
        gradle.beforeSettings { settings ->
            settings.pluginManagement {
                repositories {
                    mavenLocal()
                    gradlePluginPortal()
                }
            }
            settings.dependencyResolutionManagement {
                repositories {
                    mavenLocal()
                }
            }
        }
    }
}