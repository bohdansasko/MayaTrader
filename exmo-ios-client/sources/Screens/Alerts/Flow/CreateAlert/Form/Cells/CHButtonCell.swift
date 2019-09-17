//
//  CHButtonCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHButtonCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var button: UIButton!
    
    var formItem: ButtonFormItem? {
        didSet {
            formItem?.onChangeTouchState = {
                [weak self] isTouchEnabled in
                self?.button.isUserInteractionEnabled = isTouchEnabled
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

// MARK: - User interaction

private extension CHButtonCell {
    
    @IBAction func actTouchButton(_ sender: UIButton) {
        formItem?.onTouch?()
    }
    
}


// MARK: - FormUpdatable

extension CHButtonCell: FormUpdatable {
    
    func update(item: FormItem?) {
        guard let formItem = item as? ButtonFormItem else {
            assertionFailure("fix me")
            return
        }
        self.formItem = formItem
        button.setTitle(formItem.title, for: .normal)
    }
    
}
