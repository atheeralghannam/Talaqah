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
    
    
    
    @IBOutlet var playButton: UIButton!
    
    @IBOutlet var finishTrial: UIButton!
    @IBOutlet var validateButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    
    
    var audioPlayerFirst:AVAudioPlayer?
    
    //Vars
    let db = Firestore.firestore()
    var count = 0
    var trials = [Trial]()
    var categories = [String]()
    var document = "names"
    
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
        
        let docRef = db.collection("trials").document(document)
            for category in categories {
                let doc = docRef.collection(category)
                doc.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            self.trials.append(Trial(answer: data["answer"] as! String , name: data["name"] as! String
                                , writtenCues: data["writtenCues"] as! Array<String>, audiosNames: data["audiosNames"] as!
                                    Array<String>, settings: data["settings"] as! Array<String>))
                            print("\(document.documentID) => \(document.data())")
                        }
                        
                        }
                    }
                }        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
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
        UserDefaults.standard.set("فرشة", forKey: Constants.correcAnswer)
        
        if(count == 0){
            prevButton.isHidden = true
        }
        writtenCue.text = ""
        showCurrentTrial()
    }
    
    
    
    func loadRecordingUI() {
        playButton.isHidden = true
        validateButton.isHidden=true
        recordButton.isHidden = false
        recordButton.setTitle("", for: .normal)
    }
    
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
            
            //when done
            playButton.isHidden = true
            validateButton.isHidden=true
            
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
    
    
    @IBAction func validateButtonPressed(_ sender: UIButton) {
        
        //maybe move comparing code here
        
        //if nill ..... no answer
        if UserDefaults.standard.string(forKey: Constants.currentAnswer) == nil{
            
            // create the alert
            let alert = UIAlertController(title: "لا توجد إجابة", message: "حاول مجددًا", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
            
            
            
            
            return;
        }
        
        
        
        if (UserDefaults.standard.bool(forKey: Constants.isAnswerCorrect) == true){
            
            // create the alert
            let alert = UIAlertController(title: "إجابة صحيحة", message: "أحسنت!", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
            
            
        else{
            
            // create the alert
            let alert = UIAlertController(title: "إجابة خاطئة", message: "حظ أوفر", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "حسنًا", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    // MARK: - Recording
    func startRecording() {
        
        
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
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
                
                recordButton.setTitle("", for: [])
                
                
            } else {
                
                try! startRecordingFirst()
                
                recordButton.setTitle("", for: [])
                
            }
            
            
            audioRecorder.record()
            
          
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
        validateButton.isHidden=false
        
        
        
        audioEngine.stop()
        
        recognitionRequest?.endAudio()
        
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("", for: .normal)
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
            playButton.setTitle("", for: .normal)
        } catch {
            playButton.isHidden = true
            // unable to play recording!
        }
    }
    
    func finishPlayback() {
        audioPlayer = nil
        playButton.setTitle("", for: .normal)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        requestAuthorization()
    }
    
    
    func showCurrentTrial(){
        //image
        let reference = storageRef.child("images/brush.jpg")
        
        // UIImageView in your ViewController
        let imageView: UIImageView = self.imageView
        
        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.jpg")
        
        // Load the image using SDWebImage
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage) { (image, error, cache, url) in
            self.playSound(filename: "canYouNaming")
        }
        
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
    
    @IBAction func cuesPressed(_ sender: UIButton) {
        print("hello", trials)

    }
    
    //Utility functions
    
    
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
