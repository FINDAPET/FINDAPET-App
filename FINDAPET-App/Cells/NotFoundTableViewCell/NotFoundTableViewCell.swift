//
//  NotFoundTableViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.11.2022.
//

import UIKit
import SnapKit

final class NotFoundTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: NotFoundTableViewCell.self)
    
//    MARK: UI Properties
    private let notFoundLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Not Found", comment: .init())
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 24)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.notFoundLabel)
        
        self.notFoundLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(15)
        }
    }

}
