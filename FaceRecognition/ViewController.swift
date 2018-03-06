//
//  ViewController.swift
//  FaceRecognition
//
//  Created by Juliano Alvarenga on 2/19/18.
//  Copyright © 2018 Juliano Alvarenga. All rights reserved.
//

import UIKit
import Vision
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imgTaken: UIImage!
    @IBOutlet weak var picTaken: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func detect(img: UIImage) {
        
        guard let image = CIImage(image: img) else { return }

        var orientation:Int32 = 0
        
        switch img.imageOrientation {
        case .up:
            orientation = 1
            
        case .right:
            orientation = 6
            
        case .down:
            orientation = 3
            
        case .left:
            orientation = 8
            
        case .upMirrored:
            orientation = 2
            
        case .downMirrored:
            orientation = 4
            
        case .leftMirrored:
            orientation = 5
            
        case .rightMirrored:
            orientation = 7
            
        }
        
        let accurrency = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        
        let imgOptions = [
            
            CIDetectorSmile : true,
            CIDetectorEyeBlink : true,
            CIDetectorImageOrientation : orientation]
            
            as [String : Any]

        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accurrency)

        guard let faces = detector?.features(in: image, options: imgOptions) else { return }

        if !faces.isEmpty {
            
            for face in faces as! [CIFaceFeature] {
               
                switch face {
                    
                case _ where face.hasSmile:
                    alertInformation(title: "Atenção", message: "Tire a foto sem sorrir")
                
                case _ where face.leftEyeClosed:
                    alertInformation(title: "Atenção", message: "Mantenha os olhos abertos")
                
                case _ where face.rightEyeClosed:
                    alertInformation(title: "Atenção", message: "Mantenha os olhos abertos")
                
                default:
                    alertInformation(title: "Otimo", message: "Sua foto foi aprovada")
                    
                }
                
            }
            
        } else {
            
            alertInformation(title: "Atenção", message: "Posicione a camera pro seu rosto.")
            
        }


    }
    
    func detectFace(img: UIImage) {
        
        var orientation:Int32 = 0
        
        switch img.imageOrientation {
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
//        let faceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: handleFaceFeatures)
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: handleFaceFeatures)
        let requestHandler = VNImageRequestHandler(cgImage: img.cgImage!, orientation: CGImagePropertyOrientation(rawValue: UInt32(orientation))! ,options: [:])
        do {
//            try requestHandler.perform([faceRectanglesRequest])
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            print(error)
        }
       
    }
    
    func handleFaceFeatures(request: VNRequest, errror: Error?) {
        
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type!")
        }
     
        for face in observations {
           
            guard let leftEye = face.landmarks?.leftEye else { return }
            guard let rightEye = face.landmarks?.rightEye else { return }
            guard let nose = face.landmarks?.nose else { return }
            guard let smile = face.landmarks?.innerLips else { return }
           
            print(leftEye)
//            print(rightEye)
//            print(nose)
//            print(smile)
            
            
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
//            self.detectFace(img: self.imgTaken)
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
       
//        detectFace(img: imgTaken)
        detect(img: imgTaken)
        

    }
    
    
    @IBAction func takePic(_ sender: Any) {
        
        pickImage(.camera)
        
    }
}

