//
//  GenratedPDF.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 24/01/24.
//

import UIKit
import QuickLook

class GenratedPDF: UIViewController, GeneratedPDFTableViewCellDelegate {

    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var SortingView: UIView!
    @IBOutlet weak var nilDataImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var isSortingViewVisible = false
    var generatedPDFURL: URL?
    var pdfFiles: [URL] = []

    override func viewDidLoad() {
            super.viewDidLoad()
        
        pdfFiles = getAllPDFFilesInDocumentDirectory()
        SortingView.isHidden = true
        SortingView.layer.cornerRadius = 15
        SortingView.layer.shadowColor = UIColor.gray.cgColor
        SortingView.layer.shadowOpacity = 0.5
        SortingView.layer.shadowOffset = CGSize.zero
        SortingView.layer.shadowRadius = 8
        
            tableView.delegate = self
            tableView.dataSource = self
            updateTableViewVisibility()
        }

       
    @IBAction func sortTap(_ sender: Any) {
        isSortingViewVisible.toggle()
               SortingView.isHidden = !isSortingViewVisible
    }
    @IBAction func backTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    func reloadData() {
        tableView.reloadData()
        updateTableViewVisibility()
    }
    func updateTableViewVisibility() {
          let hasData = pdfFiles.count > 0
          tableView.isHidden = !hasData
          nilDataImage.isHidden = hasData
      }
    func getAllPDFFilesInDocumentDirectory() -> [URL] {
            do {
                // Get the document directory path
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

                // Get all files in the directory
                let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])

                // Filter PDF files
                let pdfFiles = files.filter { $0.pathExtension.lowercased() == "pdf" }

                return pdfFiles
            } catch {
                print("Error getting PDF files: \(error.localizedDescription)")
                return []
            }
        }


}
extension GenratedPDF: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pdfFiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GeneratedPDFTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self

        let pdfURL = pdfFiles[indexPath.row]
        let pdfName = pdfURL.lastPathComponent
        cell.titleLbl.text = pdfName

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pdfURL = pdfFiles[indexPath.row]
        presentPreviewController(with: pdfURL)
    }

    func presentPreviewController(with pdfURL: URL) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = pdfFiles.firstIndex(of: pdfURL) ?? 0
        present(previewController, animated: true, completion: nil)
    }

    func didTapMoreButton(inCell cell: GeneratedPDFTableViewCell) {
        let infoViewController = storyboard?.instantiateViewController(identifier: "menu") as! Menu
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.modalTransitionStyle = .crossDissolve
        present(infoViewController, animated: true)
    }
}

extension GenratedPDF: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return pdfFiles.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return pdfFiles[index] as QLPreviewItem
    }
}
