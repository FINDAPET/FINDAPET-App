//
//  PurchaseProducts.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.10.2022.
//

import Foundation

enum ProductsID: String, CaseIterable {
    case premiumSubscriptionOneMonth = "com.FINDAPET.premium.subscription.one.month"
    case premiumSubscriptionThreeMonth = "com.FINDAPET.premium.subscription.three.months"
    case premiumSubscriptionSixMonth = "com.FINDAPET.premium.subscription.six.months"
    case premiumSubscriptionOneYear = "com.FINDAPET.premium.subscription.one.year"
    case adOneWeek = "com.FINDAPET.ad.one.week"
    case adOneMonth = "com.FINDAPET.ad.one.month"
    case premiumDeal = "com.FINDAPET.premium.deal"
}