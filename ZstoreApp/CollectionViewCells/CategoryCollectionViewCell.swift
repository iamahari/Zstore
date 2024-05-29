//
//  CategoryCollectionViewCell.swift
//  Zstore
//
//  Created by Hari Prakash on 24/05/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    // MARK: Create the UI components
    var label = AppUIComponents.createLabel(text: "",textColor: .fav_button_text_color,font:  UIFont.systemFont(ofSize: 15, weight: .medium))
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        contentView.setCornerRadius(radius: 16)
        contentView.setBorder(borderWidth: 1, color: .fav_button_text_color)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Update Cell
    func configure(with category: CategoryList,with isSearch: Bool,count productCount: Int,with isSelecedProduct: Bool) {
        if isSearch && isSelecedProduct {
            label.text = "\(category.name ?? "") (\(productCount))"
        }else{
            label.text = category.name ?? ""
        }
        label.textColor = (isSelecedProduct) ? .orangeColour : .fav_button_text_color
        contentView.backgroundColor = (isSelecedProduct) ? .orangeColour.withAlphaComponent(0.1) : .white
        contentView.setBorder(borderWidth: 1, color: (isSelecedProduct) ? .orangeColour : .fav_button_text_color)
    }
}
