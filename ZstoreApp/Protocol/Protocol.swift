//
//  Protocol.swift
//  Zstore
//
//  Created by Hari Prakash on 28/05/24.
//

import Foundation

import UIKit

//protocol OfferListViewDelegate: AnyObject {
//    func removeSelectedOffer()
//}

protocol FontFamily {
    var value: String { get }
}

/// A protocol that defines methods for calculating item and header heights in a waterfall layout for a UICollectionView.
protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForHeaderInSection section: Int, with width: CGFloat) -> CGFloat
}

//protocol ProductCollectionViewCellDelegate: AnyObject {
//    func addOrRemoveFromFavList<T: UICollectionViewCell>(isAdd: Bool,_ cell: T)
//}

/// Protocol to handle updates and cancellations of search results in the TitleBarView.
protocol TitleBarViewDelegate: AnyObject {
    /// Called when the search results are updated.
    /// - Parameter searchText: The updated search text.
    func didUpdateSearchResults(_ searchText: String)
    
    /// Called when the search is cancelled.
    func didCancelSearch()
}

/// Protocol to handle updates and cancellations of the search text in the CustomSearchTestfieldView.
protocol CustomSearchViewDelegate: AnyObject {
    /// Called when the search text is updated.
    /// - Parameter searchText: The updated search text.
    func didUpdateSearchText(_ searchText: String)
    
    /// Called when the search is cancelled.
    func didCancelSearch()
}

/// Protocol to handle updates of card offers in the HomeVC.
protocol HomeVCDelegate {
    /// Called to update the selected card offer.
    /// - Parameter selectedOffer: The selected card offer, or nil if none is selected.
    func updateCardOffer(selectedOffer: CardOffer?)
}
