//
//  SubscriptionSoonViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 10.04.2023.
//

import UIKit
import SnapKit

final class SubscriptionSoonViewController: UIViewController {

//    MARK: - Properties
    private let presenter: SubscriptionSoonPresenter
    
    
//    MARK: - Init
    init(presenter: SubscriptionSoonPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private let imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "under develop logo"))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("This module is under development", comment: .init())).\n\(NSLocalizedString("It will soon be available", comment: .init()))!"
        view.textColor = .accentColor
        view.font = .boldSystemFont(ofSize: 20)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupVeiws()
    }
    
//    MARK: Setup Views
    private func setupVeiws() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.titleLabel)
        
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(self.imageView.snp.width)
            make.centerY.equalToSuperview().multipliedBy(0.75)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.imageView.snp.bottom).inset(-10)
        }
    }
    
}
