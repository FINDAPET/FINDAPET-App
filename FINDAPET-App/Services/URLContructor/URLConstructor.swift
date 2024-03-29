//
//  URLConstructor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.08.2022.
//

import Foundation
import UIKit

final class URLConstructor {
    
    private let baseURL: URL
    
    init(scheme: Schemes, host: Hosts, port: Ports? = nil) {
        var urlComponents = URLComponents()
        
        urlComponents.host = host.rawValue
        urlComponents.port = port?.rawValue
        urlComponents.scheme = scheme.rawValue
        
        self.baseURL = urlComponents.url ?? URL(fileURLWithPath: "")
    }
    
    init(mailTo: String) {
        if #available(iOS 16.0, *) {
            self.baseURL = .init(string: "\(Schemes.mailto.rawValue):\(mailTo)") ?? .init(filePath: .init())
        } else {
            self.baseURL = .init(string: "\(Schemes.mailto.rawValue):\(mailTo)") ?? .init(fileURLWithPath: .init())
        }
    }
    
    init(string: String) {
        if #available(iOS 16.0, *) {
            self.baseURL = .init(string: string) ?? .init(filePath: .init())
        } else {
            self.baseURL = .init(string: string) ?? .init(fileURLWithPath: .init())
        }
    }
    
    static let blueSeaCattery = URLConstructor(scheme: .https, host: .blueSeaCattery)
    static let localhostHTTP = URLConstructor(scheme: .http, host: .localhost, port: .localhost)
    static let localhostWS = URLConstructor(scheme: .ws, host: .localhost, port: .localhost)
    static let defaultHTTP: URLConstructor = {
        if let string = UserDefaultsManager.read(key: .hostHTTP) as? String, URL(string: string) != nil { return .init(string: string) }
        
        return .init(scheme: .http, host: .base)
    }()
    static let defaultWS: URLConstructor = {
        if let string = UserDefaultsManager.read(key: .hostWS) as? String, URL(string: string) != nil { return .init(string: string) }
        
        return .init(scheme: .ws, host: .base)
    }()
    static let exchange = URLConstructor(scheme: .http, host: .exchange)
    
    //    MARK: Auth
    func auth() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.auth.rawValue)
            .appendingPathComponent(UIDevice.current.identifierForVendor?.uuidString ?? .init())
    }
    
    //    MARK: Log Out
    func logOut() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.logOut.rawValue)
            .appendingPathComponent(UIDevice.current.identifierForVendor?.uuidString ?? .init())
    }
    
    //    MARK: User
    func newUser() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func someUser(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func someUserDeals(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.deals.rawValue)
    }
    
    func someUserBoughtDeals(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.bought.rawValue)
    }
    
    func someUserAds(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.ads.rawValue)
    }
    
    func someUserOffers(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.offers.rawValue)
    }
    
    func someUserMyOffers(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(Paths.my.rawValue)
    }
    
    func changeUser() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func changeUser(baseCurrencyName: String) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
            .appendingPathComponent(baseCurrencyName)
    }
    
    func user() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.me.rawValue)
    }
    
    func getChats() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.chats.rawValue)
    }
    
    func deleteUser(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func createAdmin(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.admin.rawValue)
            .appendingPathComponent(Paths.on.rawValue)
    }
    
    func deleteAdmin(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.admin.rawValue)
            .appendingPathComponent(Paths.off.rawValue)
    }
    
    func catteryesAll() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.catteryes.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func userUpdate() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.update.rawValue)
    }
    
    func usersAll() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func waitCatteryesAll() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.catteryes.rawValue)
            .appendingPathComponent(Paths.wait.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func aprooveCattery(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.approove.rawValue)
            .appendingPathComponent(Paths.cattery.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func deleteCatteryAdmin(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(Paths.cattery.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func makeUserPremium() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.premium.rawValue)
    }
    
    func makeUserNotPremium() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.not.rawValue)
            .appendingPathComponent(Paths.premium.rawValue)
    }
    
    func getChatRoomsID() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.id.rawValue)
    }
    
    func getUserSearchTitles() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.search.rawValue)
            .appendingPathComponent(Paths.titles.rawValue)
    }
    
    //    MARK: Offer
    func deleteOffer(offerID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(offerID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
    func allOffers() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func newOffer() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    //    MARK: Deal
    func allDeals() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func someDeal(dealID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
    }
    
    func someDealOffers(dealID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.offers.rawValue)
    }
    
    func newDeal() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeDeal() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func viewDeal(dealID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.view.rawValue)
    }
    
    func deactiveteDeal(dealID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.deactivate.rawValue)
    }
    
    func activeteDeal(dealID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.activate.rawValue)
    }
    
    func deleteDeal(dealID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
    func soldDeal(dealID: UUID, offerID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.offer.rawValue)
            .appendingPathComponent(offerID.uuidString)
            .appendingPathComponent(Paths.sold.rawValue)
    }
    
