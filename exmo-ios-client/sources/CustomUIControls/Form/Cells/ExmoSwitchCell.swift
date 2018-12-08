//
//  ExmoSwitchCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class ExmoSwitchCell: UITableViewCell, SwitchFormConformity {
    var formItem: SwitchFormItem?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .Bold, fontSize: 14)
        return label
    }()
    
    let uiSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .dodgerBlue
        return sw
    }()
    
    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = nil
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't have implementation")
    }
    
    @objc func onSwitchValueChanged(_ sender: UISwitch) {
        formItem?.onChange?(uiSwitch.isOn)
    }
}

extension ExmoSwitchCell {
    func setupViews() {
        addSubview(titleLabel)
        titleLabel.anchor(nil, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 70, widthConstant: 0, heightConstant: 0)
        titleLabel.anchorCenterYToSuperview()
        
        addSubview(uiSwitch)
        uiSwitch.anchor(nil, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        uiSwitch.anchorCenterYToSuperview()
        uiSwitch.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
        
        addSubview(separatorHLineView)
        separatorHLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)
    }
}


extension ExmoSwitchCell: FormUpdatable {
    func update(item: FormItem?) {
        guard let fi = item as? SwitchFormItem,
              let uiProperties = fi.uiProperties as? SwitchCellUIProperties else { return }
        formItem = fi
        titleLabel.text = fi.title
        titleLabel.textColor = uiProperties.titleColor
        
        uiSwitch.onTintColor = uiProperties.stateOnTintColor
        uiSwitch.tintColor = uiProperties.stateOffTintColor
        uiSwitch.layer.cornerRadius = uiSwitch.frame.height/2
        uiSwitch.backgroundColor = uiProperties.stateOffTintColor
    }
}
