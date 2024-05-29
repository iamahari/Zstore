//
//  AppUiComponents.swift
//  Zstore
//
//  Created by Hari Prakash on 25/05/24.
//

import Foundation


import UIKit

class AppUIComponents {
        
    static func createLabel(text: String, textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, fontName: String? = FontType.semibold.value, fontSize: CGFloat = 12, isBold: Bool = false, numberOfLines: Int = 0) -> UILabel {
            
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        
        if let fontName = fontName, let customFont = UIFont(name: fontName, size: fontSize) {
            if isBold {
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
            } else {
                label.font = customFont
            }
        } else {
            if isBold {
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
            } else {
                label.font = UIFont.systemFont(ofSize: fontSize)
            }
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }


    
    static func createLabel(text: String, textColor: UIColor = .black, textAlignment: NSTextAlignment = .center, font: UIFont = UIFont.systemFont(ofSize: 17)) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
//        label.numberOfLines = numberOfLine
        label.textAlignment = textAlignment
        label.font = font
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createButton(title: String, target: Any?, action: Selector, backgroundColor: UIColor = .systemBlue, titleColor: UIColor = .white) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.addTarget(target, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    static func createTextField(placeholder: String, borderColor: UIColor = .gray) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.textColor = .black_colour
        textField.layer.borderColor = borderColor.cgColor

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func createView(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 0.0, clipsToBounds: Bool = true, borderWidth: CGFloat = 0.0, borderColor: CGColor = UIColor.clear.cgColor ) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.clipsToBounds = clipsToBounds
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func createImageView(image: UIImage? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, clipsToBounds: Bool = true, tintColor: UIColor? = .orangeColour) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        imageView.clipsToBounds = clipsToBounds
        imageView.tintColor = tintColor
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    static func createTextView(text: String = "", clipsToBounds: Bool = true, tintColor: UIColor? = .orangeColour,isEditable: Bool = false,isScrollEnabled: Bool = false) -> UITextView {
        let label = UITextView()
        label.textAlignment = .left
        label.font = UIFont.font(with: 13, family: FontType.regular)
        label.textColor = .description_colour
        label.isEditable = false
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat)-> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
   
    
    static func createCollectionViewFlowLayout(scrollDiraction: UICollectionView.ScrollDirection = .vertical  ,itemSize: CGSize = CGSize(width: 10, height: 10), sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0,estimationSize: CGSize = CGSize(width: 0,height: 0)) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection =  scrollDiraction
        layout.estimatedItemSize = estimationSize
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.itemSize = itemSize
        layout.sectionInset = sectionInset
        return layout
    }
    
    static func createCollectionView(frame: CGRect = .zero,
                                     layout: UICollectionViewLayout,
                                     backgroundColor: UIColor = .white,
                                     dataSource: UICollectionViewDataSource,
                                     delegate: UICollectionViewDelegate,
                                     cellClass: AnyClass,
                                     reuseIdentifier: String) -> UICollectionView {
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    }

    
    static func getFilterOptionView(leftImage: UIImage, title: String, rightImage: UIImage, tag: Int) -> UIView {
        let containerView = createView()
        
        
        let leftImageView = createImageView(image: leftImage, contentMode: .scaleAspectFit)
        
        let rightImageView = createImageView(image: rightImage, contentMode: .scaleAspectFit)
        
        let optionTitleLabel = createLabel(text: title, font: AppFont.font(with: 18, family: FontType.semibold))
        optionTitleLabel.textAlignment = .left
        
        let lineLabel = AppUIComponents.createLabel(text: "", font: AppFont.font(with: 13, family: FontType.medium))
        
        containerView.addSubview(lineLabel)
        containerView.addSubview(leftImageView)
        containerView.addSubview(rightImageView)
        containerView.addSubview(optionTitleLabel)
        lineLabel.backgroundColor = .black_colour
        
        rightImageView.tag = tag
        
        
        NSLayoutConstraint.activate([
            lineLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lineLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lineLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            lineLabel.heightAnchor.constraint(equalToConstant: 1),
            
            leftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            leftImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9),
            leftImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -9),
            leftImageView.heightAnchor.constraint(equalToConstant: 36),
            leftImageView.widthAnchor.constraint(equalToConstant: 36),
            
            optionTitleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 12),
            optionTitleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            rightImageView.leadingAnchor.constraint(equalTo: optionTitleLabel.trailingAnchor, constant: 12),
            rightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            rightImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rightImageView.heightAnchor.constraint(equalToConstant: 44),
            rightImageView.widthAnchor.constraint(equalToConstant: 44),
        ])
        
        return containerView
        
    }

}

