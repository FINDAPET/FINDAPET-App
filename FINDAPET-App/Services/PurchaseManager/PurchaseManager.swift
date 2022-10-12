//
//  PurchaseManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.10.2022.
//

import Foundation
import StoreKit

final class PurchaseManager {
    
    static func getProducts(_ productsID: ProductsID..., callBack: @escaping ([SKProduct]) -> Void) {
        let productsRequestManager = ProductsRequestDelegate(callBack: callBack)
        let request = SKProductsRequest(productIdentifiers: Set(productsID.map { $0.rawValue }))
        
        request.delegate = productsRequestManager
        request.start()
    }
    
    static func makePayment(_ product: SKProduct, callBack: @escaping (Error?) -> Void) {
        SKPaymentQueue.default().add(SKPayment(product: product))
        SKPaymentQueue.default().add(PaymentTransactionObserver(callBack: callBack))
    }
    
    private final class ProductsRequestDelegate: NSObject, SKProductsRequestDelegate {
        
        private let callBack: ([SKProduct]) -> Void
        
        init(callBack: @escaping ([SKProduct]) -> Void) {
            self.callBack = callBack
        }
        
        func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
            self.callBack(response.products)
        }
        
    }
    
    private final class PaymentTransactionObserver: NSObject, SKPaymentTransactionObserver {
        
        private let callBack: (Error?) -> Void
        
        init(callBack: @escaping (Error?) -> Void) {
            self.callBack = callBack
        }
        
        func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    print("✅ Transaction purchased.")
                    
                    self.callBack(nil)
                    
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .failed:
                    print("❌ Error: Transaction purchase failed.")
                    
                    self.callBack(PurchaseErrors.purchaseFailed)
                    
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .purchasing:
                    print("Transaction purchasing...")
                case .restored:
                    print("Transaction restored.")
                case .deferred:
                    print("Transaction deferred.")
                @unknown default:
                    break
                }
            }
        }
        
    }
    
}
