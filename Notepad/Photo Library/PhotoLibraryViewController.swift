//
//  PhotoLibraryViewController.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/17.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit
import Photos

protocol SendPhotoDataDelegate: class {
    func sendPhoto(photos: Set<UIImage>)
}

class PhotoLibraryViewController: UIViewController {
    @IBOutlet weak var cvPhotoLibrary: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photoDelegate: SendPhotoDataDelegate?
    var libraryPhotos = [UIImage]() // 전체 사진 Data
    var selectedPhotos = Set<UIImage>() // 최종 선택된 사진 Data
    var selectedCells : NSMutableArray = [] // 최종 선택된 IndexPath Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---> Photo Library Start")
        
        self.setup()
    }
    
    private func setup(){
        self.setupNavigation()
        self.setupPhotoLibrary()
        
        self.cvPhotoLibrary.allowsMultipleSelection = true // 다중선택 허용
        self.cvPhotoLibrary.delegate = self
        self.cvPhotoLibrary.dataSource = self
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .yellow
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
    }
    
    
    func setupPhotoLibrary(){
        self.getLibraryData()
    }
    
    private func getLibraryData(){
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count == 0 {
            self.activityIndicator.stopAnimating()
            return
        }
        
        for fetchIndex in 0..<fetchResult.count {
            let asset = fetchResult.object(at: fetchIndex)
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                
                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: self.imageOption()) { (image, _) in
                    if(image != nil){
                        self.libraryPhotos.append(image!)
                    }
                    dispatchGroup.leave()
                }
                
                dispatchGroup.wait()
                self.cvPhotoLibrary.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // imgage의 option을 설정
    private func imageOption() -> PHImageRequestOptions{
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .current
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.resizeMode = .exact
        return imageRequestOptions
    }
    
    // 최종 선택 버튼(확인)을 눌렀을 때
    @IBAction func openFinalSelection(_ sender: Any){
        self.photoDelegate?.sendPhoto(photos: selectedPhotos) // 상위 controller에 photo data 넘겨주기
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Collection View Data Source
extension PhotoLibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraryPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCollectionViewCell", for: indexPath) as! PhotoLibraryCollectionViewCell
        cell.ivThumb.image = self.libraryPhotos[indexPath.item]

        if selectedCells.contains(indexPath) { // 선택되었을때
            cell.isSelected = true
            cvPhotoLibrary.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            cell.checkView.isHidden = false
        } else { // 선택을 풀었을때
            cell.isSelected = false
            cell.checkView.isHidden = true
        }
        return cell
    }
}

// MARK: - Collection View Delegate
extension PhotoLibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //선택을 했을때
        self.selectedCells.add(indexPath)
        self.selectedPhotos.insert(self.libraryPhotos[indexPath.row])
        self.cvPhotoLibrary.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) { //선택을 풀었을때
        self.selectedCells.remove(indexPath)
        self.selectedPhotos.remove(self.libraryPhotos[indexPath.row])
        self.cvPhotoLibrary.reloadItems(at: [indexPath])
     }
}

// MARK: - Collection View Delegate Flow Layout
extension PhotoLibraryViewController: UICollectionViewDelegateFlowLayout {
    
    var numberOfCellsInRow: Int { return 3 } // 1개의 행에 3개씩
    var cellSpacing: CGFloat { return 1 }
    var cellWidth: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
        return (deviceWidth - CGFloat(numberOfCellsInRow - 1) * cellSpacing) / CGFloat(numberOfCellsInRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
