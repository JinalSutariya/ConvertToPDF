//
//  ViewController.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import Photos

class ImageCount: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var rightTap: UIButton!
    @IBOutlet weak var countImageLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndexPaths: [IndexPath] = []

       override func viewDidLoad() {
           super.viewDidLoad()
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.collectionViewLayout = UICollectionViewFlowLayout();
           
       }
    @IBAction func bsckTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func tapPdf(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "selectImages") as! SelectImages
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
           return 20
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCountCell
           cell.selectImgView.layer.cornerRadius = 16
           
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
     
   }
