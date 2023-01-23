
//
//  AIUtilsManager.swift
//

import Foundation
import UIKit
import CoreLocation
import MessageUI
//import SwiftMessages
import Toaster

let APP_NAME                    = "Core Database Demo"
let CUSTOM_ERROR_DOMAIN         = "CUSTOM_ERROR_DOMAIN"
let DEFAULT_ERROR               = "Something went wrong and try again."
let INTERNET_ERROR              = "Please check your internet connection and try again."
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

//MARK: - SHOW TOAST
func showToast(_ message:String){
    Toast(text: message , duration: 1.0).show()
    ToastView.appearance().font = UIFont.systemFont(ofSize: 17)
//    ToastView.appearance().font = UIFont(name: FONT_NOTOSANS_REGULAR,size: 17.0)
}

// MARK: - INTERNET CHECK
func SHOW_INTERNET_ALERT(){
    HIDE_CUSTOM_LOADER()
    displayAlertWithMessage(INTERNET_ERROR)
}

// MARK: - ALERT
func displayAlertWithMessage(_ message:String) -> Void {
    let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alert, animated: true, completion:nil)

}

func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    
    let str = String(data: data, encoding: .utf8)?.trimString()
    return str
}

func dataToJSON(data: Data) -> Any? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    } catch let myJSONError {
        print(myJSONError)
    }
    return nil
}

func convertDictionaryToJson(Dict: NSDictionary) -> String?
{
    let jsonData = try? JSONSerialization.data(withJSONObject: Dict, options: [])
    let jsonString = String(data: jsonData!, encoding: .utf8)
    return jsonString
}

func convertToDictionary(text: String) -> [String: AnyObject]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}


func getTimetoString(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    guard let date = dateFormatter.date(from: strDate) else {
        return "N/A"
    }
    dateFormatter.dateFormat = "HH:mm"
    let dateString = dateFormatter.string(from: date)
    return dateString
}


func UTCStringToDateFormate(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "MM/dd/yyyy, h:mm a"
    let dateString = dateFormatter1.string(from: date)
    return dateString
}


func getMonthFromUTC(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "MMM"
    let dateString = dateFormatter1.string(from: date)
    return dateString
}

func getDateFromUTC(strDate:String) -> String{
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date = dateFormatter.date(from: strDate) else {
        return ""
    }
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "dd"
    let dateString = dateFormatter1.string(from: date)
    return dateString
}



func getDateFromUTCTime(strDate:String) -> Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    guard let date = dateFormatter.date(from: strDate) else {
        return nil
    }
    return date
}

func getPastTime(for date : Date) -> String {
    
    var secondsAgo = Int(Date().timeIntervalSince(date))
    if secondsAgo < 0 {
        secondsAgo = secondsAgo * (-1)
    }
    
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
    
    if secondsAgo < minute  {
        if secondsAgo < 2{
            return "just now"
        }else{
            return "\(secondsAgo) secs ago"
        }
    } else if secondsAgo < hour {
        let min = secondsAgo/minute
        if min == 1{
            return "\(min) min ago"
        }else{
            return "\(min) mins ago"
        }
    } else if secondsAgo < day {
        let hr = secondsAgo/hour
        if hr == 1{
            return "\(hr) hr ago"
        } else {
            return "\(hr) hrs ago"
        }
    } else if secondsAgo < week {
        let day = secondsAgo/day
        if day == 1{
            return "\(day) day ago"
        }else{
            return "\(day) days ago"
        }
    } else {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, hh:mm a"
        formatter.timeZone = TimeZone.current
        let strDate: String = formatter.string(from: date)
        return strDate
    }
}

//MARK:- Phone Number Formatter String
func formattedMobileNumber(number: String) -> String {
    
    if number.contains("(")
    {
        return number
    }
    
    let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let mask = "(XXX) XXX-XXXX"
    
    var result = ""
    var index = cleanPhoneNumber.startIndex
    for ch in mask {
        if index == cleanPhoneNumber.endIndex {
            break
        }
        if ch == "X" {
            result.append(cleanPhoneNumber[index])
            index = cleanPhoneNumber.index(after: index)
        } else {
            result.append(ch)
        }
    }
    return result
}

func removeValidationMobile(string:String) -> String {
    var cleanPhoneNumber = string.replacingOccurrences(of: " ", with: "")
    cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: "(", with: "")
    cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: ")", with: "")
    cleanPhoneNumber = cleanPhoneNumber.replacingOccurrences(of: "-", with: "")
    return cleanPhoneNumber
}



//Check IsiPhone Device
func IS_IPHONE_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .phone
    return deviceType
}

//Check IsiPad Device
func IS_IPAD_DEVICE()->Bool{
    let deviceType = UIDevice.current.userInterfaceIdiom == .pad
    return deviceType
}

//MARK:- DEVICE ORIENTATION CHECK
func IS_DEVICE_PORTRAIT() -> Bool {
    return UIDevice.current.orientation.isPortrait
}

func IS_DEVICE_LANDSCAPE() -> Bool {
    return UIDevice.current.orientation.isLandscape
}

// MARK: - Custom object Functions Save User Default
 func setCustomObject(value:AnyObject,key:String)
{
    let data = NSKeyedArchiver.archivedData(withRootObject: value)
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getCustomObject(key:String) -> Any?
{
    let data = UserDefaults.standard.object(forKey: key) as? NSData
    if data == nil
    {
        return nil
    }
    let value = NSKeyedUnarchiver.unarchiveObject(with: data! as Data)
    return value
}

 func removeObjectForKey(_ objectKey: String) {
    
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: objectKey)
    defaults.synchronize()
}

 func removeAllKeyFromDefault(){
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
}

 func setImageObject(value:UIImage,key:String)
{
    UserDefaults.standard.set(value.pngData(), forKey: key)
    UserDefaults.standard.synchronize()
}
 func getImageObject(key:String) -> UIImage
{
    let data = UserDefaults.standard.object(forKey: key) as? NSData
    if data == nil
    {
        let img = UIImage.init()
        img.accessibilityIdentifier = "nil"
        return img
    }
    return UIImage.init(data: data! as Data)!
}

// MARK: - String Functions
 func setString(value:String,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getString(key:String) -> String?
{
    let value : String? = UserDefaults.standard.object(forKey: key) as? String
    return value
}

// MARK: - Int Functions
 func setInt(value:Int,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getInt(key:String) -> Int?
{
    let value : Int? = UserDefaults.standard.object(forKey: key) as? Int
    return value
}

// MARK: - Bool Functions
 func setBool(value:Bool,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getBool(key:String) -> Bool?
{
    let value : Bool? = UserDefaults.standard.object(forKey: key) as? Bool
    return value
}

// MARK: - Float Functions
 func setFloat(value:Float,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getFloat(key:String) -> Float?
{
    let value : Float? = UserDefaults.standard.object(forKey: key) as? Float
    return value
}

// MARK: - Double Functions
 func setDouble(value:Double,key:String)
{
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

 func getDouble(key:String) -> Double?
{
    let value : Double? = UserDefaults.standard.object(forKey: key) as? Double
    return value
}

