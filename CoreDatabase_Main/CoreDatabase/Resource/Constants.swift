//
//  Constants.swift
//
//  Created by Dipak on 07/08/22.
//

import Foundation
import UIKit

let defaultImg = "https://media.idownloadblog.com/wp-content/uploads/2019/09/Apple-Innovation-Event-banner.jpg"
func convertDateFormat(inputDate: String, format: String) -> String {

     let olDateFormatter = DateFormatter()
     olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

     let oldDate = olDateFormatter.date(from: inputDate)

     let convertDateFormatter = DateFormatter()
     convertDateFormatter.dateFormat = format //"MMM dd yyyy h:mm a"

     return convertDateFormatter.string(from: oldDate!)
}
