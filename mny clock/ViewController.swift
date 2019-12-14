//
//  ViewController.swift
//  mny clock
//
//  Created by 菅安唯伽 on 2019/06/01.
//  Copyright © 2019 Yuika Sugayasu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画面回転検知
        hideStatusBar()
        notifyOrientation()
        
        // バッテリー残量通知
        updateBatteryLevel()
        notifyBatteryLevel()
        
        setTextColor()
        nowTime()
        Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    func notifyOrientation() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onOrientationDidChange(notification:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    @objc func onOrientationDidChange(notification: NSNotification) {
        hideStatusBar()
    }
    
    func hideStatusBar() {
        let statusBar = UIApplication.shared.value(forKey: Constants.statusBar) as? UIView
        statusBar?.isHidden = true
    }
    
    func notifyBatteryLevel() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateBatteryLevel), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    
    @objc func updateBatteryLevel() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        batteryLabel.text = "⚡︎\(batteryLevel)%"
    }
    
    func setTextColor() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            Constants.redKey : 255 / 255,
            Constants.greenKey : 255 / 255,
            Constants.blueKey : 255 / 255
            ])
        let red = CGFloat(defaults.float(forKey: Constants.redKey))
        let green = CGFloat(defaults.float(forKey: Constants.greenKey))
        let blue = CGFloat(defaults.float(forKey: Constants.blueKey))
        let color = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        dateLabel.textColor = color
        timeLabel.textColor = color
    }
    
    @objc func update() {
        nowTime()
    }
    
    func nowTime() {
        let date = Date() // 現在時刻を取得
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar?.components(
            NSCalendar.Unit(rawValue:
                NSCalendar.Unit.year.rawValue |
                    NSCalendar.Unit.month.rawValue |
                    NSCalendar.Unit.day.rawValue |
                    NSCalendar.Unit.weekday.rawValue |
                    NSCalendar.Unit.hour.rawValue |
                    NSCalendar.Unit.minute.rawValue |
                    NSCalendar.Unit.second.rawValue
        ), from: date)
        
        let year = components?.year
        let month = components?.month
        let day = components?.day
        let weekday = components?.weekday
        let week = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        if let _year = year,
            let _month = month,
            let _day = day,
            let _weekday = weekday
        {
            dateLabel.text = "\(_year).\(addZero(number: _month)).\(addZero(number: _day)) (\(week[_weekday - 1]))"
        }
        
        let hour = components?.hour
        let minute = components?.minute
        let second = components?.second
        if let _hour = hour,
            let _minute = minute,
            let _second = second
        {
            timeLabel.text = "\(addZero(number: _hour)):\(addZero(number: _minute)):\(addZero(number: _second))"
        }
    }
    
    func addZero(number: Int) -> String {
        if String(number).count == 1 {
            return "0\(number)"
        } else {
            return "\(number)"
        }
    }
    
    func saveColor(red: CGFloat, green: CGFloat, blue: CGFloat) {
        // カラー保存
        let defaults = UserDefaults.standard
        defaults.set(red, forKey: Constants.redKey)
        defaults.set(green, forKey: Constants.greenKey)
        defaults.set(blue, forKey: Constants.blueKey)
    }
    
    @IBAction func changeToWhiteColor(_ sender: Any) {
        let red: CGFloat = 255 / 255
        let green: CGFloat = 255 / 255
        let blue: CGFloat = 255 / 255
        let color = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        dateLabel.textColor = color
        timeLabel.textColor = color
        saveColor(red: red, green: green, blue: blue)
    }
    @IBAction func changeToPinkColor(_ sender: Any) {
        let red: CGFloat = 255 / 255
        let green: CGFloat = 125 / 255
        let blue: CGFloat = 120 / 255
        let color = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        dateLabel.textColor = color
        timeLabel.textColor = color
        saveColor(red: red, green: green, blue: blue)
    }
    @IBAction func changeToBlueColor(_ sender: Any) {
        let red: CGFloat = 30 / 255
        let green: CGFloat = 110 / 255
        let blue: CGFloat = 160 / 255
        let color = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        dateLabel.textColor = color
        timeLabel.textColor = color
        saveColor(red: red, green: green, blue: blue)
    }
    
    struct Constants {
        static let redKey = "red"
        static let greenKey = "green"
        static let blueKey = "blue"
        
        static let statusBar = "statusBar"
    }
}

