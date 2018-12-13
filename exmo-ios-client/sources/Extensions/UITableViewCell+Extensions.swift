//
//  UITableViewCell+Extensions.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class ExmoTableViewCell: UITableViewCell {
    var datasourceItem: Any?
    var controller: UIViewController?
    
    let separatorLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        lineView.isHidden = true
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setupSelectionView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .backgroundColorSelectedCell
        self.selectedBackgroundView = bgColorView
    }
    
    func setupViews() {
        setupSelectionView()
        
        clipsToBounds = true
        addSubview(separatorLineView)
        separatorLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)
    }

}
