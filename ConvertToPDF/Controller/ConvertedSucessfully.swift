//
//  ConvertedSucessfully.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 25/01/24.
//

import UIKit

class ConvertedSuccessfully: UIViewController {

    @IBOutlet weak var pdfView: UIView!
    var generatedPDFURL: URL?
    var fileName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.layer.cornerRadius = 15
        pdfView.layer.shadowColor = UIColor.gray.cgColor
        pdfView.layer.shadowOpacity = 0.5
        pdfView.layer.shadowOffset = CGSize.zero
        pdfView.layer.shadowRadius = 8
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
                // Move the downloaded file to the destination directory
                let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let destinationURL = documentsURL.appendingPathComponent(fileName!)
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
