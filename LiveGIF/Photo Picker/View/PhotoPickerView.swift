//
//  PhotoPickerView.swift
//  LiveGIF
//
//  Created by Egor Kisilev on 7/16/18.
//  Copyright © 2018 Egor Kisilev. All rights reserved.
//

import UIKit
import Photos


final class PhotoPickerView: UIViewController, PhotoPickerViewing {
    
    //MARK: PhotoPickerViewing
    static func instantiate() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "photoPickerRoot")
    }
    
    var delegate: PhotoPickerViewingDelegate?

    var viewController: UIViewController {
        return self
    }
    
    var allowsMultipleSelection: Bool = true
    
    //MARK: Outlets
    @IBOutlet private weak var collectionView: UICollectionView!

    
    //MARK: Private variables
    private lazy var cachingManager = PHCachingImageManager()
    
    private var assets: [PHAsset]? {
        willSet { cachingManager.stopCachingImagesForAllAssets() }
        didSet { cacheImages(for: assets) }
    }
    
    private lazy var selectedAssets: [PHAsset] = []
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            AssetCollectionSectionFooter.nib,
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: "assetSectionFooter"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if let count = assets?.count {
            collectionView.scrollToItem(
                at: IndexPath(item: count - 1, section: 0),
                at: .bottom,
                animated: true
            )
        }
    }
    
    
    func showAssets(_ assets: [PHAsset]?) {
        self.assets = assets
        if viewIfLoaded != nil {
            collectionView.reloadData()
        }
    }
    
    private func cacheImages(for assets: [PHAsset]?) {
        guard let assets = assets else { return }
        cachingManager.startCachingImages(
            for: assets,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFill,
            options: nil
        )
    }
    
    
    /// Returns current asset selection state
    @discardableResult
    private func toggleSelectionOnAsset(at index: Int) -> Bool {
        guard let asset = assets?[index] else { return false }
        
        let isSelected = selectedAssets.contains(asset)
        
        if isSelected {
            if let index = selectedAssets.index(of: asset) {
                selectedAssets.remove(at: index)
            }
        } else {
            if allowsMultipleSelection == false,
               let current = selectedAssets.first,
               let index = assets?.index(of: current) {
                toggleSelectionOnAsset(at: index)
                UIView.performWithoutAnimation {
                    self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                }
            }
            selectedAssets.append(asset)
        }
        
        return !isSelected
    }
    
    
    @IBAction func done(_ sender: Any) {
        delegate?.photoPickerView(self, didSelect: selectedAssets)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.photoPickerViewDidDismiss(strongSelf)
            }
        }
    }
}


extension PhotoPickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetCell.identifier, for: indexPath) as? AssetCell else {
            preconditionFailure("Could not initialize cell for displaying asset")
        }

        if cell.tag != 0 {
            cachingManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        guard let asset = assets?[indexPath.row] else {
            return cell
        }
        
        let isSelected = selectedAssets.contains(asset)
        
        let tag = cachingManager.requestImage(
            for: asset,
            targetSize: cell.frame.size,
            contentMode: .aspectFill,
            options: nil) { (image, _) in
                cell.setup(with: image, selected: isSelected)
        }
        
        cell.tag = Int(tag)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "assetSectionFooter",
                for: indexPath) as? AssetCollectionSectionFooter else {
                    preconditionFailure("Couldnt init footer for asset section")
            }
            
            footer.setup(photoCount: assets?.count ?? 0)
            return footer
        }
        
        return UICollectionReusableView()
    }
    
}



extension PhotoPickerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isSelected = toggleSelectionOnAsset(at: indexPath.row)
        
        let cell = collectionView.cellForItem(at: indexPath) as? AssetCell
        cell?.setSelected(isSelected)
    }
}



extension PhotoPickerView: UICollectionViewDelegateFlowLayout {
    
    private var interitemSpacing: CGFloat { return 1 }
    private var itemsPerLine: Int { return 4 }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let side = (collectionView.bounds.width - (CGFloat(itemsPerLine - 1) * interitemSpacing)) / CGFloat(itemsPerLine)
        let size = CGSize(width: side, height: side)
        return size
    }
}
