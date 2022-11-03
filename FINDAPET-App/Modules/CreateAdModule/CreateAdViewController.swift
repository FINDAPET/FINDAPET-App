//
//  CreateAdViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.10.2022.
//

import UIKit
import SnapKit

final class CreateAdViewController: UIViewController {
    
    private let presenter: CreateAdPresenter
    
    init(presenter: CreateAdPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
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
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var avatarImagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.allowsEditing = true
        view.sourceType = .photoLibrary
        view.delegate = self
        
        return view
    }()
    
    private lazy var contentImagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.allowsEditing = true
        view.sourceType = .photoLibrary
        view.delegate = self
        
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "plus"))
        
        view.backgroundColor = .textFieldColor
        view.tintColor = .lightGray
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 75
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapAvatarImageView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var contentImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "plus"))
        
        view.backgroundColor = .textFieldColor
        view.tintColor = .lightGray
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapContentImageView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameTextField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .textFieldColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.placeholder = NSLocalizedString("Name", comment: String())
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let linkTextField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .textFieldColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.placeholder = NSLocalizedString("Link(optional)", comment: String())
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        
        view.layer.cornerRadius = 25
        view.setTitleColor(.white, for: .normal)
        view.setTitle(NSLocalizedString("Save", comment: String()), for: .normal)
        view.backgroundColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapSaveButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        if self.presenter.user == nil {
            self.presenter.getUser { [ weak self ] user, error in
                self?.error(error) {
                    guard let user = user else {
                        self?.presentAlert(title: NSLocalizedString("Not Found", comment: String()))
                        
                        return
                    }
                    
                    self?.presenter.user = user
                    self?.setupValues()
                }
            }
        }
        
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
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        self.title = NSLocalizedString("Create Ad", comment: String())
        
        
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.activityIndicatorView)
        
        self.scrollView.addSubview(self.avatarImageView)
        self.scrollView.addSubview(self.nameTextField)
        self.scrollView.addSubview(self.contentImageView)
        self.scrollView.addSubview(self.linkTextField)
        self.scrollView.addSubview(self.saveButton)
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalToSuperview().inset(15)
            make.width.height.equalTo(150)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.centerY.equalTo(self.avatarImageView)
            make.height.equalTo(50)
        }
        
        self.contentImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-15)
            make.height.equalTo(self.contentImageView.snp.width)
        }
        
        self.linkTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.contentImageView.snp.bottom).inset(-15)
            make.height.equalTo(50)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.linkTextField.snp.bottom).inset(-25)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
//    MARK: Setup Values
    private func setupValues() {
        guard let user = self.presenter.user else {
            self.scrollView.isHidden = true
            self.activityIndicatorView.isHidden = false
            
            return
        }
        
        self.scrollView.isHidden = false
        self.activityIndicatorView.isHidden = true
        self.nameTextField.text = user.name
        
        if let data = user.avatarData {
            self.avatarImageView.image = UIImage(data: data)
        }
    }
    
//    MARK: Actions
    @objc private func didTapAvatarImageView() {
        self.present(self.avatarImagePickerController, animated: true)
    }
    
    @objc private func didTapContentImageView() {
        self.present(self.contentImagePickerController, animated: true)
    }
    
    @objc private func didTapSaveButton() {
        self.presenter.createAd(
            ad: Ad.Input(
                contentData: self.contentImageView.image?.pngData() ?? Data(),
                customerName: self.nameTextField.text,
                link: self.linkTextField.text,
                catteryID: self.presenter.user?.id
            )
        ) { [ weak self ] error in
            self?.error(error) {
                self?.presenter.goToProfile()
            }
        }
    }
    
    @objc private func keyboadWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentInset.bottom = keyboardSize.height
            self.scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height,
                right: 0
            )
            self.scrollView.setContentOffset(CGPoint(x: 0, y: max(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0) ), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset.bottom = .zero
        self.scrollView.verticalScrollIndicatorInsets = .zero
    }
    
}

//MARK: Extensions
extension CreateAdViewController: UINavigationControllerDelegate { }

extension CreateAdViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker == self.avatarImagePickerController {
            
        } else {
            
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
