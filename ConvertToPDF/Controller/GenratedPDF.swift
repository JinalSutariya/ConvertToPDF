//
//  GenratedPDF.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 24/01/24.
//

import UIKit
import QuickLook

class GenratedPDF: UIViewController, GeneratedPDFTableViewCellDelegate, MenuDelegate {
    
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var SortingView: UIView!
    @IBOutlet weak var nilDataImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var isSortingViewVisible = false
    var generatedPDFURL: URL?
    var pdfFiles: [URL] = [ ]
    var pdfInfo: [PDFInfo] = []
    var filter: CIFilter?
    
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
    
    func deletePDF(at index: Int) {
        let pdfURL = pdfFiles[index]
        
        do {
            try FileManager.default.removeItem(at: pdfURL)
            pdfFiles.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            updateTableViewVisibility()
        } catch {
            print("Error delete PDF file: \(error.localizedDescription)")
        }
    }
    func getAllPDFFilesInDocumentDirectory() -> [PDFInfo] {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: [])
            
            // Create PDFInfo instances from URLs
            let pdfFiles = files.map { PDFInfo(title: $0.lastPathComponent, subtitle: "", size: "") }
        
            
            return pdfFiles
        } catch {
            print("Error getting PDF files: \(error.localizedDescription)")
            return []
        }
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
        if let indexPath = tableView.indexPath(for: cell) {
            let infoViewController = storyboard?.instantiateViewController(identifier: "menu") as! Menu
            infoViewController.modalPresentationStyle = .overCurrentContext
            infoViewController.modalTransitionStyle = .crossDissolve
            infoViewController.delegate = self
            infoViewController.selectedIndex = indexPath.row
            present(infoViewController, animated: true)
        }
    }
    
    func didTapMore(inCell cell: GeneratedPDFTableViewCell){
        
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
