//
//  CustomTitleBar.swift
//  Zstore
//
//  Created by Hari Prakash on 24/05/24.
//


import UIKit


class TitleBarView: UIView {
    
    // MARK: Create the UI components
    lazy var titleLabel = AppUIComponents.createLabel(text: "",textColor: .black_colour,font:  UIFont.systemFont(ofSize: 30, weight: .bold))

    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search_icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var customSearchView: CustomSearchView = {
        let searchView = CustomSearchView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.isHidden = true
        return searchView
    }()
    
    // MARK: delegate
    weak var delegate: TitleBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    //MARK: Setup the constraint
    private func setupView() {
        addSubview(titleLabel)
        addSubview(leftButton)
        addSubview(customSearchView)
        
        customSearchView.delegate = self
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -52),
            leftButton.widthAnchor.constraint(equalToConstant: 44),
            leftButton.heightAnchor.constraint(equalToConstant: 44),
            leftButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            customSearchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            customSearchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            customSearchView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            customSearchView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Button Actions
    @objc private func leftButtonTapped() {
        toggleSearchBar()
    }
    
    
    //MARK: Other Function
    func toggleSearchBar() {
        titleLabel.isHidden = !titleLabel.isHidden
        leftButton.isHidden = !leftButton.isHidden
        customSearchView.isHidden = !customSearchView.isHidden
        if !customSearchView.isHidden {
            customSearchView.textField.becomeFirstResponder()
        } else {
            customSearchView.textField.resignFirstResponder()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }

}

//MARK: - UISearchBarDelegate, CustomSearchViewDelegate
extension TitleBarView: UISearchBarDelegate, CustomSearchViewDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didUpdateSearchResults(searchText)
    }
    
    func didUpdateSearchText(_ searchText: String) {
        delegate?.didUpdateSearchResults(searchText)
    }
    
    func didCancelSearch() {
        toggleSearchBar()
        delegate?.didCancelSearch()
    }
}
