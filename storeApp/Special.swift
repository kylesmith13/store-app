//
//  Coupon.swift
//  storeApp
//
//  Created by Kyle Smith on 11/15/16.
//  Copyright © 2016 Codesmiths. All rights reserved.
//

import UIKit

class Special: NSObject {
    
    var thumbnailImage: UIImage?
    var title: String?
    var expires: String?
    var details: String?
    var type: String?
    
    func convertExpiration(date: String) {
        expires = Configuration.dateToString(date: date, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", dateStyle: .medium)
    }
}
