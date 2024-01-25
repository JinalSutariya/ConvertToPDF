//
//  GeneratedPDFTableViewCell.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 24/01/24.
//

import UIKit
protocol GeneratedPDFTableViewCellDelegate: AnyObject {
    func didTapMoreButton(inCell cell: GeneratedPDFTableViewCell)
}

class GeneratedPDFTableViewCell: UITableViewCell {

    @IBOutlet weak var tapMore: UIButton!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    weak var delegate: GeneratedPDFTableViewCellDelegate?

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        @IBAction func moreTap(_ sender: Any) {
            // Notify the delegate when the more button is tapped
            delegate?.didTapMoreButton(inCell: self)
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

}

