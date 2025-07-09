// ✅ HAPUS baris plugin Flutter (TIDAK PERLU DISINI)

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Ganti lokasi folder build agar satu tempat
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// ✅ Tambahkan task clean untuk membersihkan build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
