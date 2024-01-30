//
//  ViewController.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import Photos

class ImageCount: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SelectImagesDelegate {
   


    @IBOutlet weak var rightTap: UIButton!
    @IBOutlet weak var countImageLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndexPaths: [IndexPath] = []
    var selectedFolder: ImageFolder!

       override func viewDidLoad() {
           super.viewDidLoad()
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.collectionViewLayout = UICollectionViewFlowLayout();
           
       }
    @IBAction func bsckTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func tapRight(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "selectImages") as! SelectImages
        secondViewController.selectedAssets = selectedIndexPaths.map { selectedFolder.assets[$0.item] }
        secondViewController.delegate = self // Set the delegate
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func updateImageCounterLabel() {
        let count = selectedIndexPaths.count

        if count > 0 {
            rightTap.isHidden = false
            countImageLbl.isHidden = false
            countImageLbl.text = "Count \(count)"
        } else {
            rightTap.isHidden = true

            countImageLbl.isHidden = true
        }
    }
       // MARK: - UICollectionViewDataSource

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return selectedFolder.assets.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCountCell
           cell.selectImgView.layer.cornerRadius = 16
           cell.imageView.layer.cornerRadius = 16
           let asset = selectedFolder.assets[indexPath.item]
                  
                  let imageManager = PHImageManager.default()
                  imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
                      
                      cell.imageView.image = image
                      
                  }
           if selectedIndexPaths.contains(indexPath) {
                   // Show selectImgView and hide ticImgView
                   cell.selectImgView.isHidden = false
                   cell.ticImgView.isHidden = false
               } else {
                   // Show ticImgView and hide selectImgView
                   rightTap.isHidden = true

                   countImageLbl.isHidden = true
                   cell.selectImgView.isHidden = true
                   cell.ticImgView.isHidden = true
               }
           return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: 102)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let index = selectedIndexPaths.firstIndex(of: indexPath) {
                selectedIndexPaths.remove(at: index)
            } else {
                selectedIndexPaths.append(indexPath)
            }

            // Reload the selected cell to update its appearance
            collectionView.reloadItems(at: [indexPath])

            // Update the image counter label
            updateImageCounterLabel()
        }

        // Delegate method to handle selection changes
        func didSelectAssets(_ assets: [PHAsset]) {
            // Update the selectedIndexPaths and UI in ImageCount
            selectedIndexPaths = assets.enumerated().compactMap { (index, asset) in
                return selectedFolder.assets.firstIndex { $0 == asset }.map { IndexPath(item: $0, section: 0) }
            }

            collectionView.reloadData()
            updateImageCounterLabel()
        }
     
   }
