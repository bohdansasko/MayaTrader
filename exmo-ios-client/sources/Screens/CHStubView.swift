//
//  CHStubView.swift
//  exmo-ios-client
//
//  Created by Office Mac on 10/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHStubView: UIView {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
}

// MARK: - Setup

extension CHStubView {
    
    func setupUI() {
        imageView.image = nil
        textLabel.text  = nil
    }
    
}

// MARK: - Setters

extension CHStubView {
    
    func set(image: UIImage?, text: String?) {
        imageView.image = image
        textLabel.text = text
    }
    
}
