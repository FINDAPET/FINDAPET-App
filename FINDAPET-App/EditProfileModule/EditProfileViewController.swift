//
//  EditProfileViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.08.2022.
//

import UIKit
import SnapKit

final class EditProfileViewController: UIViewController {

    private let presenter: EditProfilePresenter
    
    init(presenter: EditProfilePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let avatarImagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.allowsEditing = true
        view.sourceType = .photoLibrary
        
        return view
    }()
    
    private let documentImagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.allowsEditing = true
        view.sourceType = .photoLibrary
        
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .accentColor
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.saveButtonDidTap), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = self.presenter.user.avatarData == nil ? UIImage(systemName: "plus") : UIImage(data: self.presenter.user.avatarData ?? Data())
        view.backgroundColor = .textFieldColor
        view.tintColor = .lightGray
        view.layer.cornerRadius = 50
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showAvatarImagePickerController)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var documentImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = self.presenter.user.avatarData == nil ? UIImage(systemName: "plus") : UIImage(data: self.presenter.user.documentData ?? Data())
        view.backgroundColor = .textFieldColor
        view.tintColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.isHidden = self.presenter.user.avatarData == nil ? true : false
        view.isUserInteractionEnabled = true
        view.alpha = self.presenter.user.avatarData == nil ? 0 : 1
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showDocumentImagePickerController)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let checkmarkLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Register as a cattery(optional)", comment: "")
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var catteryDocumentLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Cattery documents", comment: "")
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.isHidden = self.presenter.user.avatarData == nil ? true : false
        view.alpha = self.presenter.user.avatarData == nil ? 0 : 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: self.presenter.user.documentData == nil ? "square" : "checkmark.square")
        view.image?.withTintColor(.accentColor)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCheckmarkImageView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var avatarImagePickerControllerDelegate = AvatarImagePickerControllerDelegate { [ weak self ] image in
        self?.avatarImageView.image = image
        self?.presenter.user.avatarData = image.pngData() ?? (UIImage(named: "empty avatar")?.pngData() ?? Data())
        
    }
    private lazy var documentImagePickerControllerDelegate = DocumentImagePickerControllerDelegate { [ weak self ] image in
        self?.documentImageView.image = image
        self?.presenter.user.documentData = image.pngData()
    }
    
//    MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    
    private func setupViews() {
        if self.presenter.readUserDefaultsIsFirstEdititng() {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        let basicTextFields = self.createTextFieldsView(
            title: NSLocalizedString("Main", comment: ""),
            fields: [
                (
                    placeholder: NSLocalizedString("Your name or your cattery name", comment: ""),
                    text: self.presenter.user.name,
                    action: { [ weak self ] textField in
                        self?.presenter.user.name = textField.text ?? "" }
                ),
                (
                    placeholder: NSLocalizedString("Description(optional)", comment: ""),
                    text: self.presenter.user.description,
                    action: { [ weak self ] textField in self?.presenter.user.description = textField.text }
                )
            ]
        )
        
        self.view.backgroundColor = .backgroundColor
        
        self.avatarImagePickerController.delegate = self.avatarImagePickerControllerDelegate
        self.documentImagePickerController.delegate = self.documentImagePickerControllerDelegate
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.avatarImageView)
        self.scrollView.addSubview(basicTextFields)
        self.scrollView.addSubview(self.checkmarkImageView)
        self.scrollView.addSubview(self.checkmarkLabel)
        self.scrollView.addSubview(self.catteryDocumentLabel)
        self.scrollView.addSubview(self.documentImageView)
        self.scrollView.addSubview(self.saveButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalToSuperview()
        }
        
        self.avatarImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalToSuperview().inset(25)
            make.width.height.equalTo(100)
        }
        
        basicTextFields.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view).inset(15)
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-15)
        }
        
        self.checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(basicTextFields.snp.bottom).inset(-15)
            make.width.height.equalTo(50)
        }
        
        self.checkmarkLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.trailing.equalTo(self.checkmarkImageView.snp.leading).inset(15)
            make.centerY.equalTo(self.checkmarkImageView)
        }
        
        self.catteryDocumentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.checkmarkImageView.snp.bottom).inset(-15)
        }
        
        self.documentImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.catteryDocumentLabel.snp.bottom).inset(-15)
            make.width.equalTo(self.documentImageView.snp.height)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.documentImageView.snp.bottom).inset(-15)
            make.bottom.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
        
    }
    
