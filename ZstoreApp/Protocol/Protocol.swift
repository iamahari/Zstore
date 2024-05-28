//
//  Protocol.swift
//  Zstore
//
//  Created by Hari Prakash on 28/05/24.
//

import Foundation

import UIKit

protocol OfferListViewDelegate: AnyObject {
    func removeSelectedOffer()
}

protocol FontFamily {
    var value: String { get }
}

protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int, with width: CGFloat) -> CGFloat
}

protocol ProductCollectionViewCellDelegate: AnyObject {
    func addOrRemoveFromFavList<T: UICollectionViewCell>(isAdd: Bool,_ cell: T)
}

protocol TitleBarViewDelegate: AnyObject {
    func didUpdateSearchResults(_ searchText: String)
    func didCancelSearch()
}


protocol CustomSearchViewDelegate: AnyObject {
    func didUpdateSearchText(_ searchText: String)
    func didCancelSearch()
}


protocol HomeVCDelegate {
    func updateCardOffer(selectedOffer: CardOffer?)
}
