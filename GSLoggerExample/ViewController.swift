//
//  ViewController.swift
//  LogsExample
//
//  Created by Admin on 12/03/22.
//  Copyright © 2022 Gaganjot Singh. All rights reserved.
//


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GSLogs.enabled = true
        GSLogs.test()
        
        GSShortLine()
//        customColors() //Uncomment to test custom colors
        setupOnlineLogs() //Uncomment to test it
        
        GSLogs.trackLogFunction = trackFunc
        
//        GS1("Show Debug")
//        GS2("Show Info")
//        GS3("Show Warning")
        awesomeFunction()
        
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 300, height: 100))
        label.text = "Check your console :)"
        view.addSubview(label)
    }
    
    func awesomeFunction() {
//        GSShortLine()
        GS4("Show Error")
    }

    func customColors() {
        //These colors are used by me in dark theme -goktugyil
        GSLogs.colorsForLogLevels[1] = GSColor(r: 0, g: 255, b: 255)
        GSLogs.colorsForLogLevels[2] = GSColor(r: 0, g: 255, b: 0)
    }
    
    func setupOnlineLogs() {
        OnlineGSLogs.setupOnlineLogs(formLink: "https://docs.google.com/forms/d/e/1FAIpQLSfEBvi2Q1S0l7sdNodfx8OzJ0WgdSsikNnh8cEUs9T8flWqkA/formResponse", versionField: "entry_480485904", userInfoField: "entry_553078185", methodInfoField: "entry_1783281469", textField: "entry_1110029300")
        GSLogs.enabled = false
        OnlineGSLogs.enabled = true
        OnlineGSLogs.extraInformation["creator"] = "Gaganjot singh"
//        OnlineLogs.extraInformation["tester"] = "ENTER_YOUR _NAME"
//        OnlineLogs.test()
        //Results will be here:
        //https://docs.google.com/spreadsheets/d/1sq9FaFa7Rz4Nlq1N7iBIgF2LKZLul2cHApWbn2uuT3o/edit?resourcekey#gid=1368454914

    }
    
    func trackFunc(log: String) {
//       print("Tracking: " + log)
    }
    
}

