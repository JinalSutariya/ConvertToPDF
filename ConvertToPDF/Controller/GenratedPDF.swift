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

    override func viewDidLoad() {
            super.viewDidLoad()
        
        print("genratedPDF URl:----",generatedPDFURL)
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
}
extension GenratedPDF: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GeneratedPDFTableViewCell
            cell.selectionStyle = .none
        cell.delegate = self
        if let pdfURL = generatedPDFURL {
                    let pdfName = pdfURL.lastPathComponent
                    cell.titleLbl.text = pdfName
                }
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pdfURL = generatedPDFURL {
            let previewController = QLPreviewController()
            previewController.dataSource = self
            present(previewController, animated: true, completion: nil)
        }
    }
    func didTapMoreButton(inCell cell: GeneratedPDFTableViewCell) {
           let infoViewController = storyboard?.instantiateViewController(identifier: "menu") as! Menu
           infoViewController.modalPresentationStyle = .overCurrentContext
           infoViewController.modalTransitionStyle = .crossDissolve
           present(infoViewController, animated: true)
       }
        func updateTableViewVisibility() {
            let hasData = tableView.numberOfRows(inSection: 0) > 0
            tableView.isHidden = !hasData
            nilDataImage.isHidden = hasData
        }
  
}
extension GenratedPDF: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return generatedPDFURL != nil ? 1 : 0
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return generatedPDFURL! as QLPreviewItem
    }
}
