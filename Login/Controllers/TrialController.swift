//
//  TrialController.swift
//  Talaqah
//
//  Created by Muhailah AlSahali on 20/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import Speech
import AVFoundation
import AVKit

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

class TrialController: UIViewController,SFSpeechRecognizerDelegate {
    
    //speech vaars
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Language.instance.setlanguage()))!
       
       var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
       
       var recognitionTask: SFSpeechRecognitionTask?
       
       let audioEngine = AVAudioEngine()
       @IBOutlet weak var recordButton: UIButton!
    
//       @IBOutlet weak var textView: UITextView!
       
       
       @IBOutlet var playButton: UIButton!
       
       var recordingSession: AVAudioSession!
       var audioRecorder: AVAudioRecorder!
       var audioPlayer: AVAudioPlayer!
    
    
    
    
    var audioPlayerFirst:AVAudioPlayer?
    
    //Vars
    let db = Firestore.firestore()
    var count = 0
    var trials = [Trial]()

    
    //Outlet
    @IBOutlet weak var writtenCue: UILabel!
    //    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    let storageRef = Storage.storage().reference()

    //play storage audio
    var playerAt = AVPlayer()
    
    //essintial function
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
           recordingSession = AVAudioSession.sharedInstance()
           
           do {
        //       try recordingSession.setCategory(.playAndRecord, mode: .default)
               try recordingSession.setActive(true)
               recordingSession.requestRecordPermission { [unowned self] allowed in
                   DispatchQueue.main.async {
                       if allowed {
                           self.loadRecordingUI()
                       } else {
                           // failed to record
                       }
                   }
               }
           } catch {
               // failed to record!
           }
        
        
        //here put the trial answer instead of Atheer
         UserDefaults.standard.set("أثير", forKey: Constants.correcAnswer)
        
        if(count == 0){
            prevButton.isHidden = true
        }
        writtenCue.text = ""
//        getTrials()
        showCurrentTrial()
//     playSound(filename: "canYouNaming")
    }
    
    
    
    func loadRecordingUI() {
        playButton.isHidden = true
        recordButton.isHidden = false
//        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.setTitle("", for: .normal)

    }
    
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
            
            //when done
            playButton.isHidden = true

            if #available(iOS 13.0, *) {
                let playImage = UIImage(systemName:"stop.fill")
                sender.setImage(playImage, for: [])
                
            } else {
                // Fallback on earlier versions
            }

        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if audioPlayer == nil {
            startPlayback()
        } else {
            finishPlayback()
        }
    }
    
        // MARK: - Recording
        func startRecording() {
            
        

            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
    //        let settings = [
    //            AVFormatIDKey: Int(kAudioFormatAppleLossless),
    //            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
    //            AVEncoderBitRateKey: 320000,
    //            AVNumberOfChannelsKey: 2,
    //            AVSampleRateKey: 44100.0 ] as [String : Any]

              let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
    //
    //        let settings = [
    //                           AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
    //                           AVSampleRateKey: 44100,
    //                           AVNumberOfChannelsKey: 2,
    //                           AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
    //                       ]
            
            do {
                try recordingSession.setCategory(.record, mode: .default)
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                
                     if  audioEngine.isRunning {

                         recognitionRequest?.shouldReportPartialResults = false
                         audioEngine.inputNode.removeTap(onBus: 0)
                         audioEngine.stop()
                         recognitionRequest?.endAudio()


                         recordButton.isEnabled = true
//                         recordButton.setTitle("Start Recording", for: [])
                        recordButton.setTitle("", for: [])


                     } else {

                         try! startRecordingFirst()

//                         recordButton.setTitle("Pause recording", for: [])
                        recordButton.setTitle("", for: [])

                     }
                
                
                audioRecorder.record()
                
//                recordButton.setTitle("Tap to Stop", for: .normal)
                recordButton.setTitle("", for: .normal)

            } catch {
                finishRecording(success: false)
            }
        }
        
        func finishRecording(success: Bool) {
            
            //when done
            if #available(iOS 13.0, *) {
                let playImage = UIImage(systemName:"mic.fill")
                recordButton.setImage(playImage, for: [])
            } else {
                // Fallback on earlier versions
            }
            playButton.isHidden = false

            
            audioEngine.stop()

            recognitionRequest?.endAudio()
            
            audioRecorder.stop()
            audioRecorder = nil
            
            if success {
//                recordButton.setTitle("Tap to Re-record", for: .normal)
                recordButton.setTitle("", for: .normal)
//                playButton.setTitle("Play Your Recording", for: .normal)
                playButton.setTitle("", for: .normal)

                playButton.isHidden = false
        
            } else {
                recordButton.setTitle("Tap to Record", for: .normal)
                playButton.isHidden = true
                // recording failed :(
            }
        }
        
        
        // MARK: - Playback
        
        func startPlayback() {
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            do {
                try recordingSession.setCategory(.playback, mode: .default)
                audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
                audioPlayer.delegate = self
                audioPlayer.play()
//                playButton.setTitle("Stop Playback", for: .normal)
                playButton.setTitle("", for: .normal)
            } catch {
                playButton.isHidden = true
                // unable to play recording!
            }
        }
        
        func finishPlayback() {
            audioPlayer = nil
//            playButton.setTitle("Play Your Recording", for: .normal)
            playButton.setTitle("", for: .normal)

            
        }


        override func viewDidAppear(_ animated: Bool) {
            
            speechRecognizer.delegate = self
            requestAuthorization()
        
            
        }
    

    func showCurrentTrial(){
        
        
            //image
             let reference = storageRef.child("images/cat.jpg")
        
               // UIImageView in your ViewController
               let imageView: UIImageView = self.imageView
        
               // Placeholder image
               let placeholderImage = UIImage(named: "placeholder.jpg")
        
               // Load the image using SDWebImage
               imageView.sd_setImage(with: reference, placeholderImage: placeholderImage) { (image, error, cache, url) in
                self.playSound(filename: "canYouNaming")
               }
        
//        .sd_setImage(with: reference, placeholderImage: placeholderImage,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
         // Perform operation.
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
                self.playerAt = AVPlayer(playerItem: playerItem)
                self.playerAt.play()
            }
            
        }
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
        
        
//        //when done
//        if #available(iOS 13.0, *) {
//            let playImage = UIImage(systemName:"stop.fill")
//            sender.setImage(playImage, for: [])
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    @IBAction func cuesPressed(_ sender: UIButton) {
    }
    
    //Utility functions
//    func playSound(){
//        let url = Bundle.main.path(forResource: "canYouNaming", ofType: "mp4")
//        do{
//            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))}
//        catch{
//            print(error)
//        }
//        player.play()
//    }
    
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
            audioPlayerFirst = try AVAudioPlayer(contentsOf: url!)
            audioPlayerFirst?.play()
        }
        catch {
            print("error")
        }
    }
    
}
extension TrialController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}

extension TrialController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayback()
    }
    
}
