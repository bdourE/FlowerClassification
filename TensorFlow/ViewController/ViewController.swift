//
//  ViewController.swift
//  CatVsDogClassifierSample
//
//  Created by Prianka Kariat on 17/06/19.
//  Copyright © 2019 Y Media Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var PickButton : UIButton!
    @IBOutlet weak var imageBG : UIView!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var flowerLabel : UITextView!
    private var result: Result?

    // Handles all data preprocessing and makes calls to run inference through the `Interpreter`.
    private var modelDataHandler: ModelDataHandler? =
        ModelDataHandler(modelFileInfo: MobileNet.modelInfo, labelsFileInfo: MobileNet.labelsInfo)
    
    
      override func viewDidLoad() {
        
        guard modelDataHandler != nil else {
            fatalError("Model set up failed")
        }
        
        
    
        }
   
    @IBAction func PickImage(_ sender: UIButton) {
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            self.imageBG.isHidden = false
            self.imageView.isHidden = false
            self.flowerLabel.isHidden = false
            self.imageView.image = image
            
            // Gets the pixel buffer from UIImage
            guard  let image = self.imageView.image ,
                let pixelBuffer = image.pixelBuffer() else {
                    return
                    
            }
            /////
            // Pass the pixel buffer to TensorFlow Lite to perform inference.
            self.result = self.modelDataHandler?.runModel(onFrame: pixelBuffer)
            
            guard let finalInferences = self.result?.inferences else {
                self.flowerLabel.text = "غير معروف"
                
                return
                
            }
            
            let resultStrings = finalInferences.map({ (inf) in
                return String(format: "%@ %.2f",inf.label, (inf.confidence*100))
            })
            self.flowerLabel.text = resultStrings.joined(separator: " \n")
          
            

            
        }
    }
    
/*
  // MARK: Storyboards Connections
  @IBOutlet weak var collectionView: UICollectionView!
  // Holds the results at any time
    private var result: Result?
  // MARK: Instance Variables
  let imageNames: [String] = ["parsley_139.jpg", "parsley_140.jpg", "parsley_142.jpg", "cilantro_001.jpg", "cilantro_002.jpg", "cilantro_003.jpg"]
  var inferences: [String] = ["","","","","",""]
 
  
  // Handles all data preprocessing and makes calls to run inference through the `Interpreter`.
  private var modelDataHandler: ModelDataHandler? =
    ModelDataHandler(modelFileInfo: MobileNet.modelInfo, labelsFileInfo: MobileNet.labelsInfo)
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.reloadData()
    
    // Do any additional setup after loading the view, typically from a nib.

    guard modelDataHandler != nil else {
      fatalError("Model set up failed")
    }

  }

}

// MARK: Extensions
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return imageNames.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IMAGE_CELL", for: indexPath) as! ImageCell
    
    cell.imageView.image = UIImage(named: imageNames[indexPath.item])
    cell.inferenceLabel.text = inferences[indexPath.item]
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    // Gets the pixel buffer from UIImage
    guard  let image = UIImage(named: imageNames[indexPath.item]),
           let pixelBuffer = image.pixelBuffer() else {
            return

  }
    /////
    // Pass the pixel buffer to TensorFlow Lite to perform inference.
     result = modelDataHandler?.runModel(onFrame: pixelBuffer)
        
        guard let finalInferences = self.result?.inferences else {
            
            inferences[indexPath.item] = ""
            collectionView.reloadData()
            return
            
        }
        
    let resultStrings = finalInferences.map({ (inf) in
        return String(format: "%@ %.2f",inf.label, inf.confidence)
    })
    inferences[indexPath.item] = resultStrings.joined(separator: ",,,")
    collectionView.reloadData()
    


  }
  
*/
  
}

