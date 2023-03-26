//
//  AdsViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.10.2022.
//

import UIKit
import SnapKit

final class AdsViewController: UIViewController {

    private let presenter: AdsPresenter
    
    init(presenter: AdsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.completionHandler = { [ weak self ] in self?.tableView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    private var isEmptyTableView = true
    
//    MARK: UI Properties
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        
        view.addTarget(self, action: #selector(self.onRefresh), for: .valueChanged)
        view.backgroundColor = .accentColor
        view.tintColor = .white
        
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.startAnimating()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.refreshControl = self.refreshControl
        view.separatorColor = .clear
        view.register(NotFoundTableViewCell.self, forCellReuseIdentifier: NotFoundTableViewCell.id)
        view.register(AdTableViewCell.self, forCellReuseIdentifier: AdTableViewCell.cellID)
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
        
        if self.presenter.userID != nil {
            self.activityIndicatorView.isHidden = false
            self.tableView.isHidden = true
            self.getAds()
        }
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: String())
        self.title = NSLocalizedString("My ad", comment: String())
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicatorView)
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
//    MARK: Requests
    func getAds(isRefreshing: Bool = false) {
        self.presenter.getAds { [ weak self ] _, error in
            self?.refreshControl.endRefreshing()
            
            self?.error(error) {
                self?.activityIndicatorView.isHidden = true
                self?.tableView.isHidden = false
                self?.refreshControl.endRefreshing()
                
                if isRefreshing {
                    self?.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                }
            }
        }
    }
    
//    MARK: Acitons
    @objc private func onRefresh() {
        self.getAds()
    }

}

extension AdsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.presenter.ads.isEmpty {
            self.isEmptyTableView = true
            
            return 1
        }
        
        self.isEmptyTableView = false
        
        return self.presenter.ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isEmptyTableView {
            return tableView.dequeueReusableCell(withIdentifier: NotFoundTableViewCell.id, for: indexPath)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdTableViewCell.cellID) as? AdTableViewCell else {
            return UITableViewCell()
        }
        
        cell.ad = self.presenter.ads[indexPath.row]
        
        return cell
    }
    
}

extension AdsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ad = self.presenter.ads[indexPath.row]
        
        if let link = ad.link, let url = URL(string: link) {
            self.presenter.goTo(url: url)
        } else {
            self.presenter.goToProfile()
        }
    }
    
}
