//
//  SelectImages.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import Photos
import MobileCoreServices
import PDFKit // Add this import statement

protocol SaveImagesBottomSheetDelegate: AnyObject {
    func createPDF(from images: [PHAsset])
}
protocol SelectImagesDelegate: AnyObject {
    func didSelectAssets(_ assets: [PHAsset])
}
class SelectImages: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SaveImagesBottomSheetDelegate {
    

    
    
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
        
        guard !selectedAssets.isEmpty else {
            // Handle case where no images are selected
            return
        }

        let infoViewController = storyboard?.instantiateViewController(identifier: "bottomSheet") as! SaveImagesBottomSheet
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.modalTransitionStyle = .crossDissolve
        infoViewController.selectedImages = selectedAssets
        infoViewController.delegate = self // Set the delegate to handle PDF creation
        present(infoViewController, animated: true)

        
    }
    @IBAction func galleryBtnTap(_ sender: Any) {
        showImagePicker()

        }
    func createPDF(from images: [PHAsset]) {
        // Ensure there are selected images
        guard !images.isEmpty else {
            // Handle the case where no images are selected
            return
        }

        // Create a PDF document
        let pdfDocument = PDFDocument()

        // Create a dispatch group to wait for all download tasks to complete
        let downloadGroup = DispatchGroup()

        // Loop through selected images and add them to the PDF
        for asset in images {
            downloadGroup.enter()

            PHImageManager.default().requestImageData(for: asset, options: nil) { (imageData, _, _, _) in
                defer {
                    downloadGroup.leave()
                }

                guard let data = imageData, let image = UIImage(data: data) else {
                    return
                }

                // Create a PDF page
                let pdfPage = PDFPage(image: image)

                // Add the PDF page to the document
                pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
            }
        }

        // Notify when all download tasks are complete
        downloadGroup.notify(queue: DispatchQueue.main) {
            // Save the PDF to a file in the documents directory
            let pdfFileName = "SelectedImages.pdf"
            let pdfURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(pdfFileName)
            pdfDocument.write(to: pdfURL)

            // Optionally, you can use the pdfURL for further processing (e.g., sharing, displaying)
            print("PDF downloaded and saved at: \(pdfURL)")
        }
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
