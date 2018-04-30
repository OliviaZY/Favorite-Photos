//
//  FavoritePhotoViewController.swift
//  Favorite Photos
//
//  Created by Yuan zhou on 4/30/18.
//  Copyright © 2018 Yuan zhou. All rights reserved.
//

import UIKit

class FavoritePhotoViewController: UIViewController {

    @IBOutlet weak var iamgeview: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.sourceType = .camera
        }else{
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated:true)
    }
}

// mark: UIImagepicker controller delegate methods
extension FavoritePhotoViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //            TODO: upload the data to storage, display after the storaeg save is done
            self.iamgeview.image = image
        }
        picker.dismiss(animated: true)
    }
}










