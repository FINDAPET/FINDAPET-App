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
    
//    MARK: UI Properties
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
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
            self.presenter.getAds { [ weak self ] _, error in
                self?.error(error) {
                    self?.presentAlert(title: NSLocalizedString("Not Found", comment: String()))
                }
            }
        }
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: String())
        self.title = NSLocalizedString("My ad", comment: String())
        
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}

extension AdsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
