//
//  DealViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import UIKit
import SnapKit
import JGProgressHUD

final class DealViewController: UIViewController {

    private let presenter: DealPresenter
    
    init(presenter: DealPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.collectionView.reloadData() }
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
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.dataSource = self
        view.delegate = self
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.id)
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        (view.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var collectionViewItemNumberLabel: UILabel = {
        let view = UILabel()
        
        view.backgroundColor = .black
        view.alpha = 0.5
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.textColor = .white
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        view.isHidden = self.presenter.deal?.photoDatas.count ?? .zero <= 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .textColor
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var chatButton: UIButton = {
        let view = UIButton()
        
        view.isHidden = self.presenter.deal?.cattery.id == self.presenter.getUserID()
        view.addTarget(self, action: #selector(self.didTapChatButton), for: .touchUpInside)
        view.setTitle(NSLocalizedString("Message", comment: String()), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 25
        view.backgroundColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var createOfferButton: UIButton = {
        let view = UIButton()
        
        view.isHidden = self.presenter.deal?.cattery.id == self.presenter.getUserID()
        view.addTarget(self, action: #selector(self.didTapCreateOfferButton), for: .touchUpInside)
        view.setTitle(NSLocalizedString("Make Offer", comment: String()), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemGreen
        view.isEnabled = self.presenter.deal?.buyer == nil
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
//    full version
//    private lazy var makePremiumButton: UIButton = {
//        let view = UIButton()
//
//        view.isHidden = self.presenter.deal?.cattery.id != self.presenter.getUserID()
//        view.addTarget(self, action: #selector(self.didTapMakePremiumButton), for: .touchUpInside)
//        view.setTitle(NSLocalizedString("Make Premium", comment: String()), for: .normal)
//        view.setTitleColor(.white, for: .normal)
//        view.layer.cornerRadius = 25
//        view.backgroundColor = .systemOrange
//        view.isEnabled = self.presenter.deal?.buyer == nil
//        view.isHidden = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
    
    private lazy var dealDescriptionView: UIView = {
        guard let deal = self.presenter.deal else {
            return .init()
        }
        
        let view = DealDescriptionView(deal: deal)
        
        view.didTapBuyerAvatarImageViewAction = { [ weak self ] id in
            guard let profileViewController = self?.presenter.getProfile(with: id) else {
                return
            }
            
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dealProfileView: UIView = {
        guard let user = self.presenter.deal?.cattery else {
            return .init()
        }
        
        let view = DealProfileView(user: user) { [ weak self ] in
            guard let profileViewController = self?.presenter.getProfile(with: user.id) else {
                return
            }
            
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var viewsCountLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = .zero
        view.isHidden = self.presenter.deal?.photoDatas.isEmpty ?? true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var translutionView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .black
        view.alpha = .zero
        view.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapTranslutionView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var createOfferViewController: CreateOfferViewController? = {
        let viewController = self.presenter.getCreateOffer()
        
        viewController?.view.backgroundColor = .backgroundColor
        viewController?.view.layer.cornerRadius = 25
        viewController?.view.alpha = .zero
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        viewController?.callBack = { [ weak self ] in
            self?.presenter.notificationCenterManagerPostUpdateProfileScreen()
            UIView.animate(withDuration: 0.2) {
                viewController?.view.alpha = .zero
                self?.translutionView.alpha = .zero
                self?.navigationController?.navigationBar.layer.zPosition = 1
                self?.tabBarController?.tabBar.layer.zPosition = 1
            } completion: { isComplete in
                guard isComplete else { return }
                
                viewController?.view.removeFromSuperview()
                self?.translutionView.isHidden = true
                self?.navigationController?.navigationBar.isHidden = false
                self?.tabBarController?.tabBar.isHidden = false
            }
        }
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private lazy var complaintViewController: ComplaintViewController? = {
        let viewController = self.presenter.getComplaint()
        
        viewController?.view.clipsToBounds = true
        viewController?.view.layer.masksToBounds = true
        viewController?.view.layer.cornerRadius = 25
        viewController?.view.alpha = .zero
        viewController?.didTapSendButtonCallBack = { [ weak self ] in
            UIView.animate(withDuration: 0.2) {
                viewController?.view.alpha = .zero
                self?.translutionView.alpha = .zero
                self?.navigationController?.navigationBar.layer.zPosition = 1
                self?.tabBarController?.tabBar.layer.zPosition = 1
            } completion: { isComplete in
                guard isComplete else { return }
                
                viewController?.view.removeFromSuperview()
                self?.translutionView.isHidden = true
                self?.navigationController?.navigationBar.isHidden = false
                self?.tabBarController?.tabBar.isHidden = false
            }
        }
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
    private let progressIndicator: JGProgressHUD = {
        let view = JGProgressHUD()
        
        view.textLabel.text = NSLocalizedString("Loading", comment: .init())
        
        return view
    }()
    
    private lazy var browseImagesViewController = self.presenter.getBrowseImage(self)
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.presenter.dealID != nil {
            self.scrollView.alpha = .zero
            self.progressIndicator.show(in: self.view, animated: true)
            self.presenter.getDeal { [ weak self ] _, error in
                self?.progressIndicator.dismiss(animated: true)
                
                self?.error(error) {
                    self?.setupValues()
                    
                    UIView.animate(withDuration: 0.2) { [ weak self ] in
                        self?.scrollView.alpha = 1
                    }
                } onErrorAction: { [ weak self ] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.presenter.viewDeal()
            self.setupValues()
        }
        
        self.presenter.notificationCenterManagerAddObserverUpdateDealScreen(self, action: #selector(self.updateScreen))
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = .clear
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        
        if #available(iOS 13.0, *) {
            self.tabBarController?.tabBar.standardAppearance.backgroundColor = .clear
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: String())
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)
        ))
        
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.translutionView)
        self.view.insertSubview(self.translutionView, at: 9)
        
        self.scrollView.addSubview(self.collectionView)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.priceLabel)
        self.scrollView.addSubview(self.dealDescriptionView)
        self.scrollView.addSubview(self.dealProfileView)
        self.scrollView.addSubview(self.viewsCountLabel)
        self.scrollView.addSubview(self.collectionViewItemNumberLabel)
        self.scrollView.insertSubview(self.collectionViewItemNumberLabel, at: 8)
        
        if self.presenter.deal?.buyer == nil, self.presenter.deal?.cattery.id != self.presenter.getUserID() {
            if #available(iOS 13.0, *) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: .init(systemName: "exclamationmark.triangle"),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapComplaintNavigationBarButton)
                )
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: .init(named: "exclamationmark.triangle")?.withRenderingMode(.alwaysTemplate),
                    style: .plain,
                    target: self,
                    action: #selector(self.didTapComplaintNavigationBarButton)
                )
            }
            self.navigationItem.rightBarButtonItem?.tintColor = .accentColor
//            full version
//            self.makePremiumButton.isHidden = true

            self.scrollView.addSubview(self.chatButton)
            self.scrollView.addSubview(self.createOfferButton)

            self.chatButton.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                make.top.equalTo(self.priceLabel.snp.bottom).inset(-25)
                make.height.equalTo(50)
            }

            self.createOfferButton.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                make.top.equalTo(self.chatButton.snp.bottom).inset(-15)
                make.height.equalTo(50)
            }

            self.dealDescriptionView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                make.top.equalTo(self.createOfferButton.snp.bottom).inset(-15)
            }
        } else {
            if self.presenter.deal?.buyer == nil {
                if #available(iOS 13.0, *) {
                    self.navigationItem.rightBarButtonItems = [
                        .init(
                            image: .init(systemName: "trash"),
                            style: .plain,
                            target: self,
                            action: #selector(self.didTapDeleteNavigationBarButton)
                        ),
                        .init(
                            image: .init(systemName: "square.and.pencil"),
                            style: .plain,
                            target: self,
                            action: #selector(self.didTapEditBarButtonItem)
                        )
                    ]
                } else {
                    self.navigationItem.rightBarButtonItems = [
                        .init(
                            image: .init(named: "trash")?.withRenderingMode(.alwaysTemplate),
                            style: .plain,
                            target: self,
                            action: #selector(self.didTapDeleteNavigationBarButton)
                        ),
                        .init(
                            image: .init(named: "square.and.pencil")?.withRenderingMode(.alwaysTemplate),
                            style: .plain,
                            target: self,
                            action: #selector(self.didTapEditBarButtonItem)
                        )
                    ]
                }
            }
            
            self.chatButton.isHidden = true
            self.createOfferButton.isHidden = true
                        
            if !(self.presenter.deal?.isPremiumDeal ?? false) && self.presenter.deal?.cattery.id == self.presenter.getUserID() {
//                full version
//                self.scrollView.addSubview(self.makePremiumButton)
//
//                self.makePremiumButton.snp.makeConstraints { make in
//                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
//                    make.top.equalTo(self.priceLabel.snp.bottom).inset(-15)
//                    make.height.equalTo(50)
//                }
                
                self.dealDescriptionView.snp.makeConstraints { make in
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
//                    full version
//                    make.top.equalTo(self.makePremiumButton.snp.bottom).inset(-15)
                    make.top.equalTo(self.priceLabel.snp.bottom).inset(-15)
                }
            } else {
//                full version
//                self.makePremiumButton.isHidden = true
                
                self.dealDescriptionView.snp.makeConstraints { make in
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                    make.top.equalTo(self.priceLabel.snp.bottom).inset(-15)
                }
            }
        }

        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
            make.height.equalTo(self.view.safeAreaLayoutGuide.snp.width)
        }
        
        self.collectionViewItemNumberLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.collectionView)
            make.bottom.equalTo(self.collectionView).inset(30)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.collectionView.snp.bottom).inset(-15)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }

        self.dealProfileView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.dealDescriptionView.snp.bottom).inset(-15)
        }

        self.viewsCountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalToSuperview().inset(60)
            make.top.equalTo(self.dealProfileView.snp.bottom).inset(-25)
        }
        
        self.translutionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
