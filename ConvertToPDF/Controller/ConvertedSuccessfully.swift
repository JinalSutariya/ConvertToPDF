//
//  ConvertedSuccessfully.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 24/01/24.
//

import UIKit

class ConvertedSuccessfully: UIViewController {

    @IBOutlet weak var pdfView: UIView!
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
        
        let vc = storyboard?.instantiateViewController(identifier: "genratedPDF") as! GenratedPDF
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    

}
