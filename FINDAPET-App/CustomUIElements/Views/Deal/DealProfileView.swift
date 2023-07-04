//
//  DealProfileView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 01.11.2022.
//

import UIKit
import SnapKit

final class DealProfileView: UIView {

    private let user: User.Output
    private let didTapViewAction: () -> Void
    
    init(user: User.Output, didTapViewAction: @escaping () -> Void) {
        self.user = user
        self.didTapViewAction = didTapViewAction
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView(image: .init(data: self.user.avatarData ?? UIImage(named: "empty avatar")?.pngData() ?? Data()))
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.user.name
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var userClosedDealsLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\("Closed Deals"): \(self.user.deals.filter { $0.buyer != nil }.count)"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        if #available(iOS 13.0, *) {
            let view = UIImageView(image: .init(systemName: "checkmark"))
            
            view.tintColor = .accentColor
            view.isHidden = self.user.documentData == nil
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        let view = UIImageView(image: .init(named: "checkmark")?.withRenderingMode(.alwaysTemplate))
        
        view.tintColor = .accentColor
        view.isHidden = self.user.documentData == nil
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .textFieldColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapView)))
        
        self.addSubview(self.avatarImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.userClosedDealsLabel)
        self.addSubview(self.checkmarkImageView)
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(15)
            make.width.height.equalTo(80)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.top.equalTo(self.avatarImageView)
        }
        
        self.userClosedDealsLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-10)
        }
        
        self.checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(self.nameLabel)
            make.width.height.equalTo(30)
        }
    }
    
//    MARK: Actions
    @objc private func didTapView() {
        self.didTapViewAction()
    }
    
}
