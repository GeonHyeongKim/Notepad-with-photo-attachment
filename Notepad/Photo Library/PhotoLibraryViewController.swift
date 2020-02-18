//
//  PhotoLibraryViewController.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/17.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit
import Photos

class PhotoLibraryViewController: UIViewController {
    @IBOutlet weak var cvPhotoLibrary: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("---> Photo Library Start")
        
        self.setup()
    }
    
    private func setup(){
        self.setupNavigation()
        self.setupPhotoLibrary()
        
        self.cvPhotoLibrary.delegate = self
        self.cvPhotoLibrary.dataSource = self
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = .yellow
    }
    
    // Load Photos
    private func setupPhotoLibrary(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.getLibraryData()
            case .denied, .restricted:
                let myAlert = UIAlertController(title: "사진 보관함에 접근 불가", message: "사진 보관함에 접근할 수 있도록 허용해 주세요.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated:true, completion:nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { status in
                    guard status == .authorized else { return }
                    self.getLibraryData()
                }            default:
                    print("예외상황 발생")
            }
        }
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
                        self.photos.append(image!)
                    }
                    dispatchGroup.leave()
                }
                
                dispatchGroup.wait()
                self.cvPhotoLibrary.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func imageOption() -> PHImageRequestOptions{
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .current
        imageRequestOptions.isSynchronous = true
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.resizeMode = .exact
        return imageRequestOptions
    }
}

// MARK: - Collection View Data Source
extension PhotoLibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCollectionViewCell", for: indexPath) as! PhotoLibraryCollectionViewCell
        cell.ivThumb.image = self.photos[indexPath.item]
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension PhotoLibraryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let videoUrl = urlList[indexPath.row]
        //        self.performSegue(withIdentifier: "showVideoEditorViewController", sender: videoUrl)
    }
}

// MARK: - Collection View Delegate Flow Layout
extension PhotoLibraryViewController: UICollectionViewDelegateFlowLayout {
    
    var numberOfCellsInRow: Int { return 3 }
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
