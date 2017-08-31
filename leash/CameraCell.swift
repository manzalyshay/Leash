//
//  CameraCell.swift
//  Leash
//
//  Created by admin on 04/08/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell {
    
    @IBOutlet weak var webview: UIWebView!
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit

        webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
        
    }
    
}
