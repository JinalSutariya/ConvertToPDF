//
//  GenratedPDF.swift
//  ConvertToPDF
//
//  Created by CubezyTech on 24/01/24.
//

import UIKit

class GenratedPDF: UIViewController, GeneratedPDFTableViewCellDelegate {

    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var SortingView: UIView!
    @IBOutlet weak var nilDataImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var isSortingViewVisible = false

    override func viewDidLoad() {
            super.viewDidLoad()
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GeneratedPDFTableViewCell
            cell.selectionStyle = .none
        cell.delegate = self

            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
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
