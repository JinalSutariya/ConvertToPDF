//
//  SelectImageViewCell.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit

class SelectImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var closebtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    var onCloseButtonTapped: (() -> Void)?
    @IBAction func closeBtnTapped(_ sender: Any) {
           onCloseButtonTapped?()
       }
}
