//
//  CreateAlertCreateAlertInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class CreateAlertInteractor: CreateAlertInteractorInput {

    weak var output: CreateAlertInteractorOutput!
    
    private var currencyId: Int = -1
    private var selectedSoundId: Int = -1
    
    private var currenciesContainer: [SearchCurrencyPairModel]
    private var soundsContainer = [
        SearchModel(id: 1, name: "Melody1"),
        SearchModel(id: 2, name: "Melody2"),
        SearchModel(id: 3, name: "Melody3"),
        SearchModel(id: 4, name: "Melody4"),
        SearchModel(id: 5, name: "Melody5"),
        SearchModel(id: 6, name: "Melody6"),
        SearchModel(id: 7, name: "Melody7")
    ]
    
    init() {
        self.currenciesContainer = Session.sharedInstance.getSearchCurrenciesContainer()
    }

    func handleSelectedCurrency(currencyId: Int) {
        self.currencyId = currencyId
        guard let currencyItem = self.currenciesContainer.first(where: {$0.id == currencyId}) else {
            return
        }
        self.output.updateSelectedCurrency(name: currencyItem.name, price: currencyItem.price)
    }

    func handleSelectedSound(soundId: Int) {
        self.selectedSoundId = soundId
        guard let soundItem = self.soundsContainer.first(where: {$0.id == soundId}) else {
            return
        }
        self.output.updateSelectedSoundInUI(soundName: soundItem.name)
    }
    
    func getCurrenciesContainer() -> [SearchCurrencyPairModel] {
        return self.currenciesContainer
    }
    
    func getSoundsContainer() -> [SearchModel] {
        return self.soundsContainer
    }
    
    func showCurrenciesSearchView() {
        self.output.showCurrenciesSearchView(data: self.getCurrenciesContainer())
    }
    
    func showSoundsSearchView() {
        self.output.showSoundsSearchView(data: self.getSoundsContainer())
    }
    
    func tryCreateAlert(alertModel: AlertItem) {
        APIService.socketManager.createAlert(alertItem: alertModel)
        print("handleTouchAddAlertBtn: " + alertModel.getDataAsText())
    }
}
