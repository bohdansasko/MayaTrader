//
//  QRLoginModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/24/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

class QRLoginModel {
    var key: String?
    var secret: String?
    
    convenience init(qrParsedStr: String) {
        self.init()
        
        let componentsArr = qrParsedStr.components(separatedBy: "|")
        self.key = componentsArr[1]
        self.secret = componentsArr[2]
    }
}
