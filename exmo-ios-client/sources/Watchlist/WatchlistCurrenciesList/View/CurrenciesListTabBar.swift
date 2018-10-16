//
//  CurrenciesListTabBar.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/16/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

class CurrenciesListTabBar: UIView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let doneBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17)
        btn.addTarget(self, action: #selector(onTouchDoneBtn(_:)), for: .touchUpInside)
        return btn
    }()
    
    let separatorHLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .dark
        return lineView
    }()
    
    let glassIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icWalletSearch")
        return imageView
    }()
    
    var callbackOnTouchDoneBtn: VoidClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("doesn't have implementation")
    }
    
    @objc func onTouchDoneBtn(_ sender: Any) {
        callbackOnTouchDoneBtn?()
    }
}

extension CurrenciesListTabBar {
    func setupViews() {
        backgroundColor = .black
        
        addSubview(glassIconView)
        addSubview(searchBar)
        addSubview(doneBtn)
        addSubview(separatorHLineView)
        
        setupSearchBar()
        setupConstraints()
    }
    
    private func setupSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = .black
        searchBar.tintColor = .white
        searchBar.placeholder = "Search currency..."
        searchBar.removeGlassIcon()
        searchBar.setInputTextFont(UIFont.getExo2Font(fontType: .Regular, fontSize: 14))
    }
    
    private func setupConstraints() {
        glassIconView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 25, bottomConstant: 15, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        searchBar.anchor(nil, left: glassIconView.rightAnchor, bottom: self.bottomAnchor, right: doneBtn.leftAnchor, topConstant: 0, leftConstant: -30, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        doneBtn.anchor(nil, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 13.5, rightConstant: 25, widthConstant: 0, heightConstant: 0)
        
        separatorHLineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
}
