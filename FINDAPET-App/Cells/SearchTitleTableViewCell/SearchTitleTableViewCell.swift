//
//  SearchTitleTableViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.03.2023.
//

import UIKit
import SnapKit

final class SearchTitleTableViewCell: UITableViewCell {
    
//    MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: SearchTitleTableViewCell.self)
    
    var onPasteTitleAction: ((String?) -> Void)?
    var searchTitle: SearchTitle.Output? {
        didSet {
            guard let title = self.searchTitle?.title else {
                return
            }
            
            self.titleLabel.text = title
        }
    }
    
//    MARK: UI Properties
    private let magnifyingglassImageView: UIImageView = {
        if #available(iOS 13.0, *) {
            let view = UIImageView(image: .init(systemName: "magnifyingglass"))
            
            view.backgroundColor = .clear
            view.tintColor = .accentColor
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        let view = UIImageView(image: .init(named: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
        
        view.backgroundColor = .clear
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.searchTitle?.title
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var pasteTitleButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "arrow.up.right"), for: .normal)
        } else {
            view.setImage(.init(named: "arrow.up.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        view.tintColor = .accentColor
        view.imageViewSizeToButton()
        view.addTarget(self, action: #selector(self.didTapPasteTitleButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .textFieldColor
        
        self.contentView.addSubview(self.magnifyingglassImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.pasteTitleButton)
        
        self.magnifyingglassImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalTo(self.titleLabel)
            make.height.width.equalTo(25)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.magnifyingglassImageView.snp.trailing).inset(-10)
            make.trailing.equalTo(self.pasteTitleButton.snp.leading).inset(-10)
            make.top.bottom.equalToSuperview().inset(15)
        }
        
        self.pasteTitleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(self.titleLabel)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
    }
    
//    MARK: Actions
    @objc private func didTapPasteTitleButton() {
        self.onPasteTitleAction?(self.titleLabel.text)
    }
    
}
