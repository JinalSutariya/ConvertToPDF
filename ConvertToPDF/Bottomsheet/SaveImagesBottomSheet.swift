//
//  BottomSheet.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import Foundation
import Photos
class SaveImagesBottomSheet: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var switchPass: UISwitch!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var fileNameTxt: UITextField!
    @IBOutlet weak var compressImgSlider: CustomSlider!
    var selectedAssets: [PHAsset] = []
    
    lazy var lightBackgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.frame = self.view.bounds
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bottomView.layer.cornerRadius = 15
        setupView()
        fileNameTxt.delegate = self
        passTxt.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func donebtnTap(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func okTap(_ sender: Any) {
        
        self.dismiss(animated: true)
        
        // Pass selected assets to ConvertingToPDF
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "convertToPDF") as? ConvertingToPDF {
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            controller.selectedAssets = selectedAssets
            controller.fileName = fileNameTxt.text
            self.presentingViewController?.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func setupView() {
        
        view.addSubview(lightBackgroundView)
        view.sendSubviewToBack(lightBackgroundView)
    }
    
}

class CustomSlider: UISlider {
    
    @IBInspectable open var trackWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
            updateThumbImage()
        }
    }
    
    @IBInspectable open var thumbSize: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            updateThumbImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateThumbImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateThumbImage()
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
    
    private func updateThumbImage() {
        let thumbImage = UIImage.circle(diameter: max(thumbSize.width, thumbSize.height), color: (thumbTintColor ?? UIColor(named: "C_MainColor"))!)
        setThumbImage(thumbImage, for: .normal)
    }
    
}

extension UIImage {
    static func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}

