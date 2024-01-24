//
//  SelectFolder.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit

class SelectFolder: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    

    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
extension SelectFolder: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectFolderViewCell
        cell.selectionStyle = .none
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "imageCount") as! ImageCount
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    
    
}
