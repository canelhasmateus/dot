
function Utilities(app) {

    function withFile(filePath, callback) {

        try {
            const openedFile = app.openForAccess(Path(filePath), {
                writePermission: true
            })
            callback(openedFile)
            app.closeAccess(openedFile)

        }
        catch {
            app.closeAccess(filePath)
        }

    }

    function appendFile(openedFile, content) {
        app.write(content, { to: openedFile, startingAt: app.getEof(openedFile) })
    }

    function formatContent(currentUrl, classification) {
        const currentTime = new Date().toISOString().replace("T", " ").substring(0, 19)
        return `\n${currentTime}\t${classification}\t${currentUrl}`
    }
    return {
        withFile: withFile,
        appendFile: appendFile,
        formatContent: formatContent
    }
}
function run() {

    var app = Application.currentApplication()
    app.includeStandardAdditions = true
    utils = Utilities(app)

    const choices = ["Queue", "History", "Good", "Premium", "Bad", "Explore"]
    const currentUrl = Application('Chrome').windows[0].activeTab.url()
    const classification = app.chooseFromList(choices, {
        withPrompt: `Saving ${currentUrl}`,
        defaultItems: ["Queue"]
    })

    const content = utils.formatContent(currentUrl, classification)
    utils.withFile("/Users/mateus.canelhas/Desktop/revolut/priv/limni/lists/stream/articles.tsv", file => {
        utils.appendFile(file, content)
    })
}


