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
    
    @IBOutlet var trialResult: UIButton!
    
    
    @IBOutlet var validateButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    
    
    var audioPlayerFirst:AVAudioPlayer?
    
    //Vars
    let db = Firestore.firestore()
    var count = 0
    var trials = [Trial]()
    var countCoResult = 0
    var countFaResult = 0
    var pressed = false
    
    //Outlet
    @IBOutlet weak var writtenCue: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    
    let storageRef = Storage.storage().reference()
    
    //play storage audio
    var playerAt = AVPlayer()
    
    //essintial function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome"{
            let destnationVC = segue.destination as! BaseViewController
            destnationVC.modalPresentationStyle = .fullScreen
        }
        else if segue.identifier == "help"{
            let destnationVC = segue.destination as! HelpViewController
                       destnationVC.modalPresentationStyle = .fullScreen
        }
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
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
        if(count == 0){
            prevButton.isHidden = true
        }
        if trials.count == 1 {
            nextButton.isHidden = true
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
    
    @IBAction func viewResult(_ sender: UIButton) {
        
        print(pressed)
        print (countCoResult)
        print(countFaResult)
        
        func goToHomePage(alert: UIAlertAction){
            print("go to home page")
            
            
            let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let homeView  = sampleStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! BaseViewController
            self.present(homeView, animated: true, completion: nil)
            
            
        }
        
        // create the alert
        var result = String()
        result = "عدد الإجابات الصحيحة  " + String(countCoResult) + "\n" + "عدد الإجابات الخاطئة  " + String(countFaResult)
        
        let alert = UIAlertController(title: "النتيجة", message: result, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        
        alert.addAction(UIAlertAction(title: "رجوع", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "إنهاء التمرين", style: UIAlertAction.Style.default, handler: goToHomePage))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
        
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
            
            if #available(iOS 13.0, *) {
                let validateImage = UIImage(systemName:"exclamationmark")
                validateButton.setImage(validateImage, for: [])
                
            } else {
                // Fallback on earlier versions
            }
            
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
            if #available(iOS 13.0, *) {
                let validateImage = UIImage(systemName:"xmark")
                validateButton.setImage(validateImage, for: [])
                
            } else {
                // Fallback on earlier versions
            }
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
            validateButton.isHidden=false
            
            
            
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
    
    
    @objc func showCurrentTrial(){
        //image
        print(trials, count)
        writtenCue.text = ""
        let url = "images/"+trials[count].name+".jpg"
        let reference = storageRef.child(url)
        
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
        
        
        //answer
        //here put the trial answer instead of Atheer
        UserDefaults.standard.set(trials[count].answer, forKey: Constants.correcAnswer)
        print(count)
    }
    
    
    
    //Conection function
    @IBAction func goTohome(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHome", sender: self)
    }
    
    @IBAction func helpPage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "help", sender: self)
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
        if sender.currentTitle == "المعنى" {
            // let url = "audios/"+trials[count].audiosNames[0]+"mp3"
            let audPath = "audios/"+trials[count].audiosNames[0]+".mp3"
            let starsRef = storageRef.child(audPath)
            starsRef.downloadURL { url, error in
                if error != nil {
                    // Handle any errors
                    print("error")
                } else {
                    // Get the download URL for 'images/stars.jpg'
                    let playerItem = AVPlayerItem(url: URL(string: url!.absoluteString)!)
                    self.playerAt = AVPlayer(playerItem: playerItem)
                    self.playerAt.play()
                }
                
            }
        } else if sender.currentTitle == "جملة"{
            let text = trials[count].writtenCues[0]
            writtenCue.text = text
        } else if sender.currentTitle == "الصوت الأول" {
            let audPath = "audios/"+trials[count].audiosNames[1]+".mp3"
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
        } else if sender.currentTitle == "المقطع الأول"{
            let audPath = "audios/"+trials[count].audiosNames[2]+".mp3"
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
            
        } else if sender.currentTitle == "الحرف الأول"{
            let text = trials[count].writtenCues[1]
            writtenCue.text = text
        } else if sender.currentTitle == "الكلمة مكتوبة" {
            let text = trials[count].answer
            writtenCue.text = text
        } else if sender.currentTitle == "الكلمة منطوقة"{
            let audPath = "audios/"+trials[count].audiosNames[3]+".mp3"
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
        }
        
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
