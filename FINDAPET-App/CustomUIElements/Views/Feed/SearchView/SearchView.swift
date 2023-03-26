//
//  SearchView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.11.2022.
//

import UIKit
import SnapKit

//MARK: Search View Delegate
@objc protocol SearchViewDelegate: NSObjectProtocol {
    
    func searchView(_ searchView: SearchView, didTapSearchButton button: UIButton)
    @objc optional func searchView(_ searchView: SearchView, editingSearchTextField textField: UITextField)
    @objc optional func searchView(_ searchView: SearchView, didTapSearchTextField textField: UITextField)
    @objc optional func searchView(_ searchView: SearchView, didTapFilterButton button: UIButton)
    @objc optional func searchView(_ searchView: SearchView, didTapBackButton button: UIButton)
    @objc optional func searchView(_ searchView: SearchView, heightForSearchTextField textField: UITextField) -> CGFloat
}

//MARK: Search View
class SearchView: UIView {
    
//    MARK: Init
    init(mode: SearchViewMode) {
        self.mode = mode
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    var delegate: SearchViewDelegate?
    var mode: SearchViewMode {
        didSet {
            switch self.mode {
            case .withFilter:
                self.filterButton.isHidden = false
                self.backButton.isHidden = true
            case .withBack:
                self.filterButton.isHidden = true
                self.backButton.isHidden = false
            }
        }
    }
    
//    MARK: UI Properties
    lazy var filterButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "slider.horizontal.3"), for: .normal)
        } else {
            view.setImage(.init(named: "slider.horizontal.3")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        view.tintColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapFilterButton), for: .touchUpInside)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.isHidden = self.mode == .withFilter ? false : true
        view.imageViewSizeToButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var backButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "arrow.left"), for: .normal)
        } else {
            view.setImage(.init(named: "arrow.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        view.tintColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.isHidden = self.mode == .withBack ? false : true
        view.imageViewSizeToButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "magnifyingglass"), for: .normal)
        } else {
            view.setImage(.init(named: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        view.tintColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapSearchButton), for: .touchUpInside)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.imageViewSizeToButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let view = UITextField()
        
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.placeholder = NSLocalizedString("Search", comment: .init())
        view.leftView = .init(frame: .init(
            x: 0,
            y: 0,
            width: self.delegate?.searchView?(self, heightForSearchTextField: view) ?? 50,
            height: 0
        ))
        view.leftViewMode = .always
        view.rightView = .init(frame: .init(
            x: 0,
            y: 0,
            width: self.delegate?.searchView?(self, heightForSearchTextField: view) ?? 50,
            height: 0
        ))
        view.rightViewMode = .always
        view.backgroundColor = .backgroundColor
        view.textColor = .textColor
        view.tintColor = self.mode == .withBack ? .accentColor : .clear
        view.addTarget(self, action: #selector(self.editingSearchTextField), for: .allEditingEvents)
        view.addTarget(self, action: #selector(self.didTapSearchTextField), for: .touchDown)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .textFieldColor
        self.layer.cornerRadius = 25
        
        self.addSubview(self.searchTextField)
        
        self.searchTextField.addSubview(self.filterButton)
        self.searchTextField.addSubview(self.searchButton)
        self.searchTextField.addSubview(self.backButton)
        
        self.filterButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(self.searchButton.snp.height)
        }
        
        self.backButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(self.searchButton.snp.height)
        }
        
        self.searchTextField.snp.makeConstraints { make in
            make.bottom.trailing.leading.top.equalToSuperview().inset(15)
            make.height.equalTo(self.delegate?.searchView?(self, heightForSearchTextField: self.searchTextField) ?? 50)
        }
        
        self.searchButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(self.searchButton.snp.height)
        }
    }
    
//    MARK: Actions
    @objc private func editingSearchTextField() {
        self.delegate?.searchView?(self, editingSearchTextField: self.searchTextField)
    }
    
    @objc private func didTapSearchTextField() {
        self.delegate?.searchView?(self, didTapSearchTextField: self.searchTextField)
    }
    
    @objc private func didTapSearchButton() {
        self.delegate?.searchView(self, didTapSearchButton: self.searchButton)
    }
    
    @objc private func didTapFilterButton() {
        guard self.mode == .withFilter else {
            return
        }
        
        self.delegate?.searchView?(self, didTapFilterButton: self.filterButton)
    }
    
    @objc private func didTapBackButton() {
        guard self.mode == .withBack else {
            return
        }
        
        self.delegate?.searchView?(self, didTapBackButton: self.backButton)
    }
    
}
