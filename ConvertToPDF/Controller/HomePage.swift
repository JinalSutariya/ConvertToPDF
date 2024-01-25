//
//  HomePage.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit

class HomePage: UIViewController {

    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var pdfView: UIView!
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var modeChange: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        pdfView.layer.cornerRadius = 10
        fileView.layer.cornerRadius =  10
        galleryView.layer.cornerRadius = 10
        cameraView.layer.cornerRadius = 10
        let thirdTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        galleryView.addGestureRecognizer(thirdTapGesture)
        galleryBtn.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        


    }
   
    @IBAction func themTap(_ sender: Any) {
     
       
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
       navigateToselectFolder()
        
    }
       

    
    @objc func saveImage() {
        navigateToselectFolder()
    }
    
    func navigateToselectFolder(){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "selectFolder") as! SelectFolder
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
   
}

