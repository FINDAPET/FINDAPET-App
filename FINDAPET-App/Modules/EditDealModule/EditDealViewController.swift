//
//  EditDealViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.11.2022.
//

import UIKit
import SnapKit

final class EditDealViewController: UIViewController {
    
    private let presenter: EditDealPresenter
    
    init(presenter: EditDealPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] deal in
            self?.noPhotosLabel.isHidden = !deal.photoDatas.isEmpty
            self?.noTagsLabel.isHidden = !deal.tags.isEmpty
            self?.photosCollectionView.reloadData()
            self?.photosCollectionView.snp.removeConstraints()
            self?.photosCollectionView.snp.makeConstraints { make in
                guard let self = self else {
                    return
                }
                
                make.leading.trailing.equalToSuperview().inset(15)
                make.top.equalTo(self.photosTitle.snp.bottom).inset(-10)
                make.height.equalTo(self.photosCollectionViewHeight != .zero ? self.photosCollectionViewHeight : 10)
                
                if !deal.photoDatas.isEmpty {
                    make.bottom.equalToSuperview().inset(15)
                }
            }
            self?.tagsCollectionView.reloadData()
            self?.tagsCollectionView.layoutIfNeeded()
        }
        self.presenter.secondCallBack = { [ weak self ] in
            self?.petTypeCollectionView.reloadData()
            self?.petTypeCollectionView.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    private var photosCollectionViewHeight: CGFloat {
        (((self.presenter.deal.photoDatas.count % 2 == .zero ? .zero : 1) +
          CGFloat(Int(self.presenter.deal.photoDatas.count / 2))) *
         (self.view.safeAreaLayoutGuide.layoutFrame.width - 45) / 2)
    }
    private lazy var selectedIsMale = self.presenter.deal.isMale
    private lazy var selectedPetType = self.presenter.petTypes.first(where: { [ weak self ] petType in
        petType.id == self?.presenter.deal.petTypeID
    }) {
        willSet {
            if self.selectedPetType != nil && self.selectedPetType?.id != newValue?.id {
                self.breedValueLabel.text = "Other"
            }
        }
    }
    
//    MARK: UI Properties
    private lazy var imagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.allowsEditing = true
        view.sourceType = .photoLibrary
        view.delegate = self
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let photosTitle: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Photos", comment: .init())
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .textColor
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var photosPlusButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "plus"), for: .normal)
        } else {
            view.setImage(.init(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        view.tintColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapPhotosPlusButton), for: .touchUpInside)
        view.imageView?.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(
            ImageWithXmarkCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageWithXmarkCollectionViewCell.id
        )
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var noPhotosLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("No Photos", comment: .init())
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 24)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.isHidden = !self.presenter.deal.photoDatas.isEmpty
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let firstContentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let secondContentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Title", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleTextView: UITextView = {
        let view = UITextView()
        
        view.text = self.presenter.deal.title
        view.font = .systemFont(ofSize: 17)
        view.isScrollEnabled = false
        view.sizeToFit()
        view.textColor = .textColor
        view.tintColor = .accentColor
        view.backgroundColor = .backgroundColor
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
    
    private let descriptionTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Description", comment: .init()))(\(NSLocalizedString("optional", comment: .init()))):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        
        view.text = self.presenter.deal.description
        view.font = .systemFont(ofSize: 17)
        view.isScrollEnabled = false
        view.sizeToFit()
        view.textColor = .textColor
        view.tintColor = .accentColor
        view.backgroundColor = .backgroundColor
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
    
    private let modeTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Mode", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var modeValueLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.presenter.deal.mode?.rawValue ?? DealMode.everywhere.rawValue
        view.textColor = .accentColor
        view.backgroundColor = .backgroundColor
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapModeValueLabel)))
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let petTypeTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Pet Type", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var petTypeCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.register(PetTypeCollectionViewCell.self, forCellWithReuseIdentifier: PetTypeCollectionViewCell.id)
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let breedTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Breed", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var breedValueLabel: UILabel = {
        let view = UILabel()
        let petBreedID = self.presenter.deal.petBreedID
        
        view.text = self.presenter.allBreeds.first { $0.id == petBreedID }?.name ?? NSLocalizedString(
            "Not Selected(breed)",
            comment: .init()
        )
        view.textColor = .accentColor
        view.backgroundColor = .backgroundColor
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapBreedValueLabel)))
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let petClassTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Pet Class", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var petClassValueLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.presenter.deal.petClass?.rawValue ?? PetClass.allClass.rawValue
        view.textColor = .accentColor
        view.backgroundColor = .backgroundColor
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapPetClassValueLabel)))
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let sexTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Sex", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sexCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        view.register(SexCollectionViewCell.self, forCellWithReuseIdentifier: SexCollectionViewCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let locationTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Location", comment: .init()))(\(NSLocalizedString("optional", comment: .init()))):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var countryTextField: UITextField = {
        let view = UITextField()
        
        view.text = self.presenter.deal.id != nil ? self.presenter.deal.country : self.presenter.getCountry()
        view.textColor = .textColor
        view.backgroundColor = .backgroundColor
        view.placeholder = NSLocalizedString("Country", comment: "")
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.addTarget(self, action: #selector(self.editingCountryTextField(_:)), for: .allEditingEvents)
         
        return view
    }()
    
    private lazy var cityTextField: UITextField = {
        let view = UITextField()
        
        view.text = self.presenter.deal.id != nil ? self.presenter.deal.city : self.presenter.getCity()
        view.textColor = .textColor
        view.backgroundColor = .backgroundColor
        view.placeholder = NSLocalizedString("City", comment: "")
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.addTarget(self, action: #selector(self.editingCityTextField(_:)), for: .allEditingEvents)
        view.rightViewMode = .always
         
        return view
    }()
    
    private let colorTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Color", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var colorTextField: UITextField = {
        let view = UITextField()
        
        view.text = self.presenter.deal.color
        view.textColor = .textColor
        view.backgroundColor = .backgroundColor
        view.placeholder = NSLocalizedString("Color", comment: "")
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.addTarget(self, action: #selector(self.editingColorTextField(_:)), for: .allEditingEvents)
        view.rightViewMode = .always
         
        return view
    }()
    
    private let birthDateLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Birth Date", comment: .init()) + ":"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var birthDatePicker: UIDatePicker = {
        let view = UIDatePicker()
        
        view.setDate(ISO8601DateFormatter().date(from: self.presenter.deal.birthDate) ?? .init(), animated: false)
        view.backgroundColor = .textFieldColor
        view.tintColor = .accentColor
        view.datePickerMode = .date
        view.addTarget(self, action: #selector(self.setBirthDate(_:)), for: .editingDidEnd)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Price", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var priceTextField: UITextField = {
        let view = UITextField()
        
        view.text = .init(Int(self.presenter.deal.price?.rounded(.up) ?? .zero))
        view.keyboardType = .numberPad
        view.textColor = .textColor
        view.tintColor = .accentColor
        view.backgroundColor = .backgroundColor
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.placeholder = NSLocalizedString("Price", comment: String())
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.addTarget(self, action: #selector(self.editingPriceTextField), for: .allEditingEvents)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var currencyButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .backgroundColor
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.setTitle(self.presenter.deal.currencyName.rawValue, for: .normal)
        view.setTitleColor(.accentColor, for: .normal)
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 25
        view.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addTarget(self, action: #selector(self.didTapCurrencyButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let thirdContentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let premiumDealTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Make Premium", comment: .init()))*"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var premiumDealSwitch: UISwitch = {
        let view = UISwitch()
        
        view.setOn(
            self.presenter.getNextDealIsPremium() ?? false ||
            self.presenter.getPremiumUserDate() ?? .init() > .init() ||
            self.presenter.deal.isPremiumDeal,
            animated: false
        )
        view.isEnabled = !(
            self.presenter.getNextDealIsPremium() ?? false ||
            self.presenter.getPremiumUserDate() ?? .init() > .init() ||
            self.presenter.deal.isPremiumDeal
        )
        view.tintColor = .backgroundColor
        view.onTintColor = .accentColor
        view.addTarget(self, action: #selector(self.premiumDealSwitchValueChanged(_:)), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let premiumDealDescriptionLabel: UILabel = {
        let view = UILabel()
        
        view.text = "*\(NSLocalizedString("Premium deal are shown twice as high as regular deals.", comment: .init()))"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 17)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var createButton: UIButton = {
        let view = UIButton()
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.backgroundColor = .accentColor
        view.setTitleColor(.white, for: .normal)
        view.setTitle(NSLocalizedString("Post", comment: .init()), for: .normal)
        view.addTarget(self, action: #selector(self.didTapCreateButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tagsTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Tags", comment: .init()) + ":"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tagsPlusButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "plus"), for: .normal)
        } else {
            view.setImage(.init(named: "plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        view.tintColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapTagsPlusButton), for: .touchUpInside)
        view.imageViewSizeToButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = CustomCollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.dataSource = self
        view.delegate = self
        view.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var noTagsLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("No Tags", comment: .init())
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 24)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.isHidden = !self.presenter.deal.photoDatas.isEmpty
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tagsDescriptionLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Tags as well as the title help find your ad. You can add as many tags as you like. To delete a tag, click on it.", comment: .init())
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 17)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.getAllPetTypes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = self.presenter.isCreate
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.firstContentView)
        self.scrollView.addSubview(self.secondContentView)
        self.scrollView.addSubview(self.thirdContentView)
        self.scrollView.addSubview(self.createButton)
        
        self.firstContentView.addSubview(self.photosTitle)
        self.firstContentView.addSubview(self.photosPlusButton)
        self.firstContentView.addSubview(self.photosCollectionView)
        self.firstContentView.addSubview(self.noPhotosLabel)
        
        self.secondContentView.addSubview(self.titleTitleLabel)
        self.secondContentView.addSubview(self.titleTextView)
        self.secondContentView.addSubview(self.descriptionTitleLabel)
        self.secondContentView.addSubview(self.descriptionTextView)
        self.secondContentView.addSubview(self.tagsTitleLabel)
        self.secondContentView.addSubview(self.tagsPlusButton)
        self.secondContentView.addSubview(self.tagsCollectionView)
        self.secondContentView.addSubview(self.noTagsLabel)
        self.secondContentView.addSubview(self.tagsDescriptionLabel)
        self.secondContentView.addSubview(self.modeTitleLabel)
        self.secondContentView.addSubview(self.modeValueLabel)
        self.secondContentView.addSubview(self.petTypeTitleLabel)
        self.secondContentView.addSubview(self.petTypeCollectionView)
        self.secondContentView.addSubview(self.breedTitleLabel)
        self.secondContentView.addSubview(self.breedValueLabel)
        self.secondContentView.addSubview(self.petClassTitleLabel)
        self.secondContentView.addSubview(self.petClassValueLabel)
        self.secondContentView.addSubview(self.sexTitleLabel)
        self.secondContentView.addSubview(self.sexCollectionView)
        self.secondContentView.addSubview(self.locationTitleLabel)
        self.secondContentView.addSubview(self.countryTextField)
        self.secondContentView.addSubview(self.cityTextField)
        self.secondContentView.addSubview(self.colorTitleLabel)
        self.secondContentView.addSubview(self.colorTextField)
        self.secondContentView.addSubview(self.birthDateLabel)
        self.secondContentView.addSubview(self.birthDatePicker)
        self.secondContentView.addSubview(self.priceTitleLabel)
        self.secondContentView.addSubview(self.priceTextField)
        self.secondContentView.addSubview(self.currencyButton)
        
        self.thirdContentView.addSubview(self.premiumDealTitleLabel)
        self.thirdContentView.addSubview(self.premiumDealSwitch)
        self.thirdContentView.addSubview(self.premiumDealDescriptionLabel)
        
        self.scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.firstContentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        self.photosTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        self.photosPlusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.photosTitle.snp.trailing).inset(-15)
            make.centerY.equalTo(self.photosTitle)
            make.width.height.equalTo(25)
        }
        
        self.photosPlusButton.imageView?.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.photosCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.photosTitle.snp.bottom).inset(-10)
            make.height.equalTo(self.photosCollectionViewHeight != .zero ? self.photosCollectionViewHeight : 1)
        }
        
        self.noPhotosLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.photosCollectionView.snp.bottom).inset(-10)
        }
        
        self.secondContentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.firstContentView.snp.bottom).inset(-15)
        }
        
        self.titleTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
        }
        
        self.titleTextView.snp.makeConstraints { make in
            make.top.equalTo(self.titleTitleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.greaterThanOrEqualTo(50)
        }
        
        self.descriptionTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.titleTextView.snp.bottom).inset(-15)
        }
        
        self.descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionTitleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.greaterThanOrEqualTo(50)
        }
        
        self.tagsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.descriptionTextView.snp.bottom).inset(-15)
        }

        self.tagsPlusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.tagsTitleLabel.snp.trailing).inset(-15)
            make.centerY.equalTo(self.tagsTitleLabel)
            make.width.height.equalTo(25)
        }

        self.tagsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.tagsTitleLabel.snp.bottom).inset(-10)
            make.height.greaterThanOrEqualTo(1)
        }
        
        self.noTagsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.tagsCollectionView.snp.bottom).inset(-10)
        }

        self.tagsDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.noTagsLabel.snp.bottom).inset(-10)
        }
        
        self.modeTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.tagsDescriptionLabel.snp.bottom).inset(-15)
        }
        
        self.modeValueLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.modeTitleLabel.snp.bottom).inset(-10)
        }
        
        self.petTypeTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.modeValueLabel.snp.bottom).inset(-15)
        }
        
        self.petTypeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.petTypeTitleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo((self.view.bounds.width - 45) / 2)
        }
        
        self.breedTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.petTypeCollectionView.snp.bottom).inset(-15)
        }
        
        self.breedValueLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.breedTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.petClassTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.breedValueLabel.snp.bottom).inset(-15)
        }
        
        self.petClassValueLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.petClassTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.sexTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.petClassValueLabel.snp.bottom).inset(-15)
        }
        
        self.sexCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.sexTitleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        self.locationTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.sexCollectionView.snp.bottom).inset(-15)
        }
        
        self.countryTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.locationTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.cityTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.countryTextField.snp.bottom).inset(2)
            make.height.equalTo(50)
        }
        
        self.colorTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.cityTextField.snp.bottom).inset(-15)
        }
        
        self.colorTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.colorTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.birthDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalTo(self.secondContentView.snp.centerX)
            make.top.equalTo(self.colorTextField.snp.bottom).inset(-20)
        }
        
        self.birthDatePicker.snp.makeConstraints { make in
            make.top.equalTo(self.birthDateLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        self.priceTitleLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.birthDatePicker.snp.bottom).inset(-15)
        }
        
        self.priceTextField.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.priceTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.currencyButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.priceTextField)
            make.trailing.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(self.priceTextField.snp.trailing)
            make.height.equalTo(50)
            make.width.equalTo(70)
        }
        
        self.thirdContentView.snp.makeConstraints { make in
            make.top.equalTo(self.secondContentView.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.premiumDealTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.trailing.equalTo(self.premiumDealSwitch.snp.leading).inset(-15)
        }
        
        self.premiumDealSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(self.premiumDealTitleLabel)
        }
        
        self.premiumDealDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.premiumDealTitleLabel.snp.bottom).inset(-15)
        }
        
        self.createButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.thirdContentView.snp.bottom).inset(-15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
//    MARK: Actions
    @objc private func didTapCreateButton() {
        guard !self.presenter.deal.photoDatas.isEmpty else {
            self.presentAlert(title: "No Photos", message: "Add at least one photo.")
            
            return
        }
        
        guard !self.presenter.deal.title.isEmpty else {
            self.presentAlert(title: "Title field is empty", message: "Fill it")
            
            return
        }
        
        guard self.presenter.deal.petTypeID != nil else {
            self.presentAlert(title: "Not Selected Pet Type", message: "Select pet type")
            
            return
        }
        
        guard self.presenter.deal.petBreedID != nil else {
            self.presentAlert(title: "Not Selected Pet Breed", message: "Select pet breed")
            
            return
        }
        
        guard self.presenter.deal.petClass != nil else {
            self.presentAlert(title: "Not Selected Pet Class", message: "Select pet class")
            
            return
        }
        
        guard self.presenter.deal.isMale != nil else {
            self.presentAlert(title: "Not Selected Pet Sex", message: "Select pet sex")
            
            return
        }
        
        guard self.presenter.deal.color != nil else {
            self.presentAlert(title: "Color field is empty", message: "Fill it")
            
            return
        }
        
        guard self.presenter.deal.price != nil else {
            self.presentAlert(title: "Price field is empty", message: "Fill it")
            
            return
        }
        
        guard self.presenter.deal.price != .zero else {
            self.presentAlert(title: "Error", message: "Price is equal to 0")
            
            return
        }
        
        if self.presenter.isCreate {
            self.presenter.createDeal { [ weak self ] error in
                self?.error(error) {
                    self?.presenter.notificationCenterManagerPostUpdateProfileScreen()
                    self?.presenter.notificationCenterManagerPostUpdateFeedScreen()
                    
                    if self?.presenter.getNextDealIsPremium() ?? false && self?.presenter.deal.isPremiumDeal ?? false {
                        self?.presenter.setNextDealIsPremium(false)
                    }
                    
                    guard let self = self else {
                        return
                    }
                    
                    self.titleTextView.text = nil
                    self.descriptionTextView.text = nil
                    self.modeValueLabel.text = DealMode.everywhere.rawValue
                    self.breedValueLabel.text = "–"
                    self.petClassValueLabel.text = PetClass.allClass.rawValue
                    self.countryTextField.text = nil
                    self.cityTextField.text = nil
                    self.colorTextField.text = nil
                    self.selectedIsMale = nil
                    self.selectedPetType = nil
                    self.presenter.deal = .init(
                        title: .init(),
                        photoDatas: .init(),
                        isPremiumDeal: self.presenter.getNextDealIsPremium() ?? false,
                        mode: .everywhere,
                        petClass: .allClass,
                        birthDate: .init(),
                        currencyName: .getCurrency(wtih: self.presenter.getUserCurrency() ?? .init()) ?? .USD,
                        catteryID: self.presenter.getUserID() ?? .init()
                    )
                    self.priceTextField.text = "0"
                    self.presentAlert(title: NSLocalizedString("You successfully posted a deal!", comment: .init()))
                    
                    for i in .zero ..< self.petTypeCollectionView.visibleCells.count {
                        self.petTypeCollectionView.deselectItem(at: .init(item: i, section: .zero), animated: true)
                    }
                    
                    for i in .zero ..< self.sexCollectionView.visibleCells.count {
                        self.sexCollectionView.deselectItem(at: .init(item: i, section: .zero), animated: true)
                    }
                }
            }
        } else {
            self.presenter.changeDeal { [ weak self ] error in
                self?.error(error) {
                    self?.presenter.notificationCenterManagerPostUpdateProfileScreen()
                    self?.presenter.notificationCenterManagerPostUpdateFeedScreen()
                    
                    if self?.presenter.getNextDealIsPremium() ?? false && self?.presenter.deal.isPremiumDeal ?? false {
                        self?.presenter.setNextDealIsPremium(false)
                    }
                    
                    self?.presenter.notificationCenterManagerPostUpdateDealScreen()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc private func setBirthDate(_ sender: UIDatePicker) {
        self.presenter.deal.birthDate = ISO8601DateFormatter().string(from: sender.date)
    }
    
    @objc private func didTapModeValueLabel() {
        self.presentActionsSheet(
            title: NSLocalizedString("Mode", comment: .init()),
            contents: DealMode.allCases.map { $0.rawValue }) { [ weak self ] alertAction in
                self?.modeValueLabel.text = alertAction.title
            }
        
        self.presenter.deal.mode = .getDealMode(self.modeValueLabel.text ?? .init())
    }
    
    @objc private func didTapBreedValueLabel() {
        var breedList = [String]()
                
        for petBreed in self.selectedPetType?.petBreeds ?? self.presenter.allBreeds.map({
            var petBreed = $0
            
            if petBreed.name == "Other", let name = petBreed.petType?.name {
                petBreed.name += "(\(name))"
            }
            
            return petBreed
        }) {
            breedList.append(petBreed.name)
        }
        
        self.presentActionsSheet(
            title: NSLocalizedString("Breed", comment: .init()),
            contents: breedList
        ) { [ weak self ] alertAction in
            guard var title = alertAction.title else {
                return
            }
            
            self?.breedValueLabel.text = alertAction.title
            
            if title.contains("Other") {
                for name in self?.presenter.petTypes.map({ $0.name }) ?? .init() {
                    if title.contains(name) {
                        title = title.replacingOccurrences(of: "(\(name))", with: String())
                        
                        break
                    }
                }
            }
            
            if let petBreed = self?.presenter.allBreeds.filter({ $0.name == title }).first {
                self?.presenter.deal.petBreedID = petBreed.id
                self?.presenter.deal.petTypeID = petBreed.petType?.id
                self?.selectedPetType = self?.presenter.petTypes.first { $0.id == petBreed.petType?.id }
                
                guard let index = self?.presenter.petTypes.firstIndex(where: { $0.id == petBreed.petType?.id }) else {
                    return
                }
                
                self?.petTypeCollectionView.selectItem(
                    at: .init(item: index, section: .zero),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
            }
        }
    }
    
    @objc private func didTapPetClassValueLabel() {
        self.presentActionsSheet(
            title: NSLocalizedString("Pet Class", comment: .init()),
            contents: (self.presenter.getPetClasses() ?? PetClass.allCases.map { $0.rawValue }).sorted(by: <)
        ) { [ weak self ] alertAction in            
            self?.petClassValueLabel.text = alertAction.title
            self?.presenter.deal.petClass = .getPetClass(alertAction.title ?? .init()) ?? .allClass
        }
    }
    
    @objc private func didTapTagsPlusButton() {
        self.presentAlertWithTextField(
            title: NSLocalizedString("Add Tag", comment: .init()),
            message: NSLocalizedString("Enter text", comment: .init()),
            buttonTitle: NSLocalizedString("Add", comment: .init())) { [ weak self ] text in
                self?.presenter.deal.tags.append(text.replacingOccurrences(of: " ", with: "").lowercased())
            }
    }
    
    @objc private func editingCountryTextField(_ sender: UITextField) {
        self.presenter.deal.country = sender.text
    }
    
    @objc private func editingCityTextField(_ sender: UITextField) {
        self.presenter.deal.city = sender.text
    }
    
    @objc private func editingColorTextField(_ sender: UITextField) {
        self.presenter.deal.color = sender.text
    }
    
    @objc private func editingPriceTextField(_ sender: UITextField) {
        self.presenter.deal.price = .init(sender.text ?? .init())
    }
    
    @objc private func premiumDealSwitchValueChanged(_ sender: UISwitch) {
        guard !self.presenter.deal.isPremiumDeal, sender.isOn else {
            return
        }
        
        self.presenter.getProducts { [ weak self ] products in
            guard let product = products.first else {
                sender.setOn(false, animated: true)
                
                return
            }
            
            self?.presenter.makePayment(product) { error in
                guard error == nil else {
                    sender.setOn(false, animated: true)
                    
                    self?.error(error)
                    
                    return
                }
                
                self?.presenter.deal.isPremiumDeal = true
                self?.premiumDealSwitch.isEnabled = false
                self?.presenter.setNextDealIsPremium(true)
            }
        }
    }
    
    @objc private func didTapCurrencyButton() {
        self.presentActionsSheet(
            title: NSLocalizedString("Currency", comment: .init()),
            contents: self.presenter.getAllCurrencies() ?? Currency.allCases.map { $0.rawValue }
        ) { [ weak self ] alertAction in
            self?.presenter.deal.currencyName = .getCurrency(wtih: alertAction.title ?? .init()) ?? .USD
            self?.currencyButton.setTitle(alertAction.title, for: .normal)
        }
    }
    
    @objc private func didTapPhotosPlusButton() {
        self.present(self.imagePickerController, animated: true)
    }
    
}

//MARK: Extensions
extension EditDealViewController: UINavigationControllerDelegate { }

extension EditDealViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let data = (info[.editedImage] as? UIImage)?.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        self.presenter.deal.photoDatas.append(data)
        self.photosCollectionView.reloadData()
    }
    
}

extension EditDealViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {        
        if collectionView == self.photosCollectionView {
            return self.presenter.deal.photoDatas.count
        } else if collectionView == self.tagsCollectionView {
            return self.presenter.deal.tags.count
        } else if collectionView == self.petTypeCollectionView {
            return self.presenter.petTypes.count
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.photosCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageWithXmarkCollectionViewCell.id,
                for: indexPath
            ) as? ImageWithXmarkCollectionViewCell else {
                return .init()
            }
            
            cell.photoImageView.clipsToBounds = true
            cell.photoImageView.layer.masksToBounds = true
            cell.photoImageView.layer.cornerRadius = 25
            cell.imageData = self.presenter.deal.photoDatas[indexPath.item]
            cell.delegate = self
            
            return cell
        } else if collectionView == self.petTypeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetTypeCollectionViewCell.id,
                for: indexPath
            ) as? PetTypeCollectionViewCell else {
                return .init()
            }
                    
            cell.petType = self.presenter.petTypes[indexPath.item]
            cell.backgroundColor = .backgroundColor
            
            if self.presenter.deal.petTypeID == cell.petType?.id {
                cell.isSelected = true
            }
            
            return cell
        } else if collectionView == self.tagsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TagCollectionViewCell.id,
                for: indexPath
            ) as? TagCollectionViewCell else {
                return .init()
            }
            
            cell.value = self.presenter.deal.tags[indexPath.item]
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SexCollectionViewCell.id,
            for: indexPath
        ) as? SexCollectionViewCell else {
            return .init()
        }
        
        cell.backgroundColor = .backgroundColor
        cell.isMale = indexPath.row == 0
        
        if self.presenter.deal.isMale == cell.isMale {
            cell.isSelected = true
        }
        
        return cell
    }
    
}

