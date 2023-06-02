//
//  FeedViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import UIKit
import SnapKit
import SPStorkController

final class FeedViewController: UIViewController {

    private let presenter: FeedPresenter
    
    init(presenter: FeedPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private var isRefreshing = false
    private var isEmptyTableView = true
    
//    MARK: UI Properties
    private let activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let view = UIActivityIndicatorView(style: .medium)
            
            view.startAnimating()
            view.color = .accentColor
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        let view = UIActivityIndicatorView(style: .gray)
        
        view.startAnimating()
        view.color = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        
        view.addTarget(self, action: #selector(self.onRefresh), for: .valueChanged)
        view.backgroundColor = .clear
        view.tintColor = .accentColor
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.dataSource = self
        view.delegate = self
        view.refreshControl = self.refreshControl
        view.register(NotFoundTableViewCell.self, forCellReuseIdentifier: NotFoundTableViewCell.id)
        view.register(DealTableViewCell.self, forCellReuseIdentifier: DealTableViewCell.cellID)
        view.register(AdTableViewCell.self, forCellReuseIdentifier: AdTableViewCell.cellID)
        view.separatorColor = .clear
        view.isHidden = true
        view.backgroundColor = .backgroundColor
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var searchView: SearchView = {
        let view = SearchView(mode: .withFilter)
        
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let statusBarView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .backgroundColor
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
        
        self.setupNotifications()
        self.presenter.setFilterCheckedIDs()
        self.presenter.makeDealsEmpty()
        self.activityIndicatorView.isHidden = false
        self.tableView.isHidden = true
        self.presenter.getDeals { [ weak self ] _, error in
            self?.activityIndicatorView.isHidden = true
            self?.tableView.isHidden = false
            self?.error(error)
        }
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(self.searchView)
        self.view.addSubview(self.statusBarView)
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.tableView)
        
        self.statusBarView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        self.searchView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.searchView.snp.bottom).inset(-7.5)
        }
    }
    
//    MARK: - Setup Notifications
    private func setupNotifications() {
        self.presenter.notificationCenterManagerAddObserver(
            self,
            name: .reloadFeedScreen,
            action: #selector(self.reloadScreen)
        )
        self.presenter.notificationCenterManagerAddObserver(
            self,
            name: .makeFeedRefreshing,
            action: #selector(self.makeFeedRefreshing)
        )
        self.presenter.notificationCenterManagerAddObserver(
            self,
            name: .makeNilFilter,
            action: #selector(self.makeNilFilter)
        )
        self.presenter.notificationCenterManagerAddObserver(
            self,
            name: .makeFeedEmpty,
            action: #selector(self.makeFeedEmpty)
        )
    }
    
//    MARK: Actions
    @objc private func onRefresh() {
//            full version
//            self?.presenter.getRandomAd()
        self.isRefreshing = true
        self.presenter.setFilterCheckedIDs()
        self.presenter.getDeals(isDealsSortable: true) { [ weak self ] _, error in
            self?.presenter.makeDealsEmpty()
            self?.isRefreshing = false
            self?.tableView.tableFooterView = nil
            self?.refreshControl.endRefreshing()
            self?.error(error)
        }
    }
    
    @objc private func reloadScreen() {
        self.presenter.setFilterCheckedIDs()
        self.presenter.makeDealsEmpty()
        self.presenter.getDeals { [ weak self ] _, error in
            self?.activityIndicatorView.isHidden = true
            self?.tableView.isHidden = false
        }
    }
    
    @objc private func makeFeedRefreshing() {
        self.activityIndicatorView.isHidden = false
        self.tableView.isHidden = true
    }
    
    @objc private func makeNilFilter() {
        self.presenter.fullFilterDelete()
        self.searchView.searchTextField.text = nil
    }
    
    @objc private func makeFeedEmpty() {
        self.presenter.makeDealsEmpty()
    }
        
}

