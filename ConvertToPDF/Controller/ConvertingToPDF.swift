//
//  ConvertingToPDF.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit

class ConvertingToPDF: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeTap(_ sender: Any) {
        self.dismiss(animated: true)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
