//
//  ProfileViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import UIKit
import SnapKit
import SideMenu
import JGProgressHUD

final class ProfileViewController: UIViewController {

    private let presenter: ProfilePresenter
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in
            self?.tableView.reloadData()
            self?.setupNavigationBar()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let view = UIActivityIndicatorView(style: .medium)
            
            view.startAnimating()
            view.isHidden = self.presenter.user != nil
            view.color = .accentColor
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        let view = UIActivityIndicatorView(style: .gray)
        
        view.startAnimating()
        view.isHidden = self.presenter.user != nil
        view.color = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let progressIndicator: JGProgressHUD = {
        let view = JGProgressHUD()
        
        view.textLabel.text = NSLocalizedString("Loading", comment: .init())
        
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        
        view.addTarget(self, action: #selector(self.onRefresh), for: .valueChanged)
        view.tintColor = .white
        view.backgroundColor = .accentColor
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.backgroundColor = .backgroundColor
        view.dataSource = self
        view.delegate = self
        view.refreshControl = self.refreshControl
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.id)
        view.register(DealTableViewCell.self, forCellReuseIdentifier: DealTableViewCell.cellID)
        view.separatorColor = .clear
        view.isHidden = self.presenter.user == nil
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
//                full version
//                (title: NSLocalizedString("My ad", comment: ""), color: .white, action: { [ weak self ] in
//                    self?.presenter.goToAds()
//            }),
                (title: NSLocalizedString("Edit profile", comment: ""), color: .white, action: { [ weak self ] in
                    self?.presenter.goToEditProfile()
            }),
//                full version
//                (title: NSLocalizedString("Create ad", comment: ""), color: .white, action: { [ weak self ] in
//                    self?.presenter.goToCreateAd()
//            }),
                (title: NSLocalizedString("Settings", comment: ""), color: .white, action: { [ weak self ] in
                    self?.presenter.goToSettings()
            }),
                (title: NSLocalizedString("Info", comment: ""), color: .white, action: { [ weak self ] in
                    self?.presenter.goToInfo()
            }),
                (title: NSLocalizedString("Log Out", comment: ""), color: .white, action: { [ weak self ] in
                    self?.logOut()
            })
            ]
        )
        
        view.view.backgroundColor = .accentColor
        view.view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.view.layer.cornerRadius = 25
        
        return view
    }()
    
    private lazy var sideMenuViewController: SideMenuNavigationController = {
        let view = SideMenuNavigationController(rootViewController: self.slideMenuViewController)
        
        view.navigationBar.backgroundColor = .clear
        view.presentationStyle = .menuSlideIn
        view.menuWidth = 230
        
        return view
    }()
    
    private lazy var complaintViewController: ComplaintViewController? = {
        let viewController = self.presenter.getComplaint()
        
        viewController?.view.clipsToBounds = true
        viewController?.view.layer.masksToBounds = true
        viewController?.view.layer.cornerRadius = 25
        viewController?.view.alpha = .zero
        viewController?.didTapSendButtonCallBack = { [ weak self ] in
            UIView.animate(withDuration: 0.2) {
                viewController?.view.alpha = .zero
                self?.translutionView.alpha = .zero
            } completion: { isComplete in
                if isComplete {
                    self?.translutionView.isHidden = true
                    viewController?.view.removeFromSuperview()
                    viewController?.removeFromParent()
                }
            }
        }
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private lazy var translutionView: UIView = {
        let view = UIView()
        
        view.alpha = .zero
        view.backgroundColor = .black
        view.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapTranslutionView)))
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var browseImageViewController = self.presenter.getBrowseImage(dataSource: self)
    
//    MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        guard self.presenter.userID == nil else {
            return
        }
        
        self.presenter.notificationCenterManagerAddObserver(
            self,
            name: .reloadProfileScreen,
            action: #selector(self.refreshScreen)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getUser()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.textColor]
        self.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: String())
        self.title = NSLocalizedString("Profile", comment: "")
        self.navigationItem.setHidesBackButton(self.presenter.userID == nil, animated: false)
                
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
    
