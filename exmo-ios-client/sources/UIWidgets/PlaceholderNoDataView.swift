//
//  PlaceholderNoDataView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class PlaceholderNoDataView: UIView {    
    private var placeHolderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no_orders_image")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Text"
        label.numberOfLines = 0
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 20)
        return label
    }()
    
    var text: String? {
        didSet {
            descriptionLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(placeHolderImage)
        placeHolderImage.anchor(self.topAnchor, left: self.leftAnchor,
                                bottom: self.bottomAnchor, right: self.rightAnchor,
                                topConstant: 0, leftConstant: 30,
                                bottomConstant: 0, rightConstant: 30,
                                widthConstant: 0, heightConstant: 0)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(placeHolderImage.bottomAnchor, left: placeHolderImage.leftAnchor,
                                bottom: nil, right: placeHolderImage.rightAnchor,
                                topConstant: 0, leftConstant: 10,
                                bottomConstant: 0, rightConstant: 10,
                                widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
