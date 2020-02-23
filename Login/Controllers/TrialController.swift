//
//  TrialController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 20/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import Firebase

class TrialController: UIViewController {
    
        var audioPlayer:AVAudioPlayer?
    
    //Vars
    let db = Firestore.firestore()
    var count = 0
    var trials = [Trial]()
    var player: AVAudioPlayer!
    
    //Outlet
    @IBOutlet weak var writtenCue: UILabel!
    @IBOutlet weak var trialImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    //essintial function
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        if(count == 0){
            prevButton.isHidden = true
        }
        writtenCue.text = ""
//        getTrials()
        showCurrentTrial()
//        playSound("First")
    }
    
    func showCurrentTrial(){
       
        print(count)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    //Coneection function
    @IBAction func goTohome(_ sender: UIButton) {
    }
    
    @IBAction func SkipPressed(_ sender: UIButton) {
        if(sender.currentTitle! == "Next"){
            prevButton.isHidden = false
            count += 1
            showCurrentTrial()
            if (count == trials.count){
                nextButton.isHidden = true
            }
        }
        else{
            nextButton.isHidden = false
            count -= 1
            showCurrentTrial()
            if(count == 0){
                prevButton.isHidden = true
            }
        }
    }
    
    @IBAction func Record(_ sender: UIButton) {
        
        
        //when done
        if #available(iOS 13.0, *) {
            let playImage = UIImage(systemName:"play.fill")
            sender.setImage(playImage, for: [])
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func cuesPressed(_ sender: UIButton) {
    }
    
    //Utility functions
    func playSound( _ soundName:String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "m4a")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    func getTrials(){
        db.collection("trials").getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    var array = [Trial]()
                    for document in snapshot.documents {
                        let data = document.data()
                        print(data)
                        array.append(Trial(ID: data["ID"] as! String, answer: data["Answer"] as! String, image: data["Image"] as! String, exerciseType: data["ExerciseType"] as! String, category: data["Category"] as! String, trailClass: data["Class"] as! String, cues: data["Cues"] as! Array<String>))
                    }
                    self.trials = array
                }
            }
        }
    }
    
    
    func playSound(filename:String) {
           
           // Getting the url
           let url = Bundle.main.url(forResource: filename, withExtension: "mp3")
           
           // Make sure that we've got the url, otherwise abord
           guard url != nil else {
               return
           }
           
           // Create the audio player and play the sound
           do {
               audioPlayer = try AVAudioPlayer(contentsOf: url!)
               audioPlayer?.play()
           }
           catch {
               print("error")
           }
       }
    
}
