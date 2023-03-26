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
        
        if #available(iOS 13.0, *) {
            view.image = self.presenter.user.avatarData == nil ? UIImage(systemName: "plus") : UIImage(data: self.presenter.user.avatarData ?? Data())
        } else {
            view.image = self.presenter.user.avatarData == nil ? UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate) : UIImage(data: self.presenter.user.avatarData ?? Data())
        }
        
        view.backgroundColor = .textFieldColor
        view.tintColor = .lightGray
        view.layer.cornerRadius = 75
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
        
        if #available(iOS 13.0, *) {
            view.image = self.presenter.user.avatarData == nil ? UIImage(systemName: "plus") : UIImage(data: self.presenter.user.avatarData ?? Data())
        } else {
            view.image = self.presenter.user.avatarData == nil ? UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate) : UIImage(data: self.presenter.user.avatarData ?? Data())
        }
        
        view.backgroundColor = .textFieldColor
        view.tintColor = .lightGray
        view.layer.cornerRadius = 25
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
        view.font = .systemFont(ofSize: 16, weight: .regular)
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
        
        if #available(iOS 13.0, *) {
            view.image = UIImage(systemName: self.presenter.user.documentData == nil ? "square" : "checkmark.square")
        } else {
            view.image = UIImage(named: self.presenter.user.documentData == nil ? "square" : "checkmark.square")?.withRenderingMode(.alwaysTemplate)
        }
        view.tintColor = .accentColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCheckmarkImageView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let view = UILabel()
        
        view.numberOfLines = 0
        view.text = "*" + NSLocalizedString("Verified catteries are always marked for the buyer", comment: "")
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.isHidden = self.presenter.user.avatarData == nil ? true : false
        view.alpha = self.presenter.user.avatarData == nil ? 0 : 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var nameTextFieldAndTitle = self.view.createTextFieldsView(
        title: NSLocalizedString("Main", comment: ""),
        fields: [
            (
                placeholder: NSLocalizedString("Your name or your cattery name", comment: ""),
                text: self.presenter.user.name,
                action: { [ weak self ] textField in
                    self?.presenter.user.name = textField.text ?? "" }
            )
        ]
    )
    
    private let descriptionTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Description(optional)", comment: .init())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        
        view.text = self.presenter.user.description
        view.font = .systemFont(ofSize: 17)
        view.isScrollEnabled = false
        view.sizeToFit()
        view.textColor = .textColor
        view.tintColor = .accentColor
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.delegate = self
        view.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var avatarImagePickerControllerDelegate = AvatarImagePickerControllerDelegate { [ weak self ] image in
        self?.avatarImageView.image = image
        self?.presenter.user.avatarData = image.jpegData(compressionQuality: 0.7) ?? (UIImage(named: "empty avatar")?.pngData() ?? Data())
        
    }
    
    private lazy var documentImagePickerControllerDelegate = DocumentImagePickerControllerDelegate { [ weak self ] image in
        self?.documentImageView.image = image
        self?.presenter.user.documentData = image.jpegData(compressionQuality: 0.7)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    MARK: Setup Views
    
    private func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        self.title = NSLocalizedString("Edit profile", comment: String())
        
        if self.presenter.readUserDefaultsIsFirstEdititng() {
            self.navigationController?.navigationBar.isHidden = true
        } else {
            self.navigationController?.navigationBar.isHidden = false
        }
        
        self.view.backgroundColor = .backgroundColor
        
        self.avatarImagePickerController.delegate = self.avatarImagePickerControllerDelegate
        self.documentImagePickerController.delegate = self.documentImagePickerControllerDelegate
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.avatarImageView)
        self.scrollView.addSubview(self.nameTextFieldAndTitle)
        self.scrollView.addSubview(self.descriptionTitleLabel)
        self.scrollView.addSubview(self.descriptionTextView)
        self.scrollView.addSubview(self.checkmarkImageView)
        self.scrollView.addSubview(self.checkmarkLabel)
        self.scrollView.addSubview(self.catteryDocumentLabel)
        self.scrollView.addSubview(self.documentImageView)
        self.scrollView.addSubview(self.infoLabel)
        self.scrollView.addSubview(self.saveButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.avatarImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalToSuperview().inset(15)
            make.width.height.equalTo(150)
        }
        
        self.nameTextFieldAndTitle.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view).inset(15)
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-15)
        }
        
        self.descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextFieldAndTitle.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionTitleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.greaterThanOrEqualTo(50)
        }
        
        self.checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.descriptionTextView.snp.bottom).inset(-15)
            make.width.height.equalTo(50)
        }
        
        self.checkmarkLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.trailing.equalTo(self.checkmarkImageView.snp.leading).inset(-15)
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
        
        self.infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.documentImageView.snp.bottom).inset(-10)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(50)
            
            if self.presenter.user.avatarData == nil {
                make.top.equalTo(self.checkmarkLabel.snp.bottom).inset(-25)
            } else {
                make.top.equalTo(self.infoLabel.snp.bottom).inset(-25)
            }
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
        
        if self.presenter.user.isCatteryWaitVerify {
            guard self.presenter.user.documentData != nil else {
                self.presentAlert(
                    title: NSLocalizedString("Document photo is empty", comment: .init()),
                    message: NSLocalizedString("Attach a photo of the document or uncheck the box", comment: .init())
                )
                
                return
            }
        }
        
        if let deviceToken = self.presenter.readUserDefaultsDeviceToken() {
            self.presenter.user.deviceTokens.append(deviceToken)
        }
        
        self.presenter.editUser { error in
            self.error(error) { [ weak self ] in
                self?.presenter.writeUserDefaultsIsFirstEdititng()
                self?.presenter.writeUserDefaultsUserName()
                self?.presenter.goToMainTabBar()
                
                if self?.presenter.readUserDefaultsDeviceToken() != nil {
                    self?.presentAlert(title: NSLocalizedString("When your kennel is verified we will send you a notification", comment: ""))
                }
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
        if !self.presenter.user.isCatteryWaitVerify {
            self.presenter.user.isCatteryWaitVerify = true
            self.catteryDocumentLabel.isHidden = false
            self.documentImageView.isHidden = false
            self.infoLabel.isHidden = false
            
            if #available(iOS 13.0, *) {
                self.checkmarkImageView.image = UIImage(systemName: "checkmark.square")
            } else {
                self.checkmarkImageView.image = UIImage(named: "checkmark.square")?.withRenderingMode(.alwaysTemplate)
            }
            
            self.checkmarkImageView.tintColor = .accentColor
            
            UIView.animate(withDuration: 0.35) { [ weak self ] in
                guard let self = self else {
                    return
                }
                
                self.saveButton.frame.origin = CGPoint(
                    x: self.saveButton.frame.minX,
                    y: self.infoLabel.frame.maxY + 25
                )
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [ weak self ] in
                guard let self  = self else {
                    return
                }
                
                self.saveButton.snp.removeConstraints()
                
                self.saveButton.snp.makeConstraints { make in
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                    make.top.equalTo(self.infoLabel.snp.bottom).inset(-25)
                    make.bottom.equalToSuperview().inset(15)
                    make.height.equalTo(50)
                }
                
                UIView.animate(withDuration: 0.5) {
                    self.catteryDocumentLabel.alpha = 1
                    self.documentImageView.alpha = 1
                    self.infoLabel.alpha = 1
                }
            }
        } else {
            self.presenter.user.isCatteryWaitVerify = false
            
            if #available(iOS 13.0, *) {
                self.checkmarkImageView.image = UIImage(systemName: "square")
            } else {
                self.checkmarkImageView.image = UIImage(named: "square")?.withRenderingMode(.alwaysTemplate)
            }
            
            self.checkmarkImageView.tintColor = .accentColor
            
            UIView.animate(withDuration: 0.5) { [ weak self ] in
                self?.catteryDocumentLabel.alpha = 0
                self?.documentImageView.alpha = 0
                self?.infoLabel.alpha = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [ weak self ] in
                self?.catteryDocumentLabel.isHidden = true
                self?.documentImageView.isHidden = true
                self?.infoLabel.isHidden = true
                self?.presenter.user.documentData = nil
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [ weak self ] in
                guard let self = self else {
                    return
                }
                
                UIView.animate(withDuration: 0.35) { [ weak self ] in
                    guard let self = self else {
                        return
                    }
                    
                    self.saveButton.frame.origin = CGPoint(
                        x: self.saveButton.frame.minX,
                        y: self.checkmarkLabel.frame.maxY + 25
                    )
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.saveButton.snp.removeConstraints()
                    
                    self.saveButton.snp.makeConstraints { make in
                        make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                        make.top.equalTo(self.checkmarkLabel.snp.bottom).inset(-25)
                        make.bottom.equalToSuperview().inset(15)
                        make.height.equalTo(50)
                    }
                }
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
    
    fileprivate class AvatarImagePickerControllerDelegate: NSObject {
        private let callBack: (UIImage) -> Void
        
        init(callBack: @escaping (UIImage) -> Void) {
            self.callBack = callBack
            
            super.init()
        }
    }
    
    fileprivate class DocumentImagePickerControllerDelegate: NSObject {
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

extension EditProfileViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.presenter.user.description = textView.text.isEmpty ? nil : textView.text
    }
    
}
