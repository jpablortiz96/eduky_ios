//
//  ViewControllerPdf.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 20/07/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit
import WebKit

class ViewControllerPdf: UIViewController, WKUIDelegate {
    
    var urlWeb: String = ""

    @IBOutlet weak var webViewPdf: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:urlWeb)
        let myRequest = URLRequest(url: myURL!)
        webViewPdf.loadRequest(myRequest)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
