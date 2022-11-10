//
//  ChatsViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import UIKit
import SnapKit

final class ChatRoomsViewController: UIViewController {

    private let presenter: ChatRoomsPresenter
    
    init(presenter: ChatRoomsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.startAnimating()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.separatorColor = .clear
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.isHidden = false
        view.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.id)
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
        
        self.presenter.updateUserChats()
        self.presenter.getAllChatRooms { [ weak self ] _, error in
            self?.error(error) { [ weak self ] in
                self?.activityIndicatorView.isHidden = true
                self?.tableView.isHidden = false
            }
        }
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.title = NSLocalizedString("Chats", comment: String())
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        self.view.addSubview(self.activityIndicatorView)
        self.view.addSubview(self.tableView)
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

//MARK: Extensions
extension ChatRoomsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter.chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomTableViewCell.id) as? ChatRoomTableViewCell else {
            return UITableViewCell()
        }
        
        cell.chatRoom = self.presenter.chatRooms[indexPath.row]
        
        return cell
    }
    
}

extension ChatRoomsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.presenter.goToChatRoom(self.presenter.chatRooms[indexPath.row])
    }
    
}
