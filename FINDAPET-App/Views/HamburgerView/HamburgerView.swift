//
//  MainHamburgerView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.10.2022.
//

import UIKit
import SnapKit

class HamburgerView: UIView {
    
    private let hamburgerButtonAction: () -> Void
    private let side: HamburgerViewSides
    private let buttonActions: [(title: String, color: UIColor, action: () -> Void)]
    
    init(
        hamburgerButtonAction: @escaping () -> Void,
        hamburgerColor: UIColor,
        side: HamburgerViewSides,
        buttonActions: [(title: String, color: UIColor, action: () -> Void)]
    ) {
        self.hamburgerButtonAction = hamburgerButtonAction
        self.side = side
        self.buttonActions = buttonActions
        
        super.init()
        
        self.hamburgerButton.setTitleColor(hamburgerColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var hamburgerButton: UIButton = {
        let view = UIButton()
        
        view.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        view.addTarget(self, action: #selector(self.didTapHamburgerButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }

//   MARK: Setup Views
    private func setupViews() {
        self.addSubview(self.hamburgerButton)
        self.addSubview(self.tableView)
        
        self.hamburgerButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            
            switch self.side {
            case .left:
                make.leading.equalToSuperview().inset(15)
            case .right:
                make.trailing.equalToSuperview().inset(15)
            }
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.hamburgerButton.snp.bottom).inset(-25)
        }
    }
    
//    MARK: Actions
    @objc private func didTapHamburgerButton() {
        self.hamburgerButtonAction()
    }
    
}

extension HamburgerView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buttonActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            
            config.textProperties.font = .systemFont(ofSize: 17)
            config.textProperties.color = self.buttonActions[indexPath.row].color
            
            config.text = self.buttonActions[indexPath.row].title
            
            cell.contentConfiguration = config
            
            return cell
        }
                
        cell.textLabel?.text = self.buttonActions[indexPath.row].title
                
        return cell
    }
    
}

extension HamburgerView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.buttonActions[indexPath.row].action()
    }
    
}
