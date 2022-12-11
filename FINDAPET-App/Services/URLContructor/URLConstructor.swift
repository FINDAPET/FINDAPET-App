//
//  URLConstructor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.08.2022.
//

import Foundation

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
        self.baseURL = URL(string: "\(Schemes.mailto.rawValue):\(mailTo)") ?? URL(fileURLWithPath: String())
    }
    
    init(string: String) {
        self.baseURL = URL(string: string) ?? URL(fileURLWithPath: String())
    }
    
    static let localhostHTTP = URLConstructor(scheme: .http, host: .localhost, port: .localhost)
    static let localhostWS = URLConstructor(scheme: .ws, host: .localhost, port: .localhost)
    static let defaultHTTP = URLConstructor(scheme: .http, host: .localhost, port: .localhost)
    static let defaultWS = URLConstructor(scheme: .ws, host: .localhost, port: .localhost)
    static let exchange = URLConstructor(scheme: .http, host: .exchange)
    
    //    MARK: Auth
    func auth() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.auth.rawValue)
    }
    
    //    MARK: Log Out
    func logOut() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.logOut.rawValue)
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
            .appendingPathExtension(baseCurrencyName)
    }
    
    func user() -> URL {
        self.baseURL
            .appendingPathComponent(Paths.users.rawValue)
            .appendingPathComponent(Paths.me.rawValue)
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
            .appendingPathExtension(Paths.users.rawValue)
            .appendingPathExtension(Paths.premium.rawValue)
    }
    
    func makeUserNotPremium() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.users.rawValue)
            .appendingPathExtension(Paths.not.rawValue)
            .appendingPathExtension(Paths.premium.rawValue)
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
            .appendingPathExtension(Paths.deals.rawValue)
            .appendingPathExtension(dealID.uuidString)
            .appendingPathExtension(Paths.view.rawValue)
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
    
    func chatRoom(chatRoomID: UUID) -> URL {
        self.baseURL
            .appendingPathComponent(Paths.chats.rawValue)
            .appendingPathComponent(chatRoomID.uuidString)
    }
    
    func viewAllMessages(in chatRoomID: UUID) -> URL {
        self.baseURL
            .appendingPathExtension(Paths.chat.rawValue)
            .appendingPathExtension(chatRoomID.uuidString)
            .appendingPathExtension(Paths.messages.rawValue)
            .appendingPathExtension(Paths.view.rawValue)
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
            .appendingPathExtension(Paths.chat.rawValue)
            .appendingPathComponent(Paths.chats.rawValue)
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
            .appendingPathExtension(Paths.complaints.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
    }
    
    func complaint(complaintID: UUID) -> URL {
        self.baseURL
            .appendingPathExtension(Paths.complaints.rawValue)
            .appendingPathExtension(complaintID.uuidString)
    }
    
    func newCompaint() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.complaints.rawValue)
            .appendingPathExtension(Paths.new.rawValue)
    }
    
    func changeCompaint() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.complaints.rawValue)
            .appendingPathExtension(Paths.change.rawValue)
    }
    
    func deleteComplaint(complaintID: UUID) -> URL {
        self.baseURL
            .appendingPathExtension(Paths.complaints.rawValue)
            .appendingPathExtension(complaintID.uuidString)
            .appendingPathExtension(Paths.delete.rawValue)
    }
    
//    MARK: Notification Screen
    func allNotificationScreens(countryCode: String) -> URL {
        self.baseURL
            .appendingPathExtension(Paths.notification.rawValue)
            .appendingPathExtension(Paths.screens.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
            .appendingPathExtension(countryCode)
    }
    
    func notificationScreen(notificationScreenID: UUID) -> URL {
        self.baseURL
            .appendingPathExtension(Paths.notification.rawValue)
            .appendingPathExtension(Paths.screens.rawValue)
            .appendingPathExtension(notificationScreenID.uuidString)
    }
    
    func newNotificationScreen() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.notification.rawValue)
            .appendingPathExtension(Paths.screens.rawValue)
            .appendingPathExtension(Paths.new.rawValue)
    }
    
    func changeNotificationScreen() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.notification.rawValue)
            .appendingPathExtension(Paths.screens.rawValue)
            .appendingPathExtension(Paths.change.rawValue)
    }
    
    func deleteNotificationScreen(notificationScreenID: UUID) -> URL {
        self.baseURL
            .appendingPathExtension(Paths.notification.rawValue)
            .appendingPathExtension(Paths.screens.rawValue)
            .appendingPathExtension(notificationScreenID.uuidString)
            .appendingPathExtension(Paths.delete.rawValue)
    }
    
//    MARK: Currency
    func getAllCurrencies() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.currencies.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
    }
    
//    MARK: Deal Modes
    func getAllDealModes() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.deal.rawValue)
            .appendingPathExtension(Paths.modes.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
    }
    
//    MARK: Pet Breeds
    func getAllPetBreeds() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.pet.rawValue)
            .appendingPathExtension(Paths.breeds.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
    }
    
    func getAllCatBreeds() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.pet.rawValue)
            .appendingPathExtension(Paths.breeds.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
            .appendingPathExtension(Paths.cats.rawValue)
    }
    
    func getAllDogBreeds() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.pet.rawValue)
            .appendingPathExtension(Paths.breeds.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
            .appendingPathExtension(Paths.dogs.rawValue)
    }
    
//    MARK: Pet Class
    func getAllPetClasses() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.pet.rawValue)
            .appendingPathExtension(Paths.classes.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
    }
    
//    MARK: Pet Type
    func getAllPetTypes() -> URL {
        self.baseURL
            .appendingPathExtension(Paths.pet.rawValue)
            .appendingPathExtension(Paths.types.rawValue)
            .appendingPathExtension(Paths.all.rawValue)
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
    
}
