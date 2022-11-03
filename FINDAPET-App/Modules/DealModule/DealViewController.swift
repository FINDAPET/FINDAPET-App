//
//  DealViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import UIKit
import SnapKit

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
    
    private let collectionViewItemNumberLabel: UILabel = {
        let view = UILabel()
        
        view.backgroundColor = .black
        view.alpha = 0.5
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.textColor = .white
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
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
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var chatButton: UIButton = {
        let view = UIButton()
        
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
        
        view.addTarget(self, action: #selector(self.didTapCreateOfferButton), for: .touchUpInside)
        view.setTitle(NSLocalizedString("Make Offer", comment: String()), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 25
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dealDescriptionView: UIView = {
        guard let deal = self.presenter.deal else {
            return .init()
        }
        
        let view = DealDescriptionView(deal: deal)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dealProfileView: UIView = {
        guard let user = self.presenter.deal?.cattery else {
            return .init()
        }
        
        let view = DealProfileView(user: user, avatarImageTapAction: self.presenter.goToProfile)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let viewsCountLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = .zero
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
            UIView.animate(withDuration: 0.2) {
                viewController?.view.alpha = .zero
                self?.translutionView.alpha = .zero
            } completion: { isComplete in
                if isComplete {
                    self?.translutionView.isHidden = true
                    viewController?.view.removeFromSuperview()
                }
            }
        }
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.presenter.dealID != nil {
            self.presenter.getDeal { [ weak self ] _, error in
                self?.error(error) {
                    self?.setupValues()
                }
            }
        } else {
            self.setupValues()
        }
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: String())
        
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
        
        if self.presenter.deal?.cattery.id ?? UUID() == self.presenter.getUserID() ?? UUID() {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: .init(systemName: "trash"),
                style: .plain,
                target: self,
                action: #selector(self.didTapDeleteNavigationBarButton)
            )
            self.navigationItem.rightBarButtonItem?.tintColor = .accentColor
            
            self.dealDescriptionView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                make.top.equalTo(self.createOfferButton.snp.bottom).inset(-15)
            }
        } else {
            self.scrollView.addSubview(self.chatButton)
            self.scrollView.addSubview(self.createOfferButton)
            
            self.chatButton.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                make.top.equalTo(self.titleLabel.snp.bottom).inset(-25)
                make.height.equalTo(50)
            }
            
            self.createOfferButton.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                make.top.equalTo(self.chatButton.snp.bottom).inset(-15)
                make.height.equalTo(50)
            }
            
            self.dealDescriptionView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
                make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
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
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.collectionView.snp.bottom).inset(-15)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(self.titleLabel.snp.trailing).inset(-15)
            make.centerY.equalTo(self.titleLabel)
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
        self.priceLabel.text = "\(self.presenter.deal?.price ?? .zero) \(self.presenter.deal?.currencyName ?? String())"
        self.viewsCountLabel.text = "\(self.presenter.deal?.viewsCount ?? .zero) \(NSLocalizedString("Views", comment: String()))"
        self.collectionViewItemNumberLabel.text = "1/\(self.presenter.deal?.photoDatas.count ?? 1)"
    }
    
//    MARK: Actions
    @objc private func didTapChatButton() {
//        self.presenter.goToChatRoom(with: <#T##UUID#>)
    }
    
    @objc private func didTapTranslutionView() {
        UIView.animate(withDuration: 0.2) { [ weak self ] in
            self?.createOfferViewController?.view.alpha = .zero
            self?.translutionView.alpha = .zero
        } completion: { [ weak self ] isComplete in
            if isComplete {
                self?.translutionView.isHidden = true
                self?.createOfferViewController?.view.removeFromSuperview()
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
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        ))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: String()), style: .cancel))
        
        self.present(alertController, animated: true)
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
        return 30
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