//    MARK: Setup Values
    private func setupValues() {
        self.titleLabel.text = self.presenter.deal?.title
        self.priceLabel.text = self.presenter.deal?.price != nil ? "\(Int(self.presenter.deal?.price?.rounded(.up) ?? .zero)) \(self.presenter.deal?.currencyName ?? .init())" : NSLocalizedString("Price as agreed", comment: .init())
        self.viewsCountLabel.text = "\(self.presenter.deal?.viewsCount ?? .zero) \(NSLocalizedString("Views", comment: .init()))"
        self.viewsCountLabel.isHidden = self.presenter.deal?.photoDatas.isEmpty ?? true
        self.collectionViewItemNumberLabel.text = "1/\(self.presenter.deal?.photoDatas.count ?? 1)"
        self.collectionViewItemNumberLabel.isHidden = self.presenter.deal?.photoDatas.count ?? .zero <= 1
    }
    
//    MARK: Actions
    @objc private func didTapEditBarButtonItem() {
        guard let editDealViewController = self.presenter.getEditDeal() else {
            return
        }
        
        self.navigationController?.pushViewController(editDealViewController, animated: true)
    }
    
    @objc private func didTapChatButton() {
        guard let chatRoomViewController = self.presenter.getChatRoom() else {
            return
        }
        
        self.navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    @objc private func updateScreen() {
        self.progressIndicator.show(in: self.view, animated: true)
        self.presenter.getDeal { [ weak self ] _, _ in
            self?.progressIndicator.dismiss(animated: true)
        }
    }
    
    @objc private func didTapMakePremiumButton() {
        self.presenter.getPremiumDealProduct { [ weak self ] products in
            guard let product = products.first else {
                print("❌ Error: not found.")
                
                self?.presentAlert(title: NSLocalizedString("Not Found", comment: String()))
                
                return
            }
            
            self?.presenter.makePayment(product) { error in
                self?.error(error) {
                    self?.presenter.makeDealPremium()
                    self?.presenter.changeDeal { error in
                        self?.error(error) {
                            self?.presenter.notificationCenterManagerPostUpdateProfileScreen()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didTapTranslutionView() {
        UIView.animate(withDuration: 0.2) { [ weak self ] in
            self?.createOfferViewController?.view.alpha = .zero
            self?.complaintViewController?.view.alpha = .zero
            self?.translutionView.alpha = .zero
            self?.navigationController?.navigationBar.layer.zPosition = 1
            self?.tabBarController?.tabBar.layer.zPosition = 1
        } completion: { [ weak self ] isComplete in
            if isComplete {
                self?.translutionView.isHidden = true
                self?.createOfferViewController?.view.removeFromSuperview()
                self?.complaintViewController?.view.removeFromSuperview()
                self?.navigationController?.navigationBar.isHidden = false
                self?.tabBarController?.tabBar.isHidden = false
            }
        }
    }
    
    @objc private func didTapCreateOfferButton() {
        self.addChild(self.createOfferViewController ?? UIViewController())
        self.view.addSubview(self.createOfferViewController?.view ?? UIView())
        self.view.insertSubview(self.createOfferViewController?.view ?? UIView(), at: 10)
        
        self.createOfferViewController?.view.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        self.translutionView.isHidden = false
        
        UIView.animate(withDuration: 0.2) { [ weak self ] in
            self?.createOfferViewController?.view.alpha = 1
            self?.translutionView.alpha = 0.5
            self?.navigationController?.navigationBar.layer.zPosition = -1
            self?.tabBarController?.tabBar.layer.zPosition = -1
        }
    }
    
    @objc private func didTapComplaintNavigationBarButton() {
        guard let complaintViewController  = self.complaintViewController else {
            return
        }
        
        self.addChild(complaintViewController)
        self.view.addSubview(complaintViewController.view)
        self.view.insertSubview(complaintViewController.view, at: 10)
        
        complaintViewController.view.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(25)
        }
        
        self.translutionView.isHidden = false
        
        UIView.animate(withDuration: 0.2) { [ weak self ] in
            self?.complaintViewController?.view.alpha = 1
            self?.translutionView.alpha = 0.5
            self?.navigationController?.navigationBar.layer.zPosition = -1
            self?.tabBarController?.tabBar.layer.zPosition = -1
        }
    }
    
    @objc private func didTapDeleteNavigationBarButton() {
        let alertController = UIAlertController(
            title: NSLocalizedString("You definitely want to delete this deal?", comment: String()),
            message: nil,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("Delete", comment: String()),
            style: .destructive,
            handler: { [ weak self ] _ in
                self?.presenter.deleteDeal { error in
                    self?.error(error) {
                        self?.presenter.notificationCenterManagerPostUpdateProfileScreen()
                        self?.presenter.notificationCenterManagerPostMakeFeedEmpty()
                        self?.presenter.notificationCenterManagerPostMakeFeedRefreshing()
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        ))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: String()), style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}

//MARK: Extensions
extension DealViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.deal?.photoDatas.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.id,
            for: indexPath
        ) as? PhotoCollectionViewCell,
              let data = self.presenter.deal?.photoDatas[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.image = .init(data: data)
        
        return cell
    }
    
}

extension DealViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewController = self.browseImagesViewController else {
            return
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.scrollToImage(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionViewItemNumberLabel.text = "\(indexPath.item + 1)/\(self.presenter.deal?.photoDatas.count ?? 1)"
    }
    
}

extension DealViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(
            width: collectionView.frame.width - 30,
            height: collectionView.frame.width - 30
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(
            top: .zero,
            left: (collectionView.frame.width - (collectionView.frame.width - 30)) / 2,
            bottom: .zero,
            right: (collectionView.frame.width - (collectionView.frame.width - 30)) / 2
        )
    }
    
}

extension DealViewController: BrowseImagesViewControllerDataSource {
    
    func browseImagesViewController(_ viewController: BrowseImagesViewController, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.deal?.photoDatas.count ?? .zero
    }
    
    func browseImagesViewController(_ viewController: BrowseImagesViewController, collectionView: UICollectionView, imageForItemAt indexPath: IndexPath) -> UIImage? {
        guard let data = self.presenter.deal?.photoDatas[indexPath.item] else {
            return nil
        }
        
        return .init(data: data)
    }
    
}
