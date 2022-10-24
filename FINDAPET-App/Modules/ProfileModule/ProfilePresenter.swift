//
//  ProfilePresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import Foundation
import UIKit

final class ProfilePresenter {
    
    let userID: UUID?
    var callBack: (() -> Void)?
    private let router: ProfileRouter
    private let interactor: ProfileInteractor
    
    init(router: ProfileRouter, interactor: ProfileInteractor, userID: UUID? = nil) {
        self.router = router
        self.interactor = interactor
        self.userID = userID
    }
    
    var user: User.Output? = User.Output(name: "Test", avatarData: UIImage(systemName: "globe")?.pngData(), deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output(contentData: UIImage(systemName: "globe")?.pngData() ?? Data())], myOffers: [Offer.Output(buyer: User.Output(name: "Buyer", deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output]()), deal: Deal.Output(title: "Deal", photoDatas: [UIImage(systemName: "globe")?.pngData() ?? Data()], tags: [String](), isPremiumDeal: true, isActive: true, viewsCount: .zero, mode: String(), petType: String(), petBreed: String(), showClass: String(), isMale: true, age: String(), color: String(), price: .zero, currencyName: String(), cattery: User.Output(name: "Buyer", deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output]()), offers: [Offer.Output](), score: .zero), cattery: User.Output(name: "Buyer", deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output]()))], offers: [Offer.Output(buyer: User.Output(name: "Buyer", deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output]()), deal: Deal.Output(title: "Deal", photoDatas: [UIImage(systemName: "globe")?.pngData() ?? Data()], tags: [String](), isPremiumDeal: true, isActive: true, viewsCount: .zero, mode: String(), petType: String(), petBreed: String(), showClass: String(), isMale: true, age: String(), color: String(), price: .zero, currencyName: String(), cattery: User.Output(name: "Buyer", deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output]()), offers: [Offer.Output](), score: .zero), cattery: User.Output(name: "Buyer", deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output]()))], chatRooms: [ChatRoom.Output]()) {
        didSet {
            self.callBack?()
        }
    }
        
//    MARK: Routing
    
    func goToOnboarding() {
        self.router.goToOnboarding()
    }
    
    func goToOffers() {
        self.router.goToOffers(mode: .offers, offers: self.user?.offers ?? [Offer.Output]())
    }
    
    func goToMyOffers() {
        self.router.goToOffers(mode: .myOffers, offers: self.user?.myOffers ?? [Offer.Output]())
    }
    
    func goToAds() {
        self.router.goToAds(ads: self.user?.ads ?? [Ad.Output]())
    }
    
    func goToCreateDeal() {
        self.router.goToCreateDeal()
    }
    
    func goToCreateAd() {
        self.router.goToCreateAd()
    }
    
    func goToInfo() {
        self.router.goToInfo()
    }
    
    func goToSettings() {
        self.router.goToSettings()
    }
    
    func goToEditProfile() {
        self.router.goToEditProfile(user: User.Input(
            id: self.user?.id,
            name: self.user?.name ?? "",
            avatarData: self.user?.avatarData,
            documentData: self.user?.documentData,
            description: self.user?.description ?? ""
        ))
    }
    
//    MARK: Requests
    
    func getUser(completionHandler: @escaping (User.Output?, Error?) -> Void) {
        self.interactor.getUser(completionHandler: completionHandler)
    }
    
    func getSomeUser(completionHandler: @escaping (User.Output?, Error?) -> Void) {
        if let userID = self.userID {
            self.interactor.getSomeUser(userID: userID, completionHandler: completionHandler)
        }
    }
    
    func logOut(completionHandler: @escaping (Error?) -> Void) {
        self.interactor.logOut(completionHandler: completionHandler)
    }
    
//    MARK: Currency Converter
    
    func convert(
        _ first: String,
        to second: String,
        value: Int,
        completionHandler: @escaping (ExchangeConvert.Output?, Error?) -> Void
    ) {
        self.interactor.convert(first, to: second, value: value, completionHandler: completionHandler)
    }
    
//    MARK: User Defaults
    
    func getMyID() -> UUID? {
        self.interactor.getMyID()
    }
    
    func getCurrency() -> String {
        self.interactor.getCurrency() ?? "USD"
    }
    
    func writeIsFirstEditing() {
        self.interactor.writeIsFirstEditing()
    }
    
//    MARK: Keychain
    
    func deleteKeychainData() {
        self.interactor.deleteKeychainData()
    }
    
}
