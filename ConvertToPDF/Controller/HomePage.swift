//
//  HomePage.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

class HomePage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var pdfBtn: UIButton!
    @IBOutlet weak var modeChange: UIButton!
    var yourDataArray: [UIImage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImagesFromGallery()

        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        
        pdfView.layer.cornerRadius = 10
        fileView.layer.cornerRadius =  10
        galleryView.layer.cornerRadius = 10
        cameraView.layer.cornerRadius = 10
        
        let galleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(saveImage))
        galleryView.addGestureRecognizer(galleryTapGesture)
        galleryBtn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        
        let pdfTapGesture = UITapGestureRecognizer(target: self, action: #selector(genratedPDf))
        pdfView.addGestureRecognizer(pdfTapGesture)
        pdfBtn.addTarget(self, action: #selector(genratedPDf), for: .touchUpInside)
        
        let cameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraViewTapped))
        cameraView.addGestureRecognizer(cameraTapGesture)
        cameraBtn.addGestureRecognizer(cameraTapGesture)
        
        let fileTapGesture = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        fileView.addGestureRecognizer(fileTapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        
        let heightFilterCOll = self.collectionView.contentSize.height
        self.collectionViewHeight.constant = heightFilterCOll
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                collectionViewHeight.constant = newsize.height
            }
        }
        
    }
    
    @IBAction func themTap(_ sender: Any) {
        if traitCollection.userInterfaceStyle == .light {
                  overrideUserInterfaceStyle = .dark
              } else {
                  overrideUserInterfaceStyle = .light
              }
    }
    
    @objc func openGallery() {
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = .photoLibrary
           imagePickerController.mediaTypes = [String(kUTTypeImage)]
           present(imagePickerController, animated: true, completion: nil)
       }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                // Save the captured image to the photo library
                UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

                // Insert the new image at the beginning of yourDataArray
                yourDataArray.insert(selectedImage, at: 0)

                // Reload the first section of the collectionView
                collectionView.reloadSections(IndexSet(integer: 0))

                // Dismiss the image picker
                picker.dismiss(animated: true, completion: {
                    // Additional actions after dismissal, if needed
                })
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully.")
        }
    }
    
    @objc func saveImage() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "selectFolder") as! SelectFolder
        self.navigationController?.pushViewController(secondViewController, animated: true)    }
    
    @objc func genratedPDf() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "genratedPDF") as! GenratedPDF
        self.navigationController?.pushViewController(secondViewController, animated: true)    }
    
    @objc func cameraViewTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = [String(kUTTypeImage)]
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Camera not available.")
        }        }
    
    
    func fetchImagesFromGallery() {
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        for index in 0..<assets.count {
            let asset = assets[index]
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true

            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                if let image = image {
                    self.yourDataArray.append(image)
                }
            }
        }

        // Reverse the order of yourDataArray
        yourDataArray.reverse()

        collectionView.reloadData()
    }
}

extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
       return yourDataArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        let image = yourDataArray[indexPath.item]
        cell2.imgView.image = image
        cell2.imgView.layer.cornerRadius = 15
        return cell2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: 102)

        
    }
    
}
