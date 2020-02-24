////
////  SpeechController.swift
////  Login
////
////  Created by Atheer Alghannam on 13/06/1441 AH.
////  Copyright © 1441 Gary Tokman. All rights reserved.
////
//
//import UIKit
//import Speech
//import AVFoundation
//
////func getDocumentsDirectory() -> URL {
////    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
////    return paths[0]
////}
//
//
//class SpeechController: UIViewController,SFSpeechRecognizerDelegate {
//
//    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Language.instance.setlanguage()))!
//    
//    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    
//    var recognitionTask: SFSpeechRecognitionTask?
//    
//    let audioEngine = AVAudioEngine()
//    
//    @IBOutlet weak var recordButton: UIButton!
// 
//    @IBOutlet weak var textView: UITextView!
//    
//    
//    @IBOutlet var playButton: UIButton!
//    
//    var recordingSession: AVAudioSession!
//    var audioRecorder: AVAudioRecorder!
//    var audioPlayer: AVAudioPlayer!
//   
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//   
//   recordingSession = AVAudioSession.sharedInstance()
//   
//   do {
////       try recordingSession.setCategory(.playAndRecord, mode: .default)
//       try recordingSession.setActive(true)
//       recordingSession.requestRecordPermission { [unowned self] allowed in
//           DispatchQueue.main.async {
//               if allowed {
//                   self.loadRecordingUI()
//               } else {
//                   // failed to record
//               }
//           }
//       }
//   } catch {
//       // failed to record!
//   }
//    }
//    
//    func loadRecordingUI() {
//        playButton.isHidden = true
//        recordButton.isHidden = false
//        recordButton.setTitle("Tap to Record", for: .normal)
//    }
//    
//    
//    @IBAction func recordButtonPressed(_ sender: UIButton) {
//        if audioRecorder == nil {
//            startRecording()
//        } else {
//            finishRecording(success: true)
//        }
//    }
//    
//    @IBAction func playButtonPressed(_ sender: UIButton) {
//        if audioPlayer == nil {
//            startPlayback()
//        } else {
//            finishPlayback()
//        }
//    }
//    
//    
//    // MARK: - Recording
//    func startRecording() {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//        
////        let settings = [
////            AVFormatIDKey: Int(kAudioFormatAppleLossless),
////            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
////            AVEncoderBitRateKey: 320000,
////            AVNumberOfChannelsKey: 2,
////            AVSampleRateKey: 44100.0 ] as [String : Any]
//
//          let settings = [
//                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                AVSampleRateKey: 12000,
//                AVNumberOfChannelsKey: 1,
//                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//            ]
////
////        let settings = [
////                           AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
////                           AVSampleRateKey: 44100,
////                           AVNumberOfChannelsKey: 2,
////                           AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
////                       ]
//        
//        do {
//            try recordingSession.setCategory(.record, mode: .default)
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder.delegate = self
//            
//                 if  audioEngine.isRunning {
//
//                     recognitionRequest?.shouldReportPartialResults = false
//                     audioEngine.inputNode.removeTap(onBus: 0)
//                     audioEngine.stop()
//                     recognitionRequest?.endAudio()
//
//
//                     recordButton.isEnabled = true
//                     recordButton.setTitle("Start Recording", for: [])
//
//                 } else {
//
//                     try! startRecordingFirst()
//
//                     recordButton.setTitle("Pause recording", for: [])
//                 }
//            
//            
//            audioRecorder.record()
//            
//            recordButton.setTitle("Tap to Stop", for: .normal)
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//    
//    func finishRecording(success: Bool) {
//        
//        audioEngine.stop()
//
//        recognitionRequest?.endAudio()
//        
//        audioRecorder.stop()
//        audioRecorder = nil
//        
//        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//            playButton.setTitle("Play Your Recording", for: .normal)
//            playButton.isHidden = false
//    
//        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
//            playButton.isHidden = true
//            // recording failed :(
//        }
//    }
//    
//    
//    // MARK: - Playback
//    
//    func startPlayback() {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//        do {
//            try recordingSession.setCategory(.playback, mode: .default)
//            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
//            audioPlayer.delegate = self
//            audioPlayer.play()
//            playButton.setTitle("Stop Playback", for: .normal)
//        } catch {
//            playButton.isHidden = true
//            // unable to play recording!
//        }
//    }
//    
//    func finishPlayback() {
//        audioPlayer = nil
//        playButton.setTitle("Play Your Recording", for: .normal)
//        
//    }
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        
//        speechRecognizer.delegate = self
//        requestAuthorization()
//    
//        
//    }
//    
//    
//}
//
//extension SpeechController: AVAudioRecorderDelegate {
//    
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if !flag {
//            finishRecording(success: false)
//        }
//    }
//    
//}
//
//extension SpeechController: AVAudioPlayerDelegate {
//    
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        finishPlayback()
//    }
//    
//}
