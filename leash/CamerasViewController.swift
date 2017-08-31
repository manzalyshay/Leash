//
//  CamerasViewController.swift
//  leash
//
//  Created by admin on 04/08/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit


class CamerasViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let reuseIdentifier = "camera_cell"
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var camerasgrid: UICollectionView!
    var pickerData: [String] = [String]()
    var Cali = [String]()
    var Israel = [String]()
    var current = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoImage:UIImage = UIImage(named: "logo")!
        self.navigationItem.titleView = UIImageView(image: logoImage)
        navigationController?.navigationBar.barTintColor = UIColor.white

        self.pickerData = ["California" , "Israel"]
        self.picker.delegate = self
        self.picker.dataSource = self
        
        initCamerasGrid()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row == 0){
            current = Cali
        }
        else {
            current = Israel
        }
        
        self.camerasgrid.reloadData()
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.current.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CameraCell
        
//        let view = UIView(frame: cell.bounds)
        // Set background color that you want
//        view.backgroundColor = UIColor(red:0.85, green:0.90, blue:0.92, alpha:1.0)
//        cell.selectedBackgroundView = view
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
//        cell.webview.scrollView.contentInset = UIEdgeInsets.zero
//        cell.webview.sizeToFit()
        cell.webview.loadRequest(URLRequest(url: URL(string: current[indexPath.row])!))

        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    
    func initCamerasGrid(){
        self.Israel = ["http://ipcamlive.com/player/player.php?alias=freegullsouth", "http://216.172.164.89/","http://62.219.45.26:140/mjpg/video.mjpg","https://cdn.pbrd.co/images/QYAkuldPo.jpg"]
        
        self.Cali = ["https://www.youtube.com/embed/cKO3rRfeoqM", "https://www.youtube.com/embed/Jd6FYh6LMVc", "https://www.youtube.com/embed/AZvCP0njf_0", "https://cdn.pbrd.co/images/QYAkuldPo.jpg"]
        
        self.camerasgrid.dataSource=self
        self.camerasgrid.delegate=self
        
        let itemsize = UIScreen.main.bounds.width/2 - 20
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemsize, height: itemsize+30)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 8
        
        self.camerasgrid.collectionViewLayout = layout
        
        self.current = self.Cali
    }

    
}
