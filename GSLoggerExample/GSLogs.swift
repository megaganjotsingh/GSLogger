//
//  GSLogs.swift
//  LogsExample
//
//  Created by Admin on 12/02/22.
//  Copyright © 2022 Gaganjot Singh. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif


///  Debug error level
private let kLogDebug : String = "Debug";

///  Info error level
private let kLogInfo : String = "Info";

///  Warning error level
private let kLogWarning : String = "Warning";

///  Error error level
private let kLogError : String = "Error";

public struct GSLogs {

    /// While enabled OnlineLogs does not work
    public static var enabled = false

    /// 1 to 4
    public static var minimumLogLevelShown = 1

    /// Change the array element with another UIColor. 0 is info gray, 5 is purple, rest are log levels
    public static var colorsForLogLevels: [GSColor] = [
        GSColor(r: 120, g: 120, b: 120),//0
        GSColor(r: 0, g: 180, b: 180),  //1
        GSColor(r: 0, g: 150, b: 0),    //2
        GSColor(r: 255, g: 190, b: 0),  //3
        GSColor(r: 255, g: 0, b: 0),    //4
        GSColor(r: 160, g: 32, b: 240)] //5

    /// Change the array element with another ansi color. 0 is info gray, 5 is purple, rest are log levels
    public static var ansiColorsForLogLevels: [String] = [
        "37m", // 0 (gray)
        "34m", // 1 (blue)
        "32m", // 2 (green)
        "33m", // 3 (yellow)
        "31m", // 4 (red)
        "35m"] // 5 (magenta)

    /// Change the array element with another Emoji or String. 0 replaces gray color, 5 replaces purple, rest replace log levels
    public static var emojisForLogLevels: [String] = [
        "", //0
        "💙", //1
        "💚", //2
        "💛", //3
        "❤️", //4
        "💜"] //5
    
    /// Uses emojis instead of colors when this is false
    public static var useColors = false

    /// Uses ANSI colors instead of colors or emojis when this is true
    public static var useAnsiColors = false
    
    //TODO: Show example in documentation
    /// Set your function that will get called whenever something new is logged
    public static var trackLogFunction: ((String)->())? = nil

    private static var showFiles = [String]()

    //==========================================================================================================
    // MARK: - Public Methods
    //==========================================================================================================

    /// Ignores all logs from other files
    public static func onlyShowTheseFiles(_ fileNames: Any...) {
        minimumLogLevelShown = 1

        let showFiles = fileNames.map { fileName in
            return fileName as? String ?? {
                let classString: String = {
                    let classString = String(describing: type(of: fileName))
                    return classString.ns.pathExtension
                }()

                return classString
            }()
        }

        self.showFiles = showFiles
        print(ColorLog.colorizeString("Logs: Only Showing: \(showFiles)", colorId: 5))
    }

    /// Ignores all logs from other files
    public static func onlyShowThisFile(_ fileName: Any) {
        onlyShowTheseFiles(fileName)
    }

    /// Test to see if its working
    public static func test() {
        let oldDebugLevel = minimumLogLevelShown
        minimumLogLevelShown = 1
        GS1(kLogDebug)
        GS2(kLogInfo)
        GS3(kLogWarning)
        GS4(kLogError)
        minimumLogLevelShown = oldDebugLevel
    }

    //==========================================================================================================
    // MARK: - Private Methods
    //==========================================================================================================

    fileprivate static func shouldPrintLine(level: Int, fileName: String) -> Bool {
        if !GSLogs.enabled {
            return false
        } else if GSLogs.minimumLogLevelShown <= level {
            return GSLogs.shouldShowFile(fileName)
        } else {
            return false
        }
    }

    fileprivate static func shouldShowFile(_ fileName: String) -> Bool {
        return GSLogs.showFiles.isEmpty || GSLogs.showFiles.contains(fileName)
    }
}

///  Debug error level
private let kOnlineLogDebug : String = "1 Debug";

///  Info error level
private let kOnlineLogInfo : String = "2 Info";

