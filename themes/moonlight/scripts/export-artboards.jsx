var docRef = app.activeDocument;

function exportArtboards() {
    for (var i = 0; i < docRef.artboards.length; i++) {
        var artboardName = docRef.artboards[i].name.split('\n')[0];

        // Skip artboards that start with "Artboard" or that start with a dash (-)
        if (!(artboardName.match(/^artboard/) || artboardName.match(/^\-/))) {
            var filename = "~/Desktop/theme-generator/themes/moonlight/src/icons/" + artboardName + ".png"
            var destFile = new File(filename);
            var options = new ExportOptionsPNG24();
            options.artBoardClipping = true;
            options.matte = true;
            docRef.artboards.setActiveArtboardIndex(i);
            docRef.exportFile(destFile, ExportType.PNG24, options);
        }
    }
}

exportArtboards()
