//
//  CHMenuCell.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHMenuCell: ExmoTableViewCell {
    
    var cellType: CHMenuCellType! {
        didSet {
            iconImage.image = cellType.icon?.withRenderingMode(.alwaysOriginal)
            titleLabel.text = cellType.title
            selectionStyle = cellType == .appVersion ? .none : .gray
            updateRightView()
        }
    }
    
    var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 14)
        label.textColor = .white
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "1.0"
        label.font = UIFont.getExo2Font(fontType: .semibold, fontSize: 14)
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
    
    var lockButton: UIButton = {
        var btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "icPasscodeUnlock"), for: .normal)
        btn.setImage(UIImage(named: "icPasscodeLock"), for: .selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        separatorLineView.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

private extension CHMenuCell {
    
    func setupView() {
        self.backgroundColor = .clear
        
        addSubview(iconImage)
        iconImage.anchor(self.topAnchor, left: self.leftAnchor,
                         bottom: self.bottomAnchor, right: nil,
                         topConstant: 20, leftConstant: 30,
                         bottomConstant: 20, rightConstant: 0,
                         widthConstant: 0, heightConstant: 0)
        
        addSubview(titleLabel)
        titleLabel.anchor(self.topAnchor, left: iconImage.rightAnchor,
                          bottom: self.bottomAnchor, right: nil,
                          topConstant: 10, leftConstant: 20,
                          bottomConstant: 10, rightConstant: 0,
                          widthConstant: 160, heightConstant: 0)
        
        addSubview(infoLabel)
        infoLabel.anchor(self.topAnchor, left: nil,
                         bottom: self.bottomAnchor, right: self.rightAnchor,
                         topConstant: 10, leftConstant: 0,
                         bottomConstant: 10, rightConstant: 30,
                         widthConstant: 0, heightConstant: 0)
        
        addSubview(disclosureImage)
        disclosureImage.anchor(self.topAnchor, left: nil,
                               bottom: self.bottomAnchor, right: self.rightAnchor,
                               topConstant: 0, leftConstant: 0,
                               bottomConstant: 0, rightConstant: 30,
                               widthConstant: 0, heightConstant: 0)
        
        addSubview(lockButton)
        lockButton.isHidden = true
        lockButton.anchor(self.topAnchor, left: nil,
                          bottom: self.bottomAnchor, right: self.rightAnchor,
                          topConstant: 0, leftConstant: 0,
                          bottomConstant: 0, rightConstant: 30,
                          widthConstant: 0, heightConstant: 0)
    }
    
    func updateRightView() {
        guard let cellType = cellType else { return }
        switch cellType {
        case .appVersion:
            infoLabel.isHidden       = false
            disclosureImage.isHidden = true
            lockButton.isHidden      = true
        case .logout:
            infoLabel.isHidden       = true
            disclosureImage.isHidden = true
            lockButton.isHidden      = true
        case .security:
            disclosureImage.isHidden = true
            let highlightedImage = lockButton.isSelected ? #imageLiteral(resourceName: "icPasscodeLock") : #imageLiteral(resourceName: "icPasscodeUnlock")
            lockButton.setImage(highlightedImage, for: .normal)
            lockButton.isHidden     = false
        default:
            infoLabel.isHidden       = true
            disclosureImage.isHidden = false
            lockButton.isHidden      = true
        }
    }
    
}
