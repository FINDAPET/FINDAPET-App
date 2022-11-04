//
//  SettingsViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 21.10.2022.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {

    private let presenter: SettingsPresenter
    
    init(presenter: SettingsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var settigsBlockView: SettingsBlockView? = {
        let view = self.presenter.getSettingsBlock { [ weak self ] in
            self?.presenter.goToProfile()
        } currencyValueTextFieldTapAction: { [ weak self ] in
            self?.presentActionsSheet(
                title: NSLocalizedString("Currency", comment: String()),
                contents: self?.presenter.getAllCurrencies().map { $0.rawValue } ?? [String](),
                action: { [ weak self ] action in self?.setupSettingsBlockViewText(action.title ?? String()) }
            )
        }
        
        view?.layer.cornerRadius = 25
        view?.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .accentColor
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = NSLocalizedString("Settings", comment: "")
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let settigsBlockView = self.settigsBlockView else {
            return
        }
        
        self.view.addSubview(settigsBlockView)
        
        settigsBlockView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.center.equalToSuperview()
        }
    }
    
//    MARK: Setup Datas
    private func setupSettingsBlockViewText(_ text: String) {
        self.settigsBlockView?.setupCurrencyValueText(text)
    }

}
