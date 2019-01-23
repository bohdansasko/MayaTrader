//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

protocol VinsoAPIConnectionDelegate: class {
    func onConnectionOpened()
    func onConnectionRefused(reason: String)
    func onDidLogin()
}

extension VinsoAPIConnectionDelegate {
    func onConnectionOpened() {}
    func onConnectionRefused(reason: String) {}
    func onDidLogin() {}
}