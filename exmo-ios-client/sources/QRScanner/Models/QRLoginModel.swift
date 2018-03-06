//
//  QRLoginModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/24/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

class QRLoginModel {
    var exmoIdentifier: String?
    var key: String?
    var secret: String?
    
    convenience init(qrParsedStr: String) {
        self.init()
        parseQRString(qrString: qrParsedStr)
    }

    private func parseQRString(qrString: String) {
        let componentsArr = qrString.components(separatedBy: "|")
        if componentsArr.count > 2 {
            self.exmoIdentifier = componentsArr[0]
            self.key = componentsArr[1]
            self.secret = componentsArr[2]
        }
    }
}