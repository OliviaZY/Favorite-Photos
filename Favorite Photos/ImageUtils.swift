//
//  ImageUtils.swift
//  Favorite Photos
//
//  Created by Yuan zhou on 5/1/18.
//  Copyright © 2018 Yuan zhou. All rights reserved.
//

import UIKit
import Kingfisher

class ImageUtils: NSObject {
    static func load(imageView: UIImageView, from url: String){
        if let imgUrl = URL(string:url){
            
            imageView.kf.setImage(with:imgUrl)
            
//            DispatchQueue.global().async {
//                do{
//                let data = try Data(contentsOf: imgUrl)
//                DispatchQueue.main.async {
//                    imageView.image = UIImage(data:data)
//                }
//            }catch {
//                print("error downloading image")
//            }
//
//        }
    }
    }
}
