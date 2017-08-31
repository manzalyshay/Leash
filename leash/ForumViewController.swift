//
//  ForumViewController.swift
//  leash
//
//  Created by admin on 04/08/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ForumViewController: UIViewController {

    
    @IBOutlet weak var forumview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoImage:UIImage = UIImage(named: "logo")!
        self.navigationItem.titleView = UIImageView(image: logoImage)
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.forumview.scrollView.contentInset = UIEdgeInsets.zero
        self.forumview.scalesPageToFit = true

        self.forumview.loadRequest(URLRequest(url: URL(string: "http://leash.byethost7.com")!))

    }
}
