//
//  WebViewController.swift
//  QiitaLikePicker
//
//  Created by 山本竜也 on 2019/2/1.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var browserWebView: UIWebView!
    
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.browserWebView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if return value is nil, we must write super method
        super.viewDidAppear(animated)
        
        //let urlString = "http://dotinstall.com"
        
        //urlString of urlString type is passed
        self.loadUrl(urlString: urlString)
    }
    
    func loadUrl(urlString: String) {
        if let  url = self.getValidatedUrl(urlString:urlString){
            let urlRequest = URLRequest(url: url)
            self.browserWebView.loadRequest(urlRequest)
        }
    }
    
    //nil check
    func getValidatedUrl(urlString: String) -> URL? {
        
        // this method kill space
        let trimmed = urlString.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if URL(string: trimmed) == nil {
            //            print("Invalid URL")
            self.showAlert("Invalid URL")
            return nil
        }
        return URL(string: self.appendScheme(trimmed))
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func appendScheme(_ urlString: String) -> String {
        if URL(string: urlString)?.scheme == nil {
            return "http://" + urlString
        }
        return urlString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
