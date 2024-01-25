//
//  ConvertingToPDF.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import Photos
import PDFKit

class ConvertingToPDF: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var circleView: UIView!
    var selectedAssets: [PHAsset] = []
    
    var value = 0.0
    var fileName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Number of selected images: \(selectedAssets.count)")
        circleView.layer.cornerRadius = circleView.frame.height/2
        
    }
    
    @IBAction func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    @IBAction func tapNext(_ sender: Any) {
        
        createPDFFromSelectedAssets { pdfURL in
            if let pdfURL = pdfURL {
                // Present a view controller to show the successful conversion
                let vc = self.storyboard?.instantiateViewController(identifier: "convertedSuccessfully") as! ConvertedSuccessfully
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .coverVertical
                
                // Pass the generated PDF URL to the ConvertedSuccessfully class
                vc.generatedPDFURL = pdfURL
                vc.fileName = self.fileName
                self.present(vc, animated: true)
                
            } else {
                
                print("Failed to create PDF.")
            }
        }
        
    }
    
    func createPDFFromSelectedAssets(completion: @escaping (URL?) -> Void) {
        // Create a PDF document
        let pdfDocument = PDFDocument()
        
        // Create a dispatch group to wait for all asynchronous tasks to complete
        let dispatchGroup = DispatchGroup()
        
        for asset in selectedAssets {
            dispatchGroup.enter()
            
            // Request the image data for each asset
            PHImageManager.default().requestImageData(for: asset, options: nil) { (data, _, _, _) in
                if let data = data, let image = UIImage(data: data) {
                    // Convert the image to a PDF page
                    if let pdfPage = PDFPage(image: image) {
                        // Add the PDF page to the document
                        pdfPage.displaysAnnotations
                        pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        // Notify when all tasks are complete
        dispatchGroup.notify(queue: .main) {
            // Save the PDF to a temporary file
            let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(self.fileName!)
            pdfDocument.write(to: pdfURL)
            
            completion(pdfURL)
        }
    }
    
    func downloadPDF(pdfURL: URL) {
        // Perform any necessary steps to download the PDF, e.g., presenting a share sheet or saving to a specific location.
        // Here, we'll just print the path to the console.
        print("PDF downloaded at: \(pdfURL.path)")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
