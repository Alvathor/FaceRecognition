//
//  ViewController.swift
//  FaceRecognition
//
//  Created by Juliano Alvarenga on 2/19/18.
//  Copyright © 2018 Juliano Alvarenga. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imgTaken: UIImage!
    @IBOutlet weak var picTaken: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func detectFace(img: UIImage) {
        
        var orientation:Int32 = 0
        
        switch imgTaken.imageOrientation {
        case .up:
            orientation = 1
        case .right:
            orientation = 6
        case .down:
            orientation = 3
        case .left:
            orientation = 8
        default:
            orientation = 1
        }
        
        // vision
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: handleFaceFeatures)
        let requestHandler = VNImageRequestHandler(cgImage: img.cgImage!, orientation: CGImagePropertyOrientation(rawValue: UInt32(orientation))! ,options: [:])
        do {
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            print(error)
        }
       
    }
    
    func handleFaceFeatures(request: VNRequest, errror: Error?) {
        
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type!")
        }
        
        if observations == [] {
            alertInformation(title: "Atencao", message: "Posicione a camera em seu rosto")
        } else {
            alertInformation(title: "Muito bom", message: "Rosto encontrado")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let img = info [UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        picTaken.image = img
        imgTaken = img
        
        dismiss(animated: true) {
            self.detectFace(img: self.imgTaken)
        }
        
    }

 
    func pickImage(_ sourceType: UIImagePickerControllerSourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        pickerController.cameraDevice = .front
        
        present(pickerController, animated: true, completion: nil)
        
    }

    
    func alertInformation(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func detectFace(_ sender: Any) {
       
        detectFace(img: imgTaken)
        

    }
    
    
    @IBAction func takePic(_ sender: Any) {
        
        pickImage(.camera)
        
    }
}

