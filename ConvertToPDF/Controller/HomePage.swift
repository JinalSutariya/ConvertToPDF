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

    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var pdfBtn: UIButton!
    @IBOutlet weak var modeChange: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.layer.cornerRadius = 10
        fileView.layer.cornerRadius =  10
        galleryView.layer.cornerRadius = 10
        cameraView.layer.cornerRadius = 10
        
        let galleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        galleryView.addGestureRecognizer(galleryTapGesture)
        galleryBtn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        
        let pdfTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        pdfView.addGestureRecognizer(pdfTapGesture)
        pdfBtn.addTarget(self, action: #selector(genratedPDf), for: .touchUpInside)
        
        let cameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraViewTapped))
        cameraView.addGestureRecognizer(cameraTapGesture)
        cameraBtn.addGestureRecognizer(cameraTapGesture)
        
    }
   
    @IBAction func themTap(_ sender: Any) {
     
       
    }
    

        // Delegate method to handle image selection
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                // Save the image to the photo library
                UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            
            // Dismiss the image picker controller
            picker.dismiss(animated: true, completion: nil)
        }

        // Method called after image is saved to the photo library
        @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                print("Error saving image: \(error.localizedDescription)")
            } else {
                print("Image saved successfully.")
            }
        }
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
       navigateToselectFolder()
        genratedPDf()

    }
       

    
    @objc func saveImage() {
        navigateToselectFolder()
    }
    @objc func genratedPDf() {
        genratedPDFFolder()
    }
    @objc func cameraViewTapped() {
            openCamera()
        }

        func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .camera
                imagePickerController.mediaTypes = [String(kUTTypeImage)]
                present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available.")
            }
        }
    func navigateToselectFolder(){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "selectFolder") as! SelectFolder
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func genratedPDFFolder(){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "genratedPDF") as! GenratedPDF
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
   
}

