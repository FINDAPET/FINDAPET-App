//
//  FeedViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import UIKit
import SnapKit

final class FeedViewController: UIViewController {

    private let presenter: FeedPresenter
    
    init(presenter: FeedPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private var isEmptyTableView = true
    
//    MARK: UI Properties
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        let view = UITableView()
        
        view.dataSource = self
        view.delegate = self
        view.register(NotFoundTableViewCell.self, forCellReuseIdentifier: NotFoundTableViewCell.id)
        view.register(DealTableViewCell.self, forCellReuseIdentifier: DealTableViewCell.cellID)
        view.register(AdTableViewCell.self, forCellReuseIdentifier: AdTableViewCell.cellID)
        view.separatorColor = .clear
        view.isHidden = true
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var searchView: SearchView = {
        let view = SearchView()
        
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
        
        self.presenter.getDeals { [ weak self ] _, error in
            self?.activityIndicatorView.isHidden = true
            self?.tableView.isHidden = false
            self?.error(error)
        }
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
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
    
//    MARK: Actions
   
    @objc private func onRefresh() {
        self.presenter.getDeals { [ weak self ] _, error in
            self?.error(error)
        }
    }
    
}

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
        
        self.presenter.goToDeal(deal: self.presenter.deals[indexPath.row])
    }
    
}

extension FeedViewController: SearchViewDelegate {
    
    func searchView(_ searchView: SearchView, editingSearchTextField textField: UITextField) {
        self.presenter.setFilterTitle(textField.text ?? .init())
    }
    
    func searchView(_ searchView: SearchView, didTapSearchButton button: UIButton) {
        self.presenter.getRandomAd { [ weak self ] _, error in
            self?.error(error) {
                self?.presenter.getDeals { _, error in
                    self?.error(error)
                }
            }
        }
    }
    
    func searchView(_ searchView: SearchView, didTapFilterButton button: UIButton) {
//        present filter view controller
    }
    
}
