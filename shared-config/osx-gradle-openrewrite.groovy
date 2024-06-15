//initscript {
//    repositories {
//        gradlePluginPortal()
//    }
//
//    dependencies {
//        classpath("org.openrewrite:plugin:6.6.3")
//    }
//}
//
//rootProject {
//    apply<org.openrewrite.gradle.RewritePlugin>()
//
//    repositories {
//        mavenCentral()
//    }
//
//    configure<org.openrewrite.gradle.RewriteExtension>() {
//        activeRecipe("com.revolut.canelhas.FmuExchangeLive")
//        configFile = file("/Users/canelhas.mateus/dev/ws/revolut/open-rewrite.yml")
//    }
//}