//
//  ProfileSlideMenuViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.10.2022.
//

import UIKit
import SnapKit

final class SlideMenuViewController: UIViewController {
    
    private let hamburgerButtonAction: () -> Void
    private let hamburgerColor: UIColor
    private let side: HamburgerViewSides
    private let buttonActions: [(title: String, color: UIColor, action: () -> Void)]
    
    init(
        hamburgerButtonAction: @escaping () -> Void,
        hamburgerColor: UIColor,
        side: HamburgerViewSides,
        buttonActions: [(title: String, color: UIColor, action: () -> Void)]
    ) {
        self.hamburgerButtonAction = hamburgerButtonAction
        self.hamburgerColor = hamburgerColor
        self.side = side
        self.buttonActions = buttonActions
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        
        view.text = "FINDAPET"
        view.textColor = self.hamburgerColor
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//   MARK: Setup Views
    private func setupViews() {
        self.navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        self.navigationController?.navigationBar.shadowImage = .init()
        
        switch self.side {
        case .left:
            if #available(iOS 13.0, *) {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                    image: UIImage(systemName: "list.bullet"),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapHamburgerButton)
                )
            } else {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                    image: UIImage(named: "list.bullet")?.withRenderingMode(.alwaysTemplate),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapHamburgerButton)
                )
            }
            
            self.navigationItem.leftBarButtonItem?.tintColor = self.hamburgerColor
        case .right:
            if #available(iOS 13.0, *) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(systemName: "list.bullet"),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapHamburgerButton)
                )
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(named: "list.bullet")?.withRenderingMode(.alwaysTemplate),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapHamburgerButton)
                )
            }
            
            self.navigationItem.rightBarButtonItem?.tintColor = self.hamburgerColor
        }
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.nameLabel)
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(25)
            make.bottom.equalTo(self.nameLabel.snp.top).inset(-15)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
        }
    }
    
//    MARK: Actions
    @objc private func didTapHamburgerButton() {
        self.hamburgerButtonAction()
    }
    
}

extension SlideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buttonActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            
            config.textProperties.font = .systemFont(ofSize: 20, weight: .semibold)
            config.textProperties.color = self.buttonActions[indexPath.row].color
            config.textProperties.numberOfLines = .zero
            config.text = self.buttonActions[indexPath.row].title
            
            cell.contentConfiguration = config
            
            return cell
        }
        
        cell.textLabel?.text = self.buttonActions[indexPath.row].title
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = .zero
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return cell
    }
    
}

extension SlideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.hamburgerButtonAction()
        self.buttonActions[indexPath.row].action()
    }
    
}
