//
//  FilterViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.11.2022.
//

import UIKit
import SnapKit

final class FilterViewController: UIViewController {
    
    private let presenter: FilterPresenter
    
    init(presenter: FilterPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    private var selectedIsMale: Bool?
    private var selectedPetType: PetType? {
        didSet {
            self.breedValueLabel.text = PetBreed.other.rawValue
        }
    }
    
//    MARK: UI Properties
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Filter", comment: .init())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 34, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var resetButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Reset", comment: .init()), for: .normal)
        view.setTitleColor(.accentColor, for: .normal)
        view.titleLabel?.textAlignment = .right
        view.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addTarget(self, action: #selector(self.didTapResetButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
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
        
        view.text = self.presenter.filter.petBreed?.rawValue ?? "–"
        view.textColor = .accentColor
        view.backgroundColor = .textFieldColor
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 2
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
        
        view.text = self.presenter.filter.petClass?.rawValue ?? PetClass.allClass.rawValue
        view.textColor = .accentColor
        view.backgroundColor = .textFieldColor
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 2
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
        
        view.text = "\(NSLocalizedString("Location", comment: .init())):"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var countryTextField: UITextField = {
        let view = UITextField()
         
        view.textColor = .textColor
        view.backgroundColor = .textFieldColor
        view.placeholder = NSLocalizedString("Country", comment: "")
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.addTarget(self, action: #selector(self.editingCountryTextField(_:)), for: .allEditingEvents)
        view.rightViewMode = .always
         
        return view
    }()
    
    private lazy var cityTextField: UITextField = {
        let view = UITextField()
         
        view.textColor = .textColor
        view.backgroundColor = .textFieldColor
        view.placeholder = NSLocalizedString("City", comment: "")
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.addTarget(self, action: #selector(self.editingCityTextField(_:)), for: .allEditingEvents)
        view.rightViewMode = .always
         
        return view
    }()
        
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .accentColor
        view.setTitle(NSLocalizedString("Save", comment: .init()), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.didTapSaveButton), for: .touchUpInside)
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
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.resetButton)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.saveButton)
        
        self.scrollView.addSubview(self.petTypeCollectionView)
        self.scrollView.addSubview(self.breedTitleLabel)
        self.scrollView.addSubview(self.breedValueLabel)
        self.scrollView.addSubview(self.petClassTitleLabel)
        self.scrollView.addSubview(self.petClassValueLabel)
        self.scrollView.addSubview(self.sexTitleLabel)
        self.scrollView.addSubview(self.sexCollectionView)
        self.scrollView.addSubview(self.locationTitleLabel)
        self.scrollView.addSubview(self.countryTextField)
        self.scrollView.addSubview(self.cityTextField)
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.resetButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(self.titleLabel.snp.trailing).inset(-15)
            make.centerY.equalTo(self.titleLabel)
        }
        
        self.resetButton.titleLabel?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
            make.leading.trailing.width.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.saveButton.snp.top).inset(-15)
        }
        
        self.petTypeCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo((self.view.bounds.width - 45) / 2)
        }
        
        self.breedTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.petTypeCollectionView.snp.bottom).inset(-15)
        }
        
        self.breedValueLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.breedTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.petClassTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.breedValueLabel.snp.bottom).inset(-15)
        }
        
        self.petClassValueLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.petClassTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.sexTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.petClassValueLabel.snp.bottom).inset(-15)
        }
        
        self.sexCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.sexTitleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        self.locationTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.sexCollectionView.snp.bottom).inset(-15)
        }
        
        self.countryTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.locationTitleLabel.snp.bottom).inset(-10)
            make.height.equalTo(50)
        }
        
        self.cityTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.countryTextField.snp.bottom).inset(2)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(15)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
    }
    
//    MARK: Setup Values
    private func setupValues() {
        self.breedValueLabel.text = "–"
        self.petClassValueLabel.text = PetClass.allClass.rawValue
        self.countryTextField.text = .init()
        self.cityTextField.text = .init()
        self.selectedIsMale = nil
        self.selectedPetType = nil
        
        for index in 0 ..< self.petTypeCollectionView.visibleCells.count {
            self.petTypeCollectionView.deselectItem(at: IndexPath(item: index, section: .zero), animated: true)
        }
        
        for index in 0 ..< self.sexCollectionView.visibleCells.count {
            self.sexCollectionView.deselectItem(at: IndexPath(item: index, section: .zero), animated: true)
        }
    }
    
//    MARK: Actions
    @objc private func didTapSaveButton() {
        self.presenter.saveFilter()
        self.dismiss(animated: true)
    }
    
    @objc private func didTapBreedValueLabel() {
        var breedList = [String]()
        
        switch self.selectedPetType {
        case .cat:
            breedList = PetBreed.allCatBreeds.map { $0.rawValue }.sorted(by: <)
        case .dog:
            breedList = PetBreed.allDogBreeds.map { $0.rawValue }.sorted(by: <)
        default:
            breedList = PetBreed.allCases.map { $0.rawValue }.sorted(by: <)
        }
        
        self.presentActionsSheet(
            title: NSLocalizedString("Breed", comment: .init()),
            contents: breedList
        ) { [ weak self ] alertAction in
            self?.breedValueLabel.text = alertAction.title
            self?.presenter.setPetBreed(alertAction.title)
        }
    }
    
    @objc private func didTapPetClassValueLabel() {
        self.presentActionsSheet(
            title: NSLocalizedString("Pet Class", comment: .init()),
            contents: PetClass.allCases.map { $0.rawValue }.sorted(by: <)
        ) { [ weak self ] alertAction in
            self?.petClassValueLabel.text = alertAction.title
            self?.presenter.setPetClass(alertAction.title)
        }
    }
    
    @objc private func editingCountryTextField(_ sender: UITextField) {
        self.presenter.setCountry(sender.text)
    }
    
    @objc private func editingCityTextField(_ sender: UITextField) {
        self.presenter.setCountry(sender.text)
    }
    
    @objc private func didTapResetButton() {
        self.setupValues()
        self.presenter.resetFilter()
    }
        
}

//MARK: Extensions
extension FilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == self.petTypeCollectionView ? PetType.allCases.count : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.petTypeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetTypeCollectionViewCell.id,
                for: indexPath
            ) as? PetTypeCollectionViewCell else {
                return .init()
            }
                    
            cell.petType = PetType.allCases[indexPath.row]
            
            if self.presenter.filter.petType == cell.petType {
                cell.isSelected = true
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SexCollectionViewCell.id,
            for: indexPath
        ) as? SexCollectionViewCell else {
            return .init()
        }
                
        cell.isMale = indexPath.row == 0
        
        if self.presenter.filter.isMale == cell.isMale {
            cell.isSelected = true
        }
        
        return cell
    }
    
}

extension FilterViewController: UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
                
                self.presenter.setPetType()
                self.selectedPetType = nil
            } else {
                self.presenter.setPetType(cell.petType?.rawValue)
                self.selectedPetType = cell.petType
            }
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? SexCollectionViewCell else {
                return
            }
            
            if self.selectedIsMale == cell.isMale {
                collectionView.deselectItem(at: indexPath, animated: true)
                
                self.presenter.setIsMale()
                self.selectedIsMale = nil
            } else {
                self.presenter.setIsMale(cell.isMale)
                self.selectedIsMale = cell.isMale
            }
        }
    }
    
}

extension FilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(
            width: (self.view.bounds.width - 45) / 2,
            height: collectionView == self.petTypeCollectionView ? (self.view.bounds.width - 45) / 2 : 50
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
}