//    MARK: Ad
    func allAds() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func randomAd() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.random.rawValue)
    }
    
    func newAd() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func newAdAdmin() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func changeAdAdmin() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func allAdsAdmin() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func deactivateAd(adID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(adID.uuidString)
            .appendingPathComponent(Paths.deactivate.rawValue)
    }
    
    func activateAd(adID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(adID.uuidString)
            .appendingPathComponent(Paths.activate.rawValue)
    }
    
    func deleteAd(adID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(adID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
//    MARK: Chat Room
    func allChatRoomsAdmin() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func allChatRooms() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func chatRoom(chatRoomID: String) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(chatRoomID)
    }
    
    func viewAllMessages(in chatRoomID: String) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(chatRoomID)
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.view.rawValue)
    }
    
    func newChatRoom() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeChatRoom() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func chatRoomWithUser(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.chat.rawValue)
            .appendingPathComponent(Paths.with.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func chatRoomWith(userID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.with.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func deleteChatRoom(chatRoomID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
    }
    
//    MARK: Message
    func allMessagesAdmin() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func allMessages(chatRoomID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
    }
    
    func message(chatRoomID: UUID, messageID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
            .appendingPathComponent(messageID.uuidString)
    }
    
    func newMessage() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeMessage() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deleteMessage(messageID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(messageID.uuidString)
    }
    
//    MARK: Complaint
    func allCompaints() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.complaints.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func complaint(complaintID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.complaints.rawValue)
            .appendingPathComponent(complaintID.uuidString)
    }
    
    func newCompaint() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.complaints.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeCompaint() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.complaints.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deleteComplaint(complaintID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.complaints.rawValue)
            .appendingPathComponent(complaintID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
//    MARK: Notification Screen
    func allNotificationScreens(countryCode: String) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.notification.rawValue)
            .appendingPathComponent(Paths.screens.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(countryCode)
    }
    
    func notificationScreen(notificationScreenID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.notification.rawValue)
            .appendingPathComponent(Paths.screens.rawValue)
            .appendingPathComponent(notificationScreenID.uuidString)
    }
    
    func newNotificationScreen() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.notification.rawValue)
            .appendingPathComponent(Paths.screens.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeNotificationScreen() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.notification.rawValue)
            .appendingPathComponent(Paths.screens.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deleteNotificationScreen(notificationScreenID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.notification.rawValue)
            .appendingPathComponent(Paths.screens.rawValue)
            .appendingPathComponent(notificationScreenID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
//    MARK: Search Title
    func getAllSearchTitles() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.search.rawValue)
            .appendingPathComponent(Paths.titles.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func searchTitle(with id: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.search.rawValue)
            .appendingPathComponent(Paths.titles.rawValue)
            .appendingPathComponent(id.uuidString)
    }
    
    func newSearchTitle() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.search.rawValue)
            .appendingPathComponent(Paths.titles.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeSearchTitle() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.search.rawValue)
            .appendingPathComponent(Paths.titles.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deleteSearchTitle(with id: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.search.rawValue)
            .appendingPathComponent(Paths.titles.rawValue)
            .appendingPathComponent(id.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
//    MARK: Subscription
    func subscriptions() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func subscription(with id: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(id.uuidString)
    }
    
    func newSubscriptions() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeSubscriptions() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deleteSubscription(with id: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(id.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
//    MARK: Title Subscription
    func titleSubscriptions() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.title.rawValue)
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func titleSubscription(with id: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.title.rawValue)
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(id.uuidString)
    }
    
    func newTitleSubscriptions() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.title.rawValue)
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeTitleSubscriptions() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.title.rawValue)
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deleteTitleSubscription(with id: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.title.rawValue)
            .appendingPathComponent(Paths.subscriptions.rawValue)
            .appendingPathComponent(id.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
//    MARK: Currency
    func getAllCurrencies() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.currencies.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
//    MARK: Deal Modes
    func getAllDealModes() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.deal.rawValue)
            .appendingPathComponent(Paths.modes.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
//    MARK: Pet Breeds
    func getAllPetBreeds() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.pet.rawValue)
            .appendingPathComponent(Paths.breeds.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
//    MARK: Pet Class
    func getAllPetClasses() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.pet.rawValue)
            .appendingPathComponent(Paths.classes.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
//    MARK: Pet Type
    func getAllPetTypes() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.pet.rawValue)
            .appendingPathComponent(Paths.types.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
//    MARK: - Device Token
    func createDeviceToken() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.device.rawValue)
            .appendingPathComponent(Paths.tokens.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
//    MARK: Privacy Policy
    func getPrivacyPolicy() -> URL {
        var url = self.baseURL
            .appendingPathComponent(Paths.privacy.rawValue)
            .appendingPathComponent(Paths.policy.rawValue)
        
        if #available(iOS 16, *), let countryCode = Locale.current.language.languageCode?.identifier {
            url = url.appendingPathComponent(countryCode)
        } else if let countryCode = Locale.current.languageCode {
            url = url.appendingPathComponent(countryCode)
        }
        
        return url
    }
    
//    MARK: Exchange
    func convert() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.convert.rawValue)
    }
    
//    MARK: Mail
    func mailTo() -> URL {
        self.baseURL
    }
    
//    MARK: - Base URL
    func getBaseURL() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.base.rawValue)
            .appendingPathComponent(Paths.url.rawValue)
    }
    
}