extension EditDealViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.photosCollectionView || collectionView == self.tagsCollectionView {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            if collectionView == self.tagsCollectionView {
                self.presentAlert(
                    title: NSLocalizedString("Do you want delete this tag?",comment: .init()),
                    actions: (
                        title: NSLocalizedString("Delete", comment: .init()),
                        style: UIAlertAction.Style.destructive,
                        action: { [ weak self ] in
                            self?.presenter.deal.tags.remove(at: indexPath.item)
                        }
                    ),
                    (
                        title: NSLocalizedString("No", comment: .init()),
                        style: UIAlertAction.Style.default,
                        action: { }
                    )
                )
            }
        } else {
            for i in 0 ..< collectionView.visibleCells.count {
                if collectionView.cellForItem(at: indexPath) == collectionView.visibleCells[i] {
                    collectionView.deselectItem(at: IndexPath(item: i, section: indexPath.section), animated: true)
                }
            }
            
            if collectionView == self.petTypeCollectionView {
                guard let cell = collectionView.cellForItem(at: indexPath) as? PetTypeCollectionViewCell else {
                    return
                }
                
                if self.selectedPetType == cell.petType {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    
                    self.presenter.deal.petTypeID = nil
                    self.selectedPetType = nil
                } else {
                    self.presenter.deal.petTypeID = cell.petType?.id
                    self.selectedPetType = cell.petType
                }
            } else {
                guard let cell = collectionView.cellForItem(at: indexPath) as? SexCollectionViewCell else {
                    return
                }
                
                if self.selectedIsMale == cell.isMale {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    
                    self.presenter.deal.isMale = nil
                    self.selectedIsMale = nil
                } else {
                    self.presenter.deal.isMale = cell.isMale
                    self.selectedIsMale = cell.isMale
                }
            }
        }
    }
    
}

