# GSLogger

Swift Logging Utility in Xcode & Google Docs

## Log Levels

```swift
class MyAwesomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        GS1("Debug")
        GS2("Info")
        GS3("Warning")
        awesomeFunction()
    }
    func awesomeFunction() {
        GS4("Error")
    }
}
```
<br><br><br>
## Filter File Specific Logs:
Paste this where GSLogs is initiliazed:
```swift
  GSLogs.onlyShowThisFile(NewClass)
```

<br><br><br>
## Google Docs Support:

In production, send all your logs to Google Docs with only 1 line of extra code.
```swift
  GSLogs.enabled = false
  OnlineGSLogs.enabled = true
```
<br><br><br>
## Spot System Logs:
System logs are white (or black) after all, yours are not :)

## Installation

### Install Manually

Download and drop 'GSLogs.swift' in your project.

### Check Installation Works Correctly

  ```swift
  GSLogs.enabled = true
  GSLogs.test()
  ```
Congratulations!


## Detailed Features:

#### Log Levels

Sets the minimum log level that is seen in the debug area:

1. Debug - Detailed logs only used while debugging
2. Info - General information about app state
3. Warning - Indicates possible error
4. Error - An unexpected error occured, its recoverable
```swift
  GSLogs.minimumLogLevelShown = 2
  OnlineGSLogs.minimumLogLevelShown = 4 // Its a good idea to have OnlineLog level a bit higher
  GS1("mylog") // Doesn't show this level anywhere, because minimum level is 2
  GS2("mylog")  // Shows this only in debugger
  GS3("mylog") // Shows this only in debugger
  GS4("mylog") // Shows this in debugger and online logs
```
GS methods can print in both Debugger and Google Docs, depending on which is active.

#### Hide Other Classes

You need to write the name of the actual file, you can do this by a string and also directly the class name can be appropriate if it is the same as the file name. Add the following code where you setup GSLogs:
```swift
  GSLogs.onlyShowThisFile(MyAwesomeViewController)
  GSLogs.onlyShowThisFile("MyAwesomeViewController")
```

You do not need the extension of the file.

#### Print Lines
```swift
  GSPlusLine()
  GS2("Text between line")
  GSShortLine()
```

#### Add Custom Colors

Add custom colors for Mac, iOS, tvOS:
```swift
    GSLogs.colorsForLogLevels[0] = GSColor(r: 255, g: 255, b: 0)
    GSLogs.colorsForLogLevels[1] = GSColor(red: 255, green: 20, blue: 147)
```

```swift
    GS1("Mylog")
```

#### OnlineLogs - User Information
```swift
   OnlineGSLogs.extraInformation["userId"] = "sfkoFvvbKgr"
   OnlineGSLogs.extraInformation["name"] = "Will Smith"
   GS1("Will is awesome!")
   GS5("Will rules!")
```

#### How to delete rows inside google docs?
Unfortunately you can't just select the rows inside Google Docs and delete them. You need to select the rows where there are row numbers, then right click, then press delete click "Delete rows x-y"

## Requirements

- Xcode 6 or later (Tested on 6.4)
- iOS 7 or later (Tested on 7.1)
- tvOS 9 or later

## Possible features

- Different colors for white and black Xcode themes
- Easily editable colors
- Device information to Google Docs
- Google Docs shows in exact order
- Automatically getting entry ids for Google Docs
- Pod support with QL methods written customly

## Keywords
Debugging, logging, remote logging, remote debugging, GS app, swift log, library, framework, tool, google docs, google drive, google forms