//    MARK: Actions
        
    @objc private func saveButtonDidTap() {
        guard self.presenter.user.name != "" else {
            self.presentAlert(
                title: NSLocalizedString("Name field is empty", comment: ""),
                message: NSLocalizedString("Fill in all required fields", comment: "")
            )
            
            return
        }
        
        guard (self.presenter.user.documentData != nil && self.presenter.user.isCatteryWaitVerify) ||
        (self.presenter.user.documentData == nil && !self.presenter.user.isCatteryWaitVerify) else {
            self.presentAlert(
                title: NSLocalizedString("Cattery document image is empty", comment: ""),
                message: NSLocalizedString("Fill in all required fields", comment: "")
            )
            
            return
        }
        
        if !self.presenter.user.isCatteryWaitVerify && self.presenter.user.documentData != nil {
            self.presenter.user.documentData = nil
        }
        
        self.presenter.editUser { error in
            self.error(error) { [ weak self ] in
                self?.presenter.writeUserDefaultsIsFirstEdititng()
                self?.presenter.goToMainTabBar()
                self?.presentAlert(title: NSLocalizedString("When your kennel is verified we will send you a notification", comment: ""))
            }
        }
    }
    
    @objc private func showAvatarImagePickerController() {
        self.present(self.avatarImagePickerController, animated: true)
    }
    
    @objc private func showDocumentImagePickerController() {
        self.present(self.documentImagePickerController, animated: true)
    }
    
    @objc private func didTapCheckmarkImageView() {
        if !self.presenter.user.isCatteryWaitVerify && self.presenter.readUserDefaultsIsFirstEdititng() {
            self.presenter.user.isCatteryWaitVerify = true
            self.catteryDocumentLabel.isHidden = false
            self.documentImageView.isHidden = false
            self.checkmarkImageView.image = UIImage(systemName: "checkmark.square")
            self.checkmarkImageView.image?.withTintColor(.accentColor)
            
            UIView.animate(withDuration: 0.5) { [ weak self ] in
                self?.catteryDocumentLabel.alpha = 1
                self?.documentImageView.alpha = 1
            }
        } else if self.presenter.readUserDefaultsIsFirstEdititng() {
            self.presenter.user.isCatteryWaitVerify = false
            self.checkmarkImageView.image = UIImage(systemName: "square")
            self.checkmarkImageView.image?.withTintColor(.accentColor)
            
            UIView.animate(withDuration: 0.5) { [ weak self ] in
                self?.catteryDocumentLabel.alpha = 0
                self?.documentImageView.alpha = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [ weak self ] in
                self?.catteryDocumentLabel.isHidden = true
                self?.documentImageView.isHidden = true
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
    
//    MARK: Classes
    
    class AvatarImagePickerControllerDelegate: NSObject {
        private let callBack: (UIImage) -> Void
        
        init(callBack: @escaping (UIImage) -> Void) {
            self.callBack = callBack
            
            super.init()
        }
    }
    
    class DocumentImagePickerControllerDelegate: NSObject {
        private let callBack: (UIImage) -> Void
        
        init(callBack: @escaping (UIImage) -> Void) {
            self.callBack = callBack
            
            super.init()
        }
    }
    
}

extension EditProfileViewController.AvatarImagePickerControllerDelegate: UINavigationControllerDelegate { }

extension EditProfileViewController.AvatarImagePickerControllerDelegate: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.callBack(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

extension EditProfileViewController.DocumentImagePickerControllerDelegate: UINavigationControllerDelegate { }

extension EditProfileViewController.DocumentImagePickerControllerDelegate: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.callBack(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