extension EditDealViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.photosCollectionView {
            return .init(
                width: (collectionView.bounds.width - 15) / 2,
                height: (collectionView.bounds.width - 15) / 2
            )
        } else if collectionView == self.tagsCollectionView {
            return .init(width: 1, height: 1)
        }
        
        return .init(
            width: (collectionView.bounds.width - 15) / 2,
            height: collectionView == self.petTypeCollectionView ? (collectionView.bounds.width - 15) / 2 : 50
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
}

extension EditDealViewController: ImageWithXmarkCollectionViewCellDelegate {
    
    func imageWithXmarkCollectionViewCell(_ cell: ImageWithXmarkCollectionViewCell, didTapXmarkButton xmarkButton: UIButton) {
        for i in .zero ..< self.presenter.deal.photoDatas.count {
            if cell.imageData == self.presenter.deal.photoDatas[i] {
                self.presenter.deal.photoDatas.remove(at: i)
                
                break
            }
        }
    }
    
    func imageWithXmarkCollectionViewCell(_ cell: ImageWithXmarkCollectionViewCell, imageViewSize imageView: UIImageView) -> CGSize {
        .init(
            width: ((self.photosCollectionView.bounds.width - 15) / 2) - 15,
            height: ((self.photosCollectionView.bounds.width - 15) / 2) - 15
        )
    }
    
}

extension EditDealViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if self.titleTextView == textView {
            self.presenter.deal.title = textView.text
        } else {
            self.presenter.deal.description = textView.text
        }
    }
    
}
