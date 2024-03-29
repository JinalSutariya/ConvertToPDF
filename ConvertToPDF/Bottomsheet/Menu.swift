//
//  Menu.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 24/01/24.
//

import UIKit
protocol MenuDelegate: AnyObject {
    func deletePDF(at index: Int)
}
class Menu:  UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var renameBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var amount = ""
    weak var delegate: MenuDelegate?
    var selectedIndex: Int = 0

    lazy var lightBackgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // Set your desired transparency level here
        
        view.frame = self.view.bounds
        return view
    }()
    let grabberView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.layer.cornerRadius = 20
        setupView()
        grabberView.isHidden = false
        
        grabberView.backgroundColor = UIColor(named: "C_MainColor")
        grabberView.layer.cornerRadius = 3
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(grabberView)
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8), // Adjust the top spacing as needed
            grabberView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 40), // Adjust the width as needed
            grabberView.heightAnchor.constraint(equalToConstant: 6) // Adjust the height as needed
        ])
        
        //  bottomView.layer.cornerRadius = 15
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        lightBackgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapOutside() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func renameTap(_ sender: Any) {
    }
    @IBAction func deleteTap(_ sender: Any) {
        delegate?.deletePDF(at: selectedIndex)
            grabberView.isHidden = true
            dismiss(animated: true)
        
    }
    func setupView() {
        view.addSubview(lightBackgroundView)
        view.sendSubviewToBack(lightBackgroundView)
    }
   
}