//    MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        if self.presenter.userID == nil || self.presenter.userID == self.presenter.getMyID() {
            if #available(iOS 13.0, *) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(systemName: "list.bullet"),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapSlideMenuBarButton)
                )
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(named: "list.bullet")?.withRenderingMode(.alwaysTemplate),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapSlideMenuBarButton)
                )
            }
        } else if self.presenter.userID != self.presenter.getMyID() {
            if #available(iOS 13.0, *) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(systemName: "exclamationmark.triangle"),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapComplaintNavigationBarButton)
                )
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(named: "exclamationmark.triangle")?.withRenderingMode(.alwaysTemplate),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapComplaintNavigationBarButton)
                )
            }
        }
    }
    
//    MARK: Requests
    private func getUser(isRefreshing: Bool = false) {
        if self.presenter.userID != nil {
            self.presenter.getSomeUser { [ weak self ] user, error in
                self?.error(error) {
                    self?.activityIndicatorView.isHidden = true
                    self?.tableView.isHidden = false
                    self?.refreshControl.endRefreshing()
                    
                    guard let user = user, let self = self else {
                        if isRefreshing {
                            self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                        }
                        
                        return
                    }
                   
                    self.presenter.user = user
                }
            }
        } else {
            self.presenter.getUser { [ weak self ] user, error in
                self?.error(error) {
                    self?.activityIndicatorView.isHidden = true
                    self?.tableView.isHidden = false
                    self?.refreshControl.endRefreshing()
                    
                    guard let user = user, let self = self else {
                        if isRefreshing {
                            self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                        }
                        
                        return
                    }
                    
                    self.presenter.user = user
                }
            }
        }
    }
    
    private func logOut() {
        self.progressIndicator.show(in: self.view)
        self.presenter.logOut { [ weak self ] error in
            self?.progressIndicator.dismiss(animated: true)
            self?.error(error) {
                self?.presenter.writeIsFirstEditing()
                self?.presenter.deleteKeychainData()
                self?.presenter.deleteCity()
                self?.presenter.deleteCountry()
                self?.presenter.deleteUserID()
                self?.presenter.deleteDealsID()
                self?.presenter.deleteUserName()
                self?.presenter.deleteDeviceToken()
                self?.presenter.deleteUserCurrency()
                self?.presenter.deleteNotificationScreensID()
                self?.presenter.notificationCenterManagerPostMakeChatRoomsRefreshing()
                self?.presenter.notificationCenterManagerPostMakeFeedRefreshing()
                self?.presenter.notificationCenterManagerPostMakeNilFilter()
                self?.presenter.notificationCenterManagerPostMakeFeedEmpty()
                self?.presenter.notificationCenterManagerPostMakeChatRoomsEmpty()
                self?.activityIndicatorView.isHidden = false
                self?.tableView.isHidden = true
                self?.tabBarController?.selectedIndex = .zero
                
                if let vc = self?.tabBarController?.navigationController?.viewControllers.first(where: { $0 is OnboardingViewController }) {
                    self?.tabBarController?.navigationController?.popToViewController(vc, animated: true)
                } else {
                    self?.tabBarController?.navigationController?.popViewController(animated: false)
                    self?.presenter.goToOnboarding(false)
                }
            }
        }
    }
    