///  Warning error level
private let kOnlineLogWarning : String = "3 Warning";

///  Error error level
private let kOnlineLogError : String = "4 Error";

public struct OnlineGSLogs {
    private static let appVersion = versionAndBuild()
    private static var googleFormLink: String!
    private static var googleFormAppVersionField: String!
    private static var googleFormUserInfoField: String!
    private static var googleFormMethodInfoField: String!
    private static var googleFormErrorTextField: String!
    /// Online logs does not work while Logs is enabled
    public static var enabled = false

    /// 1 to 4
    public static var minimumLogLevelShown = 1

    /// Empty dictionary, add extra info like user id, username here
    public static var extraInformation = [String: String]()

    //==========================================================================================================
    // MARK: - Public Methods
    //==========================================================================================================

    /// Test to see if its working
    public static func test() {
        let oldDebugLevel = minimumLogLevelShown
        minimumLogLevelShown = 1
        GS1(kLogDebug)
        GS2(kLogInfo)
        GS3(kLogWarning)
        GS4(kLogError)
        minimumLogLevelShown = oldDebugLevel
    }

    /// Setup Google Form links
    public static func setupOnlineLogs(formLink: String, versionField: String, userInfoField: String, methodInfoField: String, textField: String) {
        googleFormLink = formLink
        googleFormAppVersionField = versionField
        googleFormUserInfoField = userInfoField
        googleFormMethodInfoField = methodInfoField
        googleFormErrorTextField = textField
    }

    //==========================================================================================================
    // MARK: - Private Methods
    //==========================================================================================================

    fileprivate static func sendError<T>(classInformation: String, textObject: T, level: String) {
        var text = ""
        if let stringObject = textObject as? String {
            text = stringObject
        } else {
            let stringObject = String(describing: textObject)
            text = stringObject
        }
        let versionLevel = (appVersion + " - " + level)

        let url = URL(string: googleFormLink)
        var postData = googleFormAppVersionField + "=" + versionLevel
        postData += "&" + googleFormUserInfoField + "=" + extraInformation.description
        postData += "&" + googleFormMethodInfoField + "=" + classInformation
        postData += "&" + googleFormErrorTextField + "=" + text

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData.data(using: String.Encoding.utf8)

        #if os(OSX)
            if kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber10_10 {
                Foundation.URLSession.shared.dataTask(with: request).resume()
            } else {
                NSURLConnection(request: request, delegate: nil)?.start()
            }
        #elseif os(iOS)
            URLSession.shared.dataTask(with: request).resume()
        #endif

        let printText = "OnlineLogs: \(extraInformation.description) - \(versionLevel) - \(classInformation) - \(text)"
        print(" \(ColorLog.colorizeString(printText, colorId: 5))\n", terminator: "")
    }

    fileprivate static func shouldSendLine(level: Int, fileName: String) -> Bool {
        if !OnlineGSLogs.enabled {
            return false
        } else if OnlineGSLogs.minimumLogLevelShown <= level {
            return GSLogs.shouldShowFile(fileName)
        } else {
            return false
        }
    }
}


///Detailed logs only used while debugging
public func GS1<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    GSManager(debug, file: file, function: function, line: line, level:1)
}

///General information about app state
public func GS2<T>(_ info: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    GSManager(info,file: file,function: function,line: line,level:2)
}

///Indicates possible error
public func GS3<T>(_ warning: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    GSManager(warning,file: file,function: function,line: line,level:3)
}

///An unexpected error occured
public func GS4<T>(_ error: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    GSManager(error,file: file,function: function,line: line,level:4)
}


private func printLog<T>(_ informationPart: String, text: T, level: Int) {
    print(" \(ColorLog.colorizeString(informationPart, colorId: 0))", terminator: "")
    print(" \(ColorLog.colorizeString(text, colorId: level))\n", terminator: "")
}

///=====
public func GSShortLine(_ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    let lineString = "======================================"
    GSineManager(lineString, file: file, function: function, line: line)
}

