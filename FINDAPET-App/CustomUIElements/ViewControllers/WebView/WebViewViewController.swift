//
//  WebViewViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.04.2023.
//

import UIKit
import SnapKit
import WebKit
import JGProgressHUD

final class WebViewViewController: UIViewController {
    
//    MARK: - Properties
    private let url: URL
    
    
//    MARK: - Init
    init(_ url: URL) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(_ str: String) throws {
        guard let url = URL(string: str) else {
            throw WebViewError.urlNotValid
        }
        
        self.init(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - UI Properties
    private let progressIndicator: JGProgressHUD = {
        let view = JGProgressHUD()
        
        view.textLabel.text = NSLocalizedString("Loading", comment: .init())
        
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.load(.init(url: self.url))
    }
    
//    MARK: - Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: .init())
        
        self.view.addSubview(self.webView)
        
        self.webView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

//MARK: - Extensions
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressIndicator.show(in: self.view)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressIndicator.dismiss(animated: true)
    }
    
}
