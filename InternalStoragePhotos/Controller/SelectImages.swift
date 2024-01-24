//
//  SelectImages.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit

class SelectImages: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var fileBtn: UIButton!
    @IBOutlet weak var optionStackView: UIStackView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isOptionViewVisible = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionStackView.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout();
        
    }
    
    @IBAction func backTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func viewOptionTap(_ sender: Any) {
        
        optionStackView.isHidden = !optionStackView.isHidden
        
        isOptionViewVisible.toggle()
                
                UIView.transition(with: addBtn, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.addBtn.setImage(self.addBtnImage(), for: .normal)
                }, completion: nil)

                UIView.animate(withDuration: 0.3) {
                    self.optionStackView.alpha = self.isOptionViewVisible ? 2.0 : 0.0

                    self.optionStackView.isHidden = !self.isOptionViewVisible
                }
        
    }
    @IBAction func doneTap(_ sender: Any) {
        
        let infoViewController = storyboard?.instantiateViewController(identifier: "bottomSheet") as! BottomSheet
        infoViewController.modalPresentationStyle = .overCurrentContext
        infoViewController.modalTransitionStyle = .crossDissolve
        present(infoViewController, animated: true)
        
        
        
    }
    private func addBtnImage() -> UIImage? {
            let imageName = isOptionViewVisible ? "Group 33588" : "Group 146"
            return UIImage(named: imageName)
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectImageViewCell
        cell.backView.layer.cornerRadius = 5
        cell.imgView.layer.cornerRadius = 5
        cell.closebtn.roundCorners(corners: [.topRight, .bottomLeft], radius: 5)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3 - 10, height: 132)
    }
    
    
}

extension UIButton {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
