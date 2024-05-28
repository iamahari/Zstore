//
//  CustomFont.swift
//  Zstore
//
//  Created by Hari Prakash on 26/05/24.
//

import UIKit


/// Create the custom UICollectionViewFlowLayout to achive the waterfall Layout
class WaterfallLayout: UICollectionViewFlowLayout {
    weak var delegate: WaterfallLayoutDelegate?

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var headerCache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    var numberOfColumns = 2

    override func prepare() {
        print("prepare >>>>>>>>>>>>")
        guard let collectionView = collectionView else { return }
        cache.removeAll()
        headerCache.removeAll()

        let cellPadding: CGFloat = 6
        let columnWidth = collectionView.bounds.width / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = Array(repeating: 0, count: numberOfColumns)

        // Add header attributes
        if let headerHeight = delegate?.collectionView(collectionView, heightForHeaderInSection: 0, with: collectionView.bounds.width) {
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
            headerAttributes.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: headerHeight)
            headerCache.append(headerAttributes)
            contentHeight = headerHeight
            yOffset = Array(repeating: headerHeight, count: numberOfColumns)
        }

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let width = columnWidth - cellPadding * 2
            let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath, with: width) ?? 0
            let height = cellPadding + itemHeight + cellPadding
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        for attributes in headerCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionHeader {
            return headerCache.first { $0.indexPath == indexPath }
        }
        return nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
