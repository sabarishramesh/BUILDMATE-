allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    project.configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "androidx.core" && requested.name.startsWith("core")) {
                useVersion("1.13.1")
            }
            if (requested.group == "androidx.appcompat") {
                useVersion("1.6.1")
            }
        }
    }
    plugins.withId("com.android.library") {
        dependencies {
            add("implementation", "androidx.core:core:1.13.1")
            add("implementation", "androidx.appcompat:appcompat:1.6.1")
        }
    }
}


tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
