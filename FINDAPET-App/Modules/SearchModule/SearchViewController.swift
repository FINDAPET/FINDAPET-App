//
//  SearchViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.03.2023.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {

//    MARK: Init Properties
    private let presenter: SearchPresenter
    
//    MARK: Init
    init(presenter: SearchPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = {  [ weak self ] in
            self?.tableView.reloadData()
            
            guard !(self?.presenter.titles.isEmpty ?? true) else {
                return
            }
            
            UIView.animate(withDuration: 0.1) {
                self?.tableView.alpha = 1
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var searchView: SearchView = {
        let view = SearchView(mode: .withBack)
        
        view.delegate = self
        view.searchTextField.text = self.presenter.title
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
//        if #available(iOS 13.0, *) {
//            let view = UITableView(frame: .zero, style: .insetGrouped)
//
//            view.backgroundColor = .clear
//            view.delegate = self
//            view.dataSource = self
//            view.register(SearchTitleTableViewCell.self, forCellReuseIdentifier: SearchTitleTableViewCell.id)
//            view.translatesAutoresizingMaskIntoConstraints = false
//
//            return view
//        }
        
        let view = UITableView(frame: .zero, style: .plain)
        
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(SearchTitleTableViewCell.self, forCellReuseIdentifier: SearchTitleTableViewCell.id)
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
        
        self.presenter.getAll()
        self.searchView.searchTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboadWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        self.view.addSubview(self.searchView)
        self.view.addSubview(self.tableView)
        
        self.searchView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchView.snp.bottom).inset(-15)
            make.trailing.left.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
//    MARK: - Actions
    @objc private func keyboadWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.contentInset.bottom = keyboardSize.height
            self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height,
                right: 0
            )
            self.tableView.setContentOffset(.init(
                x: 0,
                y: max(self.tableView.contentSize.height - self.tableView.bounds.size.height, 0)
            ), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset.bottom = .zero
        self.tableView.verticalScrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}

//MARK: Extensions
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.presenter.titles.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchTitleTableViewCell.id,
            for: indexPath
        ) as? SearchTitleTableViewCell else {
            return .init()
        }
        
        cell.searchTitle = self.presenter.titles[indexPath.row]
        cell.onPasteTitleAction = { [ weak self ] title in
            self?.searchView.searchTextField.text = title
        }
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let title = (tableView.cellForRow(at: indexPath) as? SearchTitleTableViewCell)?.searchTitle?.title else { return }
        
        self.navigationController?.popViewController(animated: false)
        self.presenter.onTapSearchButtonAction(title)
    }
    
}

extension SearchViewController: SearchViewDelegate {
    
    func searchView(_ searchView: SearchView, didTapSearchButton button: UIButton) {
        self.navigationController?.popViewController(animated: false)
        
        guard let title = searchView.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else {
            searchView.searchTextField.resignFirstResponder()
            
            return
        }
        
        self.presenter.onTapSearchButtonAction(title)
        
        guard !self.presenter.titles.contains(where: { $0.title == title }) else {
            return
        }
        
        self.presenter.create(title)
        
    }
    
    func searchView(_ searchView: SearchView, didTapBackButton button: UIButton) { self.navigationController?.popViewController(animated: false) }
    func searchView(_ searchView: SearchView, editingSearchTextField textField: UITextField) {
        searchView.searchButton.isEnabled = !(searchView.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
    
}
