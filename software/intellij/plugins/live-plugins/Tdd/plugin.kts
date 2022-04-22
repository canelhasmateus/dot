import liveplugin.show


registerAction() {

    show("Current project: ${project?.name}")

}

show("Reloaded plugin.")
