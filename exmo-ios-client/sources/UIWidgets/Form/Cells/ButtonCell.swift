//
//  ButtonCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    var formItem: ButtonFormItem? {
        didSet {
            formItem?.onChangeTouchState = {
                [weak self] isTouchEnabled in
                self?.button.isUserInteractionEnabled = isTouchEnabled
            }
        }
    }
    
    var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "icWidthButtonBlue"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.getExo2Font(fontType: .bold, fontSize: 14)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = nil
        selectionStyle = .none
        
        addSubview(button)
        button.addTarget(self, action: #selector(onTouchButton(_:)), for: .touchUpInside)
        button.anchor(self.topAnchor, left: self.leftAnchor,
                      bottom: self.bottomAnchor, right: self.rightAnchor,
                      topConstant: 0, leftConstant: 30,
                      bottomConstant: 0, rightConstant: 30,
                      widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
    
    @objc func onTouchButton(_ sender: UIButton) {
        formItem?.onTouch?()
    }
}

extension ButtonCell: FormUpdatable {
    func update(item: FormItem?) {
        formItem = item as? ButtonFormItem
        button.setTitle(formItem?.title, for: .normal)
    }
}
