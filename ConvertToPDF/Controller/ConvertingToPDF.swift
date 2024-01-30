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
    
    @IBOutlet weak var progressCount: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var circleView: UIView!
    var selectedAssets: [PHAsset] = []
    
    var value = 0.0
    var fileName: String?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            print("Number of selected images: \(selectedAssets.count)")
            circleView.layer.cornerRadius = circleView.frame.height / 2

            createPDFFromSelectedAssets { pdfURL, size, date in
                if let pdfURL = pdfURL {
                    // Animate the progress view to 100%
                    self.progressView.setProgress(1.0, animated: true)

                    // Delay the presentation of the next view controller to allow the animation to finish
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let vc = self.storyboard?.instantiateViewController(identifier: "convertedSuccessfully") as! ConvertedSuccessfully
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .coverVertical
                        vc.generatedPDFURL = pdfURL
                        vc.fileName = self.fileName
                        vc.pdfSize = size
                        vc.pdfCreationDate = date
                        self.present(vc, animated: true)
                    }
                } else {
                    print("Failed to create PDF.")
                }
            }
        }

    @IBAction func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    func createPDFFromSelectedAssets(completion: @escaping (URL?, String, String) -> Void) {
           let pdfDocument = PDFDocument()
           let dispatchGroup = DispatchGroup()

           var totalSize = 0

           for (index, asset) in selectedAssets.enumerated() {
               dispatchGroup.enter()

               PHImageManager.default().requestImageData(for: asset, options: nil) { (data, _, _, info) in
                   if let data = data, let image = UIImage(data: data) {
                       if let pdfPage = PDFPage(image: image) {
                           pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
                       }
                   }

                   // Update progress view and label with delay
                   let progress = Float(index + 1) / Float(self.selectedAssets.count)
                   self.updateProgressViewWithDelay(progress, index + 1, self.selectedAssets.count, index)

                   // Calculate total size
                   totalSize += data?.count ?? 0

                   dispatchGroup.leave()
               }
           }

           dispatchGroup.notify(queue: .main) {
               let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(self.fileName!)

               // Format size
               let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(totalSize), countStyle: .file)

               // Format date
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "dd MMM yyyy"
               let formattedDate = dateFormatter.string(from: Date())

               pdfDocument.write(to: pdfURL)
               completion(pdfURL, formattedSize, formattedDate)
           }
       }

       func updateProgressViewWithDelay(_ progress: Float, _ currentIndex: Int, _ totalCount: Int, _ imageIndex: Int) {
           // Introduce a delay for each image to be processed
           let delayInSeconds = Double(imageIndex) * 0.5 // Adjust the delay time as needed
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
               self.progressView.setProgress(progress, animated: true)
               self.progressCount.text = "\(currentIndex) / \(totalCount)"
           }
       }

       func downloadPDF(pdfURL: URL) {
           print("PDF downloaded at: \(pdfURL.path)")
       }

       deinit {
           NotificationCenter.default.removeObserver(self)
       }
   }
