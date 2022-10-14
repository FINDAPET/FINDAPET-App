//
//  URLConstructor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.08.2022.
//

import Foundation

final class URLConstructor {
    
    private let baseHTTPURL: URL
    private let baseWSURL: URL
    
    init(host: Hosts, port: Ports? = nil) {
        var urlComponents = URLComponents()
        
        urlComponents.host = host.rawValue
        urlComponents.port = port?.rawValue
        urlComponents.scheme = Schemes.http.rawValue
        
        self.baseHTTPURL = urlComponents.url ?? URL(fileURLWithPath: "")
        
        urlComponents.scheme = Schemes.ws.rawValue
        
        self.baseWSURL = urlComponents.url ?? URL(fileURLWithPath: "")
    }
    
    init(scheme: Schemes, host: Hosts, port: Ports? = nil) {
        var urlComponents = URLComponents()
        
        urlComponents.host = host.rawValue
        urlComponents.port = port?.rawValue
        urlComponents.scheme = scheme.rawValue
        
        self.baseHTTPURL = urlComponents.url ?? URL(fileURLWithPath: "")
        self.baseWSURL = urlComponents.url ?? URL(fileURLWithPath: "")
    }
    
    static let localhost = URLConstructor(host: .localhost, port: .localhost)
    static let `default` = URLConstructor(host: .localhost, port: .localhost)
    static let exchange = URLConstructor(host: .exchange)
    
//    MARK: Auth
    func auth() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.auth.rawValue)
    }
    
//    MARK: Log Out
    func logOut() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.logOut.rawValue)
    }
    
//    MARK: User
    func newUser() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func someUser(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func someUserDeals(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.deals.rawValue)
    }
    
    func someUserBoughtDeals(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.bought.rawValue)
    }
    
    func someUserAds(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.ads.rawValue)
    }
    
    func someUserOffers(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.offers.rawValue)
    }
    
    func someUserMyOffers(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(Paths.my.rawValue)
    }
    
    func changeUser() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func user() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.me.rawValue)
    }
    
    func deleteUser(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func createAdmin(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.admin.rawValue)
            .appendingPathComponent(Paths.on.rawValue)
    }
    
    func deleteAdmin(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.admin.rawValue)
            .appendingPathComponent(Paths.off.rawValue)
    }
    
    func catteryesAll() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.catteryes.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func userUpdate() -> URL {
        self.baseWSURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.update.rawValue)
    }
    
    func usersAll() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func waitCatteryesAll() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.catteryes.rawValue)
            .appendingPathComponent(Paths.wait.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func aprooveCattery(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.approove.rawValue)
            .appendingPathComponent(Paths.cattery.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func deleteCatteryAdmin(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(Paths.cattery.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
//    MARK: Offer
    func deleteOffer(offerID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(offerID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
    func allOffers() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func newOffer() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.offers.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
//    MARK: Deal
    func allDeals() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func someDeal(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func someDealOffers(userID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(userID.uuidString)
            .appendingPathComponent(Paths.offers.rawValue)
    }
    
    func newDeal() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeDeal() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deactiveteDeal(dealID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.deactivate.rawValue)
    }
    
    func activeteDeal(dealID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.activate.rawValue)
    }
    
    func deleteDeal(dealID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
    func soldDeal(dealID: UUID, offerID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.deals.rawValue)
            .appendingPathComponent(dealID.uuidString)
            .appendingPathComponent(Paths.offer.rawValue)
            .appendingPathComponent(offerID.uuidString)
            .appendingPathComponent(Paths.sold.rawValue)
    }
    
//    MARK: Ad
    func allAds() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func newAd() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func newAdAdmin() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func changeAdAdmin() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func allAdsAdmin() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func deactivateAd(adID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(adID.uuidString)
            .appendingPathComponent(Paths.deactivate.rawValue)
    }
    
    func activateAd(adID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(adID.uuidString)
            .appendingPathComponent(Paths.activate.rawValue)
    }
    
    func deleteAd(adID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.ads.rawValue)
            .appendingPathComponent(adID.uuidString)
            .appendingPathComponent(Paths.delete.rawValue)
    }
    
//    MARK: Chat Room
    func allChatRoomsAdmin() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func allChatRooms() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
    }
    
    func chatRoom(chatRoomID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
    }
    
    func newChatRoom() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeChatRoom() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func chatRoomWith(userID: UUID) -> URL {
        self.baseWSURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.with.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func deleteChatRoom(chatRoomID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
    }
    
//    MARK: Message
    func allMessagesAdmin() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(Paths.admin.rawValue)
    }
    
    func allMessages(chatRoomID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.all.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
    }
    
    func message(chatRoomID: UUID, messageID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
            .appendingPathComponent(messageID.uuidString)
    }
    
    func newMessage() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.new.rawValue)
    }
    
    func changeMessage() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.change.rawValue)
    }
    
    func deleteMessage(messageID: UUID) -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.messages.rawValue)
            .appendingPathComponent(Paths.delete.rawValue)
            .appendingPathComponent(messageID.uuidString)
    }
    
//    MARK: Exchange
    func convert() -> URL {
        self.baseHTTPURL
            .appendingPathComponent(Paths.convert.rawValue)
    }
    
}
