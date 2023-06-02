//
//  LaunchScreenViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 28.12.2022.
//

import UIKit
import SnapKit

final class LaunchScreenViewController: UIViewController {

    private let presenter: LaunchScreenPresenter
    
    init(presenter: LaunchScreenPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: .init(named: "logo"))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.text = "FINDAPET"
        view.textColor = .white
        view.font = .init(name: "AvenirNext-Bold", size: 30)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let view = UIActivityIndicatorView(style: .medium)
            
            view.color = .white
            view.startAnimating()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        let view = UIActivityIndicatorView(style: .white)
        
        view.color = .white
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.nameLabel)
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(self.logoImageView.snp.width)
        }
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.logoImageView.snp.bottom).inset(-30)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
    
}
