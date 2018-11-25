//
//  TableMenuViewCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class TableMenuViewCell: ExmoTableViewCell {
    var cellType: MenuCellType = .None {
        didSet {
            iconImage.image = cellType.icon?.withRenderingMode(.alwaysOriginal)
            titleLabel.text = cellType.title
            selectionStyle = cellType == .AppVersion ? .none : .gray
            updateRightView()
        }
    }
    
    var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 14)
        label.textColor = .white
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "1.0"
        label.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 14)
        label.textColor = .dark1
        return label
    }()
    
    var disclosureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icInputFieldArrow")
        return imageView
    }()
    
    var bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .dark1
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TableMenuViewCell {
    func setupView() {
        self.backgroundColor = .clear
        
        addSubview(iconImage)
        iconImage.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 20, leftConstant: 30, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(titleLabel)
        titleLabel.anchor(self.topAnchor, left: iconImage.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 24, leftConstant: 20, bottomConstant: 24, rightConstant: 0, widthConstant: 160, heightConstant: 0)
        
        addSubview(infoLabel)
        infoLabel.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        
        addSubview(disclosureImage)
        disclosureImage.anchor(self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 20, rightConstant: 30, widthConstant: 0, heightConstant: 0)

        addSubview(bottomSeparatorLine)
        bottomSeparatorLine.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 1)
    }
    
    func updateRightView() {
        switch cellType {
        case .AppVersion:
            infoLabel.isHidden = false
            disclosureImage.isHidden = true
        case .Logout:
            infoLabel.isHidden = true
            disclosureImage.isHidden = true
        default:
            infoLabel.isHidden = true
            disclosureImage.isHidden = false
        }
    }
}