//    MARK: Actions
    @objc private func didTapSlideMenuBarButton() {
        self.translutionView.alpha = .zero
        self.translutionView.isHidden = false
        
        self.present(self.sideMenuViewController, animated: true)
        UIView.animate(withDuration: 0.2) { [ weak self ] in
            self?.translutionView.alpha = 0.5
        }
    }
    
    @objc private func onRefresh() {
        self.getUser()
    }
    
    @objc private func refreshScreen() {
        self.activityIndicatorView.isHidden = false
        self.tableView.isHidden = true
        self.getUser()
    }
    
    @objc private func didTapTranslutionView() {
        guard let viewController = self.complaintViewController,
              viewController.parent != nil,
              viewController.view.superview != nil else {
            self.sideMenuViewController.dismiss(animated: true)
            
            UIView.animate(withDuration: 0.2) { [ weak self ] in
                self?.translutionView.alpha = .zero
            } completion: { [ weak self ] isCompleted in
                guard isCompleted else {
                    return
                }
                
                self?.translutionView.isHidden = true
            }
            
            return
        }
        
        self.sideMenuViewController.dismiss(animated: true)
        
        UIView.animate(withDuration: 0.2) { [ weak self ] in
            viewController.view.alpha = .zero
            self?.translutionView.alpha = .zero
        } completion: { [ weak self ] isComplete in
            if isComplete {
                self?.translutionView.isHidden = true
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        }
    }
    
    @objc private func didTapComplaintNavigationBarButton() {
        guard self.presenter.user != nil, let complaintViewController  = self.complaintViewController else {
            return
        }
        
        self.addChild(complaintViewController)
        self.view.addSubview(complaintViewController.view)
        self.view.insertSubview(complaintViewController.view, at: 10)
        
        complaintViewController.view.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        self.translutionView.isHidden = false
        
        UIView.animate(withDuration: 0.2) { [ weak self ] in
            self?.complaintViewController?.view.alpha = 1
            self?.translutionView.alpha = 0.5
            self?.navigationController?.navigationBar.layer.zPosition = -1
            self?.tabBarController?.tabBar.layer.zPosition = -1
        }
    }

}

//MARK: Extensions
extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var number = 1
        
        if !(self.presenter.user?.deals.filter({ $0.buyer == nil }).isEmpty ?? true) {
            number += 1
        }
        
        if !(self.presenter.user?.boughtDeals.isEmpty ?? true) {
            number += 1
        }
                
        return number
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == .zero {
            return self.presenter.user != nil ? 1 : 0
        } else if section == 1 {
            return self.presenter.user?.deals.filter({ $0.buyer == nil }).count ?? 0
        }
        
        return self.presenter.user?.boughtDeals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == .zero {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ProfileTableViewCell.id
            ) as? ProfileTableViewCell else {
                return .init()
            }
            
            cell.didTapChervonDescriptionButtonAction = { [ weak tableView ] in
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
            cell.didTapAvatarImageViewAction = { [ weak self ] imageView in
                guard let browseImageViewController = self?.browseImageViewController,
                      self?.presenter.user?.avatarData != nil else { return }
                
                self?.navigationController?.pushViewController(browseImageViewController, animated: true)
            }
            cell.selectionStyle = .none
            cell.user = self.presenter.user
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DealTableViewCell.cellID
        ) as? DealTableViewCell else {
            return .init()
        }
        
        if indexPath.section == 1 && !(self.presenter.user?.deals.filter({ $0.buyer == nil }).isEmpty ?? true) {
            cell.deal = self.presenter.user?.deals.filter({ $0.buyer == nil })[indexPath.row]
        } else {
            cell.deal = self.presenter.user?.boughtDeals[indexPath.row]
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && !(self.presenter.user?.deals.filter({ $0.buyer == nil }).isEmpty ?? true) {
            return NSLocalizedString("Deals", comment: .init()) + ":"
        } else if section == 2 || (section == 1 && self.presenter.user?.deals.filter({ $0.buyer == nil }).isEmpty ?? true) {
            return NSLocalizedString("Bought", comment: .init()) + ":"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else { return }
        
        view.contentView.backgroundColor = .backgroundColor
        view.textLabel?.textColor = .textColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section != .zero, let user = self.presenter.user else {
            return
        }
        
        if self.presenter.userID == nil {
            if indexPath.section == 1 {
                self.presenter.goToDeal(deal: user.deals[indexPath.row])
            } else {
                self.presenter.goToDeal(deal: user.boughtDeals[indexPath.row])
            }
        } else {
            guard let viewController = indexPath.section == .zero ? self.presenter.getDeal(
                user.deals[indexPath.row]
            ) : self.presenter.getDeal(
                user.boughtDeals[indexPath.row]
            ) else {
                return
            }
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
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

extension ProfileViewController: BrowseImagesViewControllerDataSource {
    
    func browseImagesViewController(
        _ viewController: BrowseImagesViewController,
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { 1 }
    
    func browseImagesViewController(_ viewController: BrowseImagesViewController, collectionView: UICollectionView, imageForItemAt indexPath: IndexPath) -> UIImage? {
        guard let data = self.presenter.user?.avatarData else { return nil }
        
        return .init(data: data)
    }
    
}
