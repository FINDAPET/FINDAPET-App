//
//  ProfileViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {

    private let presenter: ProfilePresenter
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = NSLocalizedString("Profile", comment: "")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.id)
        
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.tableView)
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
//    MARK: Requests
    
    private func getUser() {
        if self.presenter.userID != nil {
            self.presenter.getSomeUser { [ weak self ] user, error in
                self?.error(error) {
                    guard let user = user, let self = self else {
                        self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                        
                        return
                    }
                   
                    self.activityIndicatorView.isHidden = true
                    self.tableView.isHidden = false
                    self.presenter.user = user
                }
            }
        } else {
            self.presenter.getUser { [ weak self ] user, error in
                self?.error(error) {
                    guard let user = user, let self = self else {
                        self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                        
                        return
                    }
                    
                    self.activityIndicatorView.isHidden = true
                    self.tableView.isHidden = false
                    self.presenter.user = user
                }
            }
        }
    }
    
    private func logOut() {
        self.presenter.logOut {  [ weak self ] error in
            self?.error(error) { [ weak self ] in
                self?.presenter.writeIsFirstEditing()
                self?.presenter.deleteKeychainData()
                self?.presenter.goToOnboarding()
            }
        }
    }

}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9//self.presenter.userID != nil ? 9 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = cell.defaultContentConfiguration()
        
        cell.backgroundColor = .backgroundColor
        
        config.textProperties.font = .systemFont(ofSize: 17)
        config.textProperties.color = .textColor
        
        switch indexPath.row {
        case 0:
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.id) as? ProfileTableViewCell else {
                return cell
            }
            
            newCell.user = self.presenter.user
            
            return newCell
        case 1:
            config.text = NSLocalizedString("Deals", comment: "")
        case 2:
            config.text = NSLocalizedString("My offers", comment: "")
        case 3:
            config.text = NSLocalizedString("Suggested offers", comment: "")
        case 4:
            config.text = NSLocalizedString("My ad", comment: "")
        case 5:
            config.text = NSLocalizedString("Create deal", comment: "")
        case 6:
            config.text = NSLocalizedString("Create ad", comment: "")
        case 7:
            config.text = NSLocalizedString("Edit profile", comment: "")
        case 8:
            config.text = NSLocalizedString("Log Out", comment: "")
            config.textProperties.color = .systemRed
        default:
            break
        }
        
        cell.contentConfiguration = config
        
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 1:
            self.presenter.goToDeals()
        case 2:
            self.presenter.goToOffers()
        case 3:
            self.presenter.goToOffers()
        case 4:
            self.presenter.goToAds()
        case 5:
            self.presenter.goToCreateDeal()
        case 6:
            self.presenter.goToCreateAd()
        case 7:
            self.presenter.goToEditProfile()
        case 8:
            self.logOut()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
