//
//  ConvertingToPDF.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit

class ConvertingToPDF: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var circleView: UIView!
    
    var value = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        circleView.layer.cornerRadius = circleView.frame.height/2
            
    }
  
    @IBAction func closeTap(_ sender: Any) {
        self.dismiss(animated: true)

    }
    @IBAction func tapNext(_ sender: Any) {
       
        let vc = storyboard?.instantiateViewController(identifier: "convertedSuccessfully") as! ConvertedSuccessfully
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
