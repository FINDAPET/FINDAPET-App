//
//  MyOffersViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import UIKit
import SnapKit

final class OffersViewController: UIViewController {
    
    private let presenter: OffersPresenter
    
    init(presenter: OffersPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        
        view.backgroundColor = .accentColor
        view.tintColor = .white
        view.addTarget(self, action: #selector(self.onRefresh), for: .valueChanged)
        
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.startAnimating()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView ()
        
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.refreshControl = self.refreshControl
        view.register(OfferTableViewCell.self, forCellReuseIdentifier: OfferTableViewCell.cellID)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.presenter.userID != nil && self.presenter.offers.isEmpty {
            self.activityIndicatorView.isHidden = false
            self.tableView.isHidden = true
            self.getOffers()
        }
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        self.title = self.presenter.mode == .myOffers ? NSLocalizedString("My offers", comment: "") : NSLocalizedString("Suggested offers", comment: "")
        
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.tableView)
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
//    MARK: Requests
    private func getOffers(isRefreshing: Bool = false) {
        switch self.presenter.mode {
        case .myOffers:
            self.presenter.getUserMyOffers { [ weak self ] offers, error in
                self?.activityIndicatorView.isHidden = true
                self?.tableView.isHidden = false
                self?.refreshControl.endRefreshing()
                
                self?.error(error) {
                    if isRefreshing {
                        self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                    }
                    
                    return
                }
                
                guard let offers = offers else {
                    if isRefreshing {
                        self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                    }
                    
                    return
                }
                
                self?.presenter.offers = offers
            }
        case .offers:
            self.presenter.getUserOffers { [ weak self ] offers, error in
                self?.activityIndicatorView.isHidden = true
                self?.tableView.isHidden = false
                self?.refreshControl.endRefreshing()
                
                self?.error(error) {
                    if isRefreshing {
                        self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                    }
                    
                    return
                }
                
                guard let offers = offers else {
                    if isRefreshing {
                        self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                    }
                    
                    return
                }
                
                self?.presenter.offers = offers
            }
        }
    }
    
//    MARK: Actions
    @objc private func onRefresh() {
        self.getOffers()
    }
    
}

extension OffersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OfferTableViewCell.cellID) as? OfferTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.offer = self.presenter.offers[indexPath.row]
        cell.buyerAvatarImageViewAction = { [ weak self ] id in
            self?.presenter.goToProfile(userID: id)
        }
        cell.messageButtonAction = {// [ weak self ] in
//            self?.presenter.goToChatRoom(with: <#T##UUID#>)
        }
        
        if self.presenter.mode == .offers {
            cell.acceptButtonAction = { [ weak self ] in
                guard let self = self else {
                    return
                }
                
                self.presenter.acceptOffer(offer: self.presenter.offers[indexPath.row]) { error in
                    self.error(error) {
                        self.presentAlert(title: NSLocalizedString("Error", comment: ""))
                        
                        return
                    }
                }
            }
        }
        
        return cell
    }
    
}

extension OffersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
