// cache dependencies
allprojects {
    afterEvaluate {
        configurations.configureEach {
            resolutionStrategy {
                cacheChangingModulesFor(1, "days")
                cacheDynamicVersionsFor(1, "days")
            }
        }
    }
}