///+++++
public func GSPlusLine(_ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    let lineString = "+++++++++++++++++++++++++++++++++++++"
    GSineManager(lineString, file: file, function: function, line: line)
}

///Print data with level
private func GSManager<T>(_ debug: T, file: String, function: String, line: Int, level : Int) {

    let levelText : String;

    switch (level) {
    case 1: levelText = kOnlineLogDebug
    case 2: levelText = kOnlineLogInfo
    case 3: levelText = kOnlineLogWarning
    case 4: levelText = kOnlineLogError
    default: levelText = kOnlineLogDebug
    }

    let fileExtension = file.ns.lastPathComponent.ns.pathExtension
    let filename = file.ns.lastPathComponent.ns.deletingPathExtension
    
    var text = ""
    if let stringObject = debug as? String {
        text = stringObject
    } else {
        let stringObject = String(describing: debug)
        text = stringObject
    }
    GSLogs.trackLogFunction?(text)

    if GSLogs.shouldPrintLine(level: level, fileName: filename) {
        let informationPart: String
        informationPart = "\(filename).\(fileExtension):\(line) \(function):"
        printLog(informationPart, text: debug, level: level)
    } else if OnlineGSLogs.shouldSendLine(level: level, fileName: filename) {
        let informationPart = "\(filename).\(function)[\(line)]"
        OnlineGSLogs.sendError(classInformation: informationPart, textObject: debug, level: levelText)
    }
}

///Print line
private func GSineManager(_ lineString : String, file: String, function: String, line: Int) {
    let fileExtension = file.ns.lastPathComponent.ns.pathExtension
    let filename = file.ns.lastPathComponent.ns.deletingPathExtension
    if GSLogs.shouldPrintLine(level: 2, fileName: filename) {
        let informationPart: String
        informationPart = "\(filename).\(fileExtension):\(line) \(function):"
        printLog(informationPart, text: lineString, level: 5)
    }
}

private struct ColorLog {
    private static let ESCAPE = "\u{001b}["
    private static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    private static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    private static let RESET = ESCAPE + ";"      // Clear any foreground or background color

    static func colorizeString<T>(_ object: T, colorId: Int) -> String {
        if GSLogs.useAnsiColors {
            return "\(ESCAPE)1m\(ESCAPE)\(GSLogs.ansiColorsForLogLevels[colorId])\(object)"
        } else if GSLogs.useColors {
            return "\(ESCAPE)fg\(GSLogs.colorsForLogLevels[colorId].redColor),\(GSLogs.colorsForLogLevels[colorId].greenColor),\(GSLogs.colorsForLogLevels[colorId].blueColor);\(object)\(RESET)"
        } else {
            return "\(GSLogs.emojisForLogLevels[colorId])\(object)\(GSLogs.emojisForLogLevels[colorId])"
        }
    }
}

private func versionAndBuild() -> String {

    let version = Bundle.main.infoDictionary? ["CFBundleShortVersionString"] as! String
    let build = Bundle.main.infoDictionary? [kCFBundleVersionKey as String] as! String

    return version == build ? "v\(version)" : "v\(version)(\(build))"
}

private extension String {
    ///  Extension
    var ns: NSString { return self as NSString }
}

///Used in color settings for Logs
open class GSColor {
    #if os(OSX)
    var color: NSColor
    #elseif os(iOS) || os(tvOS)
    var color: UIColor
    #endif
    
    public init(r: CGFloat, g: CGFloat, b: CGFloat) {
        #if os(OSX)
            color = NSColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
        #elseif os(iOS) || os(tvOS)
            color = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
        #endif
    }
    
    public convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(r: red * 255, g: green * 255, b: blue * 255)
    }
    
    var redColor: Int {
        var r: CGFloat = 0
        color.getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }
    
    var greenColor: Int {
        var g: CGFloat = 0
        color.getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }
    var blueColor: Int {
        var b: CGFloat = 0
        color.getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }
}
