//
//  NoInternetView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/6/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

class NoInternetView: UIView {
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getExo2Font(fontType: .regular, fontSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let titleAttribs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .semibold, fontSize: 22),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        let title = NSAttributedString(string: "No internet connection\n", attributes: titleAttribs)
        
        let subtitleAttribs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .regular, fontSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.dark2
        ]
        let subtitle = NSAttributedString(string: "\nCheck your internet connection \n and try refresh.", attributes: subtitleAttribs)
        
        let attributedText = NSMutableAttributedString(attributedString: title)
        attributedText.append(subtitle)
        
        label.attributedText = attributedText
        
        
        return label
    }()
    
    let refreshButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Refresh", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundImage(UIImage(named: "icWidthButtonBlue"), for: .normal)
        return btn
    }()
    
    let blurView: UIVisualEffectView = {
        return UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        addSubview(blurView)
        blurView.fillSuperview()
        
        addSubview(refreshButton)
        refreshButton.anchorCenterSuperview()
        refreshButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        refreshButton.addTarget(self, action: #selector(onTouchRefreshButton(_:)), for: .touchUpInside)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(nil, left: leftAnchor,
                bottom: refreshButton.topAnchor, right: rightAnchor,
                topConstant: 0, leftConstant: 30,
                bottomConstant: 20, rightConstant: 30,
                widthConstant: 0, heightConstant: 100)
    }
    
    @objc
    func onTouchRefreshButton(_ senderButton: UIButton) {
        removeFromSuperview()
    }
}
