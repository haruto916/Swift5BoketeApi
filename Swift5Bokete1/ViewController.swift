//
//  ViewController.swift
//  Swift5Bokete1
//
//  Created by 福井悠都 on 2020/06/29.
//  Copyright © 2020 福井悠都. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {
    
    
    @IBOutlet weak var odaiImageView: UIImageView!
    
    @IBOutlet weak var commentTextView:
    UITextView!
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var count = 0
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.layer.cornerRadius = 20.0
        
        PHPhotoLibrary.requestAuthorization{
            
            (status) in
            switch(status){
            case.authorized: break
            case.denied: break
            case.notDetermined: break
            case.restricted: break
            }
            
        }
        
        getImages(keyword: "funny")
    }
    
    //検索キーワードの値を元に画像を引っ張ってくる
    //pixabay.com
    
    func getImages(keyword:String){
        
        //APIKEY  17275523-c3f1d4d436294e83aee6eee16
        let url = "https://pixabay.com/api/?key=17275523-c3f1d4d436294e83aee6eee16&q=\(keyword)"
        
        //Alamofireを使ってhttpリクエストを投げます
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result{
                
            case .success :
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                if imageString == nil{
                    
                    imageString = json["hits"][0]["webformatURL"].string
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                    
                    
                    
                }else{
                    
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }
                self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                
            case .failure(let error):
                
                print(error)
               
            }
        }
        
        
        
    }
    
    
    
    @IBAction func nextOdai(_ sender: Any) {
        
        
        count = count + 1
        
        if searchTextField.text == ""{
            
            getImages(keyword: "funny")
            
        }else{
            
            getImages(keyword: searchTextField.text!)
        }
        
    }
    
    
    
    @IBAction func searchAction(_ sender: Any) {
        
        self.count = 0
        if searchTextField.text == ""{
            
            getImages(keyword: "funny")
            
        }else{
            
            getImages(keyword: searchTextField.text!)
        }
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shareVC = segue.destination as? ShareViewController
        shareVC?.commentString = commentTextView.text
        shareVC?.resultImage = odaiImageView.image!
    }
    
    
    


}

