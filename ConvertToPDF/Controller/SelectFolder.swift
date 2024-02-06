//
//  SelectFolder.swift
//  InternalStoragePhotos
//
//  Created by CubezyTech on 23/01/24.
//

import UIKit
import Photos
struct ImageFolder {
    var title: String
    var assets: [PHAsset]
}


class SelectFolder: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var imageFolders: [ImageFolder] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllAlbums()
               
               // Set the data source and delegate for the table view
               tableView.dataSource = self
               tableView.delegate = self    }


    
    @IBAction func backtap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return imageFolders.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectFolderViewCell
           
           cell.selectionStyle = .none
           let folder = imageFolders[indexPath.row]
           cell.titleLbl.text = folder.title
           cell.subTitleLbl.text = "Number of Images: \(folder.assets.count)"
           if let firstAsset = folder.assets.last {
                     loadThumbnail(for: firstAsset, into: cell.imgView)
                 }
           cell.imgView.layer.cornerRadius = 15

                 return cell
             }

             func loadThumbnail(for asset: PHAsset, into imageView: UIImageView) {
                 let requestOptions = PHImageRequestOptions()
                 requestOptions.isSynchronous = false
                 requestOptions.deliveryMode = .highQualityFormat

                 let imageManager = PHImageManager.default()
                 imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                     DispatchQueue.main.async {
                         imageView.image = image
                     }
                 }
             }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFolder = imageFolders[indexPath.row]
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "imageCount") as! ImageCount
        
        // Pass the selected folder to the next view controller
        secondViewController.selectedFolder = selectedFolder
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
      
    func getAllAlbums() {
        
        let fetchOptions = PHFetchOptions()

        // Fetch all user-created albums
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)

        // Fetch all smart albums
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: fetchOptions)

        // Merge user-created albums and smart albums
        let allAlbums = [userAlbums, smartAlbums]

        for albums in allAlbums {
            albums.enumerateObjects { (album, _, _) in
                // Fetch only images in the current album
                let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)

                // Filter out videos
                let imageAssets = assets.objects(at: IndexSet(0..<assets.count)).filter { $0.mediaType == .image }

                // Check if the album contains images
                if imageAssets.count > 0 { 
                    // Create an ImageFolder object and add it to the imageFolders array
                    let imageFolder = ImageFolder(title: album.localizedTitle ?? "Unknown", assets: Array(imageAssets))
                    self.imageFolders.append(imageFolder)
                }
            }
        }

        // Reload the table view data after fetching the albums
        tableView.reloadData()
    }



}
