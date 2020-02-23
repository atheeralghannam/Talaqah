//
//  TestTrialViewController.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 26/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//
// Test the first repository
import UIKit
import Firebase
import FirebaseUI
import AVFoundation
import AVKit



class TestTrialViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var ref = Database.database().reference()
    
    
    let pathReference = Storage.storage().reference(withPath: "images/stars.jpg")



    // Create a storage reference from our storage service
    let storageRef = Storage.storage().reference()
    var audioPlayer: AVAudioPlayer!
    var player = AVPlayer()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("أثير", forKey: Constants.correcAnswer)

        
        
       //nouns
        self.ref.child("trials").child("noun").child("animals").child("dog").setValue(["answer": "كلب"])

        
        
        //verb
        self.ref.child("trials").child("verb").child("male").child("sleep").setValue(["answer": "ينام"])
        
        
        //adj
        
        self.ref.child("trials").child("adj").child("fat").setValue(["answer": "سمين"])
        
        
        // Do any additional setup after loading the view.
        // Reference to an image file in Firebase Storage
        
        
        //image
        
        let reference = storageRef.child("images/cat.jpg")

        // UIImageView in your ViewController
        let imageView: UIImageView = self.imageView

        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.jpg")

        // Load the image using SDWebImage
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        //audio
        
        let audPath="audios/112.mp3"
//        playAudio(audioPath: audPath)
        let starsRef = storageRef.child(audPath)
            starsRef.downloadURL { url, error in
                        if error != nil {
                        // Handle any errors
                      } else {
                        // Get the download URL for 'images/stars.jpg'
                            let playerItem = AVPlayerItem(url: URL(string: url!.absoluteString)!)
                            self.player = AVPlayer(playerItem: playerItem)
                            self.player.play()
                }

            }
        

            
        }
//    func playAudio(audioPath: String){
//    let starsRef = storageRef.child(audioPath)
//        starsRef.downloadURL { url, error in
//                    if error != nil {
//                    // Handle any errors
//                  } else {
//                    // Get the download URL for 'images/stars.jpg'
//                        let playerItem = AVPlayerItem(url: URL(string: url!.absoluteString)!)
//                        self.player = AVPlayer(playerItem: playerItem)
//                        self.player.play()
//            }
//
//        }
//    }


}
        

