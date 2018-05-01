//
//  FavoritePhotoViewController.swift
//  Favorite Photos
//
//  Created by Yuan zhou on 4/30/18.
//  Copyright © 2018 Yuan zhou. All rights reserved.
//

import UIKit
import Firebase

class FavoritePhotoViewController: UIViewController {

    @IBOutlet weak var iamgeview: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    var storageRef:StorageReference!
    var photoDocRef: DocumentReference!
    var photoListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference(withPath:"favorite")
        photoDocRef = Firestore.firestore().collection("favorite").document("photo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoListener = photoDocRef.addSnapshotListener({(snapshot, error) in
            if let error = error{
                print("error getting the firestore document \(error.localizedDescription)")
            }
            if let url = snapshot?.get("url") as? String {
                print("loading image from url")
                //  TODO: mae a helper class that everyone can use
                
                ImageUtils.load(imageView: self.iamgeview, from: url)
            }
        })
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.sourceType = .camera
        }else{
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated:true)
    }
    
    func uploadImage(_data:Data?){
        guard let data = _data else {return}
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        progressView.isHidden = false
        progressView.progress = 0
        
        let uploadTask = storageRef.putData(data, metadata: uploadMetadata){(metaData, error) in
            if let error = error{
                print("error with upload \(error.localizedDescription)")
            }
        }
//        uploadTask
        uploadTask.observe(StorageTaskStatus.progress){ (StorageTaskSnapshot) in
            guard let progress = StorageTaskSnapshot.progress else {return}
            self.progressView.progress = Float(progress.fractionCompleted)
        }
        uploadTask.observe(StorageTaskStatus.success){(StorageTaskSnapshot) in
            print("your upload is finished")
            self.progressView.isHidden = true

            self.storageRef.downloadURL(completion: {(url,error) in
                if let error = error{
                    print("errpr getting the download url.\(error.localizedDescription)")
                }
                if let url = url {
                    print("saving the url \(url.absoluteString)")
                    self.photoDocRef.setData(["url": url.absoluteString])
                }
            })
        }
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
//            self.iamgeview.image = image
            
            uploadImage(_data: UIImageJPEGRepresentation(image,0.5))
        }
        picker.dismiss(animated: true)
    }
}










