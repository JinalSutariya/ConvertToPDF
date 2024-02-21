//
//  ConvertedSucessfully.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 25/01/24.
//

import UIKit

class ConvertedSuccessfully: UIViewController {
    
    @IBOutlet weak var sizeAndDateLbl: UILabel!
    @IBOutlet weak var pdfName: UILabel!
    @IBOutlet weak var pdfView: UIView!
    
    var generatedPDFURL: URL?
    var fileName: String?
    var pdfSize: String?
    var pdfCreationDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedFileName = fileName {
            pdfName.text = "\(unwrappedFileName).pdf"
        }
        pdfView.layer.cornerRadius = 15
        pdfView.layer.shadowColor = UIColor.gray.cgColor
        pdfView.layer.shadowOpacity = 0.5
        pdfView.layer.shadowOffset = CGSize.zero
        pdfView.layer.shadowRadius = 8
        
        if let size = pdfSize, let date = pdfCreationDate {
            let formattedSizeAndDate = "\(size), \(date)"
            sizeAndDateLbl.text = formattedSizeAndDate
        }
    }
    
    @IBAction func closeTap(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    
    @IBAction func downloadTap(_ sender: Any) {
        guard let pdfURL = generatedPDFURL else {
            print("No PDF URL available.")
            return
        }
        downloadPDF(url: pdfURL) { result in
            switch result {
            case .success(let downloadedURL):
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(identifier: "genratedPDF") as! GenratedPDF
                    vc.generatedPDFURL = downloadedURL
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .coverVertical
                    self.present(vc, animated: true)
                }
            case .failure(let error):
                print("Error downloading PDF: \(error.localizedDescription)")
            }
        }
    }
    
    func downloadPDF(url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        // Perform the download task
        URLSession.shared.downloadTask(with: url) { [self] (tempURL, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL else {
                completion(.failure(NSError(domain: "Downloaded file URL is nil", code: 0, userInfo: nil)))
                return
            }
            
            do {
                
                let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                
                // Ensure that the fileName has the ".pdf" extension
                let fileNameWithExtension = (fileName?.lowercased().hasSuffix(".pdf") ?? false) ? fileName : "\(fileName!).pdf"
                
                let destinationURL = documentsURL.appendingPathComponent(fileNameWithExtension!)
                print(destinationURL.path)
                
                // Move the downloaded file to the destination URL
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                
                
                // Completion with the success and destination URL
                completion(.success(destinationURL))
            } catch {
                // Completion with the failure and error
                completion(.failure(error))
            }
        }.resume()
        
    }
    
}
