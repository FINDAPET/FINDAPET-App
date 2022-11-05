//
//  PrivacyPolicyViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.08.2022.
//

import UIKit
import SnapKit

final class PrivacyPolicyViewController: UIViewController {
    
    private let presenter: PrivacyPolicyPresenter
    
    init(presenter: PrivacyPolicyPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Privacy policy", comment: "")
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let privacyPolicyTextLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Privacy Policy Text", comment: "")
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 18, weight: .regular)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: SetupViews
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.privacyPolicyTextLabel)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        self.privacyPolicyTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
}
