//
//  ProfileViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import UIKit
import SnapKit
import SideMenu

final class ProfileViewController: UIViewController {

    private let presenter: ProfilePresenter
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Propertiest
    private var isHamburgerViewClossed = true
    
//    MARK: UI Properties
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.id)
        view.register(DealTableViewCell.self, forCellReuseIdentifier: DealTableViewCell.cellID)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var slideMenuViewController: SlideMenuViewController = {
        let view = SlideMenuViewController(
            hamburgerButtonAction: { [ weak self ] in
                self?.dismiss(animated: true)
            },
            hamburgerColor: .white,
            side: .right,
            buttonActions: [
                (title: NSLocalizedString("My offers", comment: ""), color: .white, action: { [ weak self ] in
                    self?.presenter.goToMyOffers()
            }),
                (title: NSLocalizedString("Suggested offers", comment: ""), color: .white, action: { [ weak self ] in
                    self?.presenter.goToOffers()
            }),
                (title: NSLocalizedString("My ad", comment: ""), color: .white, action: { [ weak self ] in
                    self?.presenter.goToAds()
            }),
                (title: NSLocalizedString("Create deal", comment: ""), color: .white, action: {
                    
            }),
                (title: NSLocalizedString("Create ad", comment: ""), color: .white, action: {
                    
            }),
                (title: NSLocalizedString("Settings", comment: ""), color: .white, action: {
                    
            }),
                (title: NSLocalizedString("Log Out", comment: ""), color: .white, action: { [ weak self ] in
                    self?.logOut()
            })
            ]
        )
        
        view.view.backgroundColor = .accentColor
        view.view.layer.cornerRadius = 20
        
        return view
    }()
    
    private lazy var sideMenuViewController: SideMenuNavigationController = {
        let view = SideMenuNavigationController(rootViewController: self.slideMenuViewController)
        
        view.presentationStyle = .menuSlideIn
        view.menuWidth = 200
        
        return view
    }()
    
    private let translutionView: UIView = {
        let view = UIView()
        
        view.alpha = .zero
        view.backgroundColor = .black
        view.isHidden = true
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(self.didTapSlideMenuBarButton)
        )
        
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.tableView)
        
        self.view.insertSubview(self.translutionView, at: 10)
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.translutionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
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
    
//    MARK: Actions
    @objc private func didTapSlideMenuBarButton() {
        self.present(self.sideMenuViewController, animated: true)
    }

}

//MARK: Extensions
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return (self.presenter.user?.deals.count ?? 0) + (self.presenter.user != nil ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == .zero {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.id) as? ProfileTableViewCell else {
                return UITableViewCell()
            }
            
            cell.user = self.presenter.user
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DealTableViewCell.cellID) as? DealTableViewCell else {
            return UITableViewCell()
        }
        
        cell.deal = self.presenter.user?.deals[indexPath.row - 1]
                
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row != 0 else {
            return
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ProfileViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        self.translutionView.isHidden = false
        
        UIView.animate(withDuration: 0.3) { [ weak self ] in
            self?.translutionView.alpha = 0.5
        }
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        UIView.animate(withDuration: 0.3) { [ weak self ] in
            self?.translutionView.alpha = .zero
        } completion: { [ weak self ] _ in
            self?.translutionView.isHidden = true
        }
    }
    
}