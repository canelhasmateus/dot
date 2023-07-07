set preferencesFiles to (path to preferences from local domain as Unicode text) & "com.apple.windowserver.plist"
set { {|Width|:w1, |Height|:h1, |OriginX|:x1, |OriginY|:y1}, {|Width|:w2, |Height|:h2, |OriginX|:x2, |OriginY|:y2} } to value of property list items of property list item 1 of property list item "DisplaySets" of property list file preferencesFiles
