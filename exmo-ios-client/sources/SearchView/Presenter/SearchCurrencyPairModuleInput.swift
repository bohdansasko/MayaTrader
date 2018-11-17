//
//  SearchModuleInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol SearchModuleInput: class {
    func setInputModule(output: SearchModuleOutput?)
}

protocol SearchModuleOutput: class {
    func onDidSelectCurrencyPair(rawName: String)
}
