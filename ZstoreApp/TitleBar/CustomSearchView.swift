//
//  CustomSearchView.swift
//  Zstore
//
//  Created by Hari Prakash on 24/05/24.
//

import UIKit



class CustomSearchView: UIView {
    
    
    
    // MARK: Create the UI components
 
    private let iconImageView = AppUIComponents.createImageView(image: UIImage(named: "search_icon"),contentMode: .scaleAspectFit)
    private let searchContainerView = AppUIComponents.createView()
    lazy var textField = AppUIComponents.createTextField(placeholder: "Search")
    lazy var cancelImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray_color
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.orange_colour, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Delegate
    weak var delegate: CustomSearchViewDelegate?

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
        backgroundColor = .clear
        
        searchContainerView.addSubview(iconImageView)
        searchContainerView.addSubview(textField)
        searchContainerView.addSubview(cancelImageButton)
        addSubview(searchContainerView)
        addSubview(cancelButton)
        
        searchContainerView.setCornerRadius(radius: 18)
        searchContainerView.setBorder(borderWidth: 1, color: .gray_color)
        
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            
            searchContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            searchContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            searchContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            searchContainerView.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -12),
            
            iconImageView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 0),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 0),
            iconImageView.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 0),
            
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 6),
            textField.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: cancelImageButton.leadingAnchor, constant: -8),
            
            cancelImageButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: 0),
            cancelImageButton.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 0),
            cancelImageButton.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 0),
            cancelImageButton.widthAnchor.constraint(equalToConstant: 36),
            
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelImageButton.addTarget(self, action: #selector(cancelImageButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Button Actions
    @objc private func cancelButtonTapped() {
        textField.text = ""
        textField.resignFirstResponder()
        delegate?.didCancelSearch()
    }
    
    @objc private func cancelImageButtonTapped() {
        textField.text = ""
        delegate?.didUpdateSearchText("")
    }
    

}

//MARK: Protocol Delegate
extension CustomSearchView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        delegate?.didUpdateSearchText(updatedText)
        return true
    }
}
