//
//  PurchaseManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.10.2022.
//

import Foundation
import StoreKit

final class PurchaseManager: NSObject {
    
//    MARK: Properties
    static let shared = PurchaseManager()
    
    private var firstCallBack: (([SKProduct]) -> Void)?
    private var secondCallBack: ((Error?) -> Void)?
    
//    MARK: Methods
    func getProducts(_ productsID: [ProductsID], callBack: @escaping ([SKProduct]) -> Void) {
        self.firstCallBack = callBack
        
        let request = SKProductsRequest(productIdentifiers: Set(productsID.map { $0.rawValue }))
        
        print(productsID.count)
        
        request.delegate = self
        request.start()
    }
    
    func makePayment(_ product: SKProduct, callBack: @escaping (Error?) -> Void) {
        self.secondCallBack = callBack
        
        SKPaymentQueue.default().add(SKPayment(product: product))
        SKPaymentQueue.default().add(self)
    }
    
}

//MARK: Extensions

extension PurchaseManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async { [ weak self ] in
            print(response.products.count)
            
            self?.firstCallBack?(response.products)
        }
    }
    
}

extension PurchaseManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("✅ Transaction purchased.")
                
                DispatchQueue.main.async { [ weak self ] in
                    self?.secondCallBack?(nil)
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("❌ Error: Transaction purchase failed.")
                
                DispatchQueue.main.async { [ weak self ] in
                    self?.secondCallBack?(PurchaseErrors.purchaseFailed)
                }
                
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
