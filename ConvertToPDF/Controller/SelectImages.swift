//
//  SelectImages.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation

protocol SelectImagesDelegate: AnyObject {
    func didSelectAssets(_ assets: [PHAsset])
    
}

class SelectImages: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var fileBtn: UIButton!
    @IBOutlet weak var optionStackView: UIStackView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isOptionViewVisible = false
    var selectedAssets: [PHAsset] = []
    weak var delegate: SelectImagesDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionStackView.isHidden = true
        

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout();
        
    }
    @IBAction func cameraBtnTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = [String(kUTTypeImage)]
                present(imagePickerController, animated: true, completion: nil)
            } else {
                // Handle the case where the camera is not available (e.g., simulator)
                print("Camera not available.")
            }
        
        
    }
    @IBAction func backTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func viewOptionTap(_ sender: Any) {
        
        optionStackView.isHidden = !optionStackView.isHidden
        
        isOptionViewVisible.toggle()
        
        UIView.transition(with: addBtn, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.addBtn.setImage(self.addBtnImage(), for: .normal)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.optionStackView.alpha = self.isOptionViewVisible ? 2.0 : 0.0
            
            self.optionStackView.isHidden = !self.isOptionViewVisible
        }
        
    }
    @IBAction func convertPdfTap(_ sender: Any) {
        
        let infoViewController = storyboard?.instantiateViewController(identifier: "bottomSheet") as! SaveImagesBottomSheet
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.modalTransitionStyle = .crossDissolve
        
        // Pass selected assets to the SaveImagesBottomSheet
        infoViewController.selectedAssets = selectedAssets
        
        present(infoViewController, animated: true)
        
    }
    
    @IBAction func galleryBtnTap(_ sender: Any) {
        showImagePicker()
        
    }
  
    private func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [String(kUTTypeImage)]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Delegate method to handle image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage,
           let phAsset = info[.phAsset] as? PHAsset {
            
            // Add the selected PHAsset to your array
            selectedAssets.append(phAsset)
            
            // Notify the delegate about the updated selection
            delegate?.didSelectAssets(selectedAssets)
            
            // Reload the collectionView to display the new selected image
            collectionView.reloadData()
        }
        
        // Dismiss the image picker controller
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Delegate method to handle image picker cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    private func addBtnImage() -> UIImage? {
        let imageName = isOptionViewVisible ? "Group 33588" : "Group 146"
        return UIImage(named: imageName)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectImageViewCell
        cell.backView.layer.cornerRadius = 5
        cell.imgView.layer.cornerRadius = 5
        
        cell.closebtn.roundCorners(corners: [.topRight, .bottomLeft], radius: 5)
        
        let imageManager = PHImageManager.default()
        imageManager.requestImage(for: selectedAssets[indexPath.item], targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
            cell.imgView.image = image
        }
        
        cell.onCloseButtonTapped = {
            // Handle close button tap
            self.selectedAssets.remove(at: indexPath.item)
            collectionView.reloadData()
            
            // Notify the delegate about the updated selection
            self.delegate?.didSelectAssets(self.selectedAssets)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: 132)
    }
}

extension UIButton {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