//MARK: Extensions
extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.presenter.deals.isEmpty {
            self.isEmptyTableView = true
            
            return 1
        }
        
        self.isEmptyTableView = false
        
        return self.presenter.deals.count + (self.presenter.ad != nil ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isEmptyTableView {
            return tableView.dequeueReusableCell(withIdentifier: NotFoundTableViewCell.id, for: indexPath)
        }
        
        if indexPath.row == .zero,
           let ad = self.presenter.ad,
           let cell = tableView.dequeueReusableCell(
            withIdentifier: AdTableViewCell.cellID,
            for: indexPath
        ) as? AdTableViewCell {
            cell.ad = ad
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DealTableViewCell.cellID,
            for: indexPath
        ) as? DealTableViewCell else {
            return .init()
        }
        
        cell.selectionStyle = .none
        cell.deal = self.presenter.deals[indexPath.row - (self.presenter.ad != nil ? 1 : 0)]
        
        return cell
    }
    
}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isEmptyTableView {
            return
        }
        
        if tableView.cellForRow(at: indexPath) is AdTableViewCell {
            if self.presenter.ad?.link != nil {
                self.presenter.goToUrl()
            } else {
                self.presenter.goToProfile()
            }
            
            return
        }
        
        self.presenter.goToDeal(deal: self.presenter.deals[indexPath.row - (self.presenter.ad != nil ? 1 : 0)])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.tableView,
              !self.isRefreshing,
              !self.presenter.deals.isEmpty,
              scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) else {
            return
        }
        
        if #available(iOS 13.0, *) {
            let activityIndicatorView = UIActivityIndicatorView(style: .large)
            
            activityIndicatorView.startAnimating()
            activityIndicatorView.color = .accentColor
            
            self.tableView.tableFooterView = activityIndicatorView
        } else {
            let activityIndicatorView = UIActivityIndicatorView(style: .gray)
            
            activityIndicatorView.startAnimating()
            activityIndicatorView.color = .accentColor
            
            self.tableView.tableFooterView = activityIndicatorView
        }
        
        self.isRefreshing = true
        self.presenter.getDeals { [ weak self ] deals, _ in
            self?.tableView.tableFooterView = nil
            self?.isRefreshing = false
            
            if deals?.isEmpty ?? true && !(self?.presenter.deals.isEmpty ?? true) {
                let label = UILabel()
                
                label.textColor = .accentColor
                label.text = NSLocalizedString("All deals viewed", comment: .init())
                label.font = .systemFont(ofSize: 18, weight: .semibold)
                label.numberOfLines = .zero
                label.textAlignment = .center
                
                self?.tableView.tableFooterView = label
                self?.isRefreshing = true
                
                label.sizeToFit()
            }
        }
    }
    
}

extension FeedViewController: SearchViewDelegate {
    
    func searchView(_ searchView: SearchView, didTapSearchTextField textField: UITextField) {
        self.presenter.goToSearch { [ weak self ] title in
            searchView.searchTextField.text = title
            
            self?.presenter.setFilterCheckedIDs()
//            full version
//            self?.presenter.getRandomAd()
            self?.presenter.makeDealsEmpty()
            self?.presenter.setFilterTitle(title)
            self?.activityIndicatorView.isHidden = false
            self?.tableView.isHidden = true
            self?.presenter.getDeals { _, error in
                self?.activityIndicatorView.isHidden = true
                self?.tableView.isHidden = false
                self?.error(error)
            }
        }
    }
    
    func searchView(_ searchView: SearchView, didTapSearchButton button: UIButton) {
        self.presenter.goToSearch { [ weak self ] title in
            searchView.searchTextField.text = title
            
            self?.presenter.setFilterCheckedIDs()
//            full version
//            self?.presenter.getRandomAd()
            self?.presenter.makeDealsEmpty()
            self?.presenter.setFilterTitle(title)
            self?.activityIndicatorView.isHidden = false
            self?.tableView.isHidden = true
            self?.presenter.getDeals { _, error in
                self?.activityIndicatorView.isHidden = true
                self?.tableView.isHidden = false
                self?.error(error)
            }
        }
    }
    
    func searchView(_ searchView: SearchView, didTapFilterButton button: UIButton) {
        guard let viewController = self.presenter.getFilter(
            startHandler: { [ weak self ] in
                self?.tableView.isHidden = true
                self?.activityIndicatorView.isHidden = false
                self?.presenter.setFilterCheckedIDs()
            },
            completionHandler: { [ weak self ] _, error in
                self?.tableView.isHidden = false
                self?.activityIndicatorView.isHidden = true
                self?.error(error)
            }
        ) else {
            return
        }
        
        let transitioningDelegate = SPStorkTransitioningDelegate()
        
        viewController.transitioningDelegate = transitioningDelegate
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        
        self.present(viewController, animated: true)
    }
    
}
