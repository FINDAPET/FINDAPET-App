//
//  ComplaintViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.12.2022.
//

import UIKit
import SnapKit

final class ComplaintViewController: UIViewController {
    
    private let presenter: ComplaintPresenter
    
    init(presenter: ComplaintPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    var didTapSendButtonCallBack: (() -> Void)?
    
//    MARK: UI Properties
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Complaint", comment: .init())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        
        view.text = self.presenter.complaint.text
        view.font = .systemFont(ofSize: 17)
        view.textColor = .textColor
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 25
        view.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("Send", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .accentColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.isEnabled = !self.presenter.complaint.text.isEmpty
        view.addTarget(self, action: #selector(self.didTapSendButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.textView)
        self.view.addSubview(self.sendButton)
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.textView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-10)
            make.height.equalTo(300)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.textView.snp.bottom).inset(-15)
            make.height.equalTo(50)
        }
    }
    
//    MARK: Actions
    @objc private func didTapSendButton() {
        self.didTapSendButtonCallBack?()
        self.presenter.makeComplaint()
    }
    
}

extension ComplaintViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.sendButton.isEnabled = !self.presenter.complaint.text.isEmpty
        self.presenter.editText(textView.text)
    }
    
}
