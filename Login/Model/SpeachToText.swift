//
//  SpeachToText.swift
//  Login
//
//  Created by Atheer Alghannam on 13/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit
import Speech

extension TrialController{
    
    func startRecordingFirst() throws {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .measurement, options: .interruptSpokenAudioAndMixWithOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            if(result?.bestTranscription.formattedString != nil){
                DispatchQueue.main.async {
                    
                    //todo textView speech
//                    self.textView.text =  (result?.bestTranscription.formattedString)!
                    
                }
                
            }
            
            if(result?.isFinal != nil)
            {  isFinal = (result?.isFinal)!}
            
            if isFinal || error != nil {
                let command = result?.bestTranscription.formattedString
                
                //here

                if command==nil{
                    UserDefaults.standard.set(nil, forKey: Constants.currentAnswer)
                    return}
                
                if command != nil {
                    
                      let w1 = UserDefaults.standard.string(forKey: Constants.correcAnswer)
                    
                      let w2 = command
                      
                             UserDefaults.standard.set(command, forKey: Constants.currentAnswer)
                    
                      print(w1)
                    print(w1?.count)
                    for char in w1! {
                                          print("Found character: \(char)")
                                      }

                      print(w2)
                    print(w2?.count)
                    for char in w2! {
                                          print("Found character: \(char)")
                                      }

                      let substring = w2?.dropFirst(1)
                    

                    let realword = String(substring!)
                    print(realword.count)

                    for char in realword {
                        print("Found character: \(char)")
                    }
                      print(w1==realword)
                    if (w1==realword){
                        self.pressed = true
                        print(self.pressed)
                    }
                    
                    if (self.pressed && true){
                        self.countCoResult = self.countCoResult + 1
                        self.pressed = false
                    } else {
                        
                        self.countFaResult = self.countFaResult + 1
                        self.pressed = false
                        
                    }
                    
                    
                    
                    UserDefaults.standard.set(w1==realword, forKey:Constants.isAnswerCorrect)

                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    
                    self.audioEngine.stop()
                    
                    self.recognitionRequest?.endAudio()
                    
                }
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
            
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
            recordButton.setTitle("", for: [])
//            recordButton.setTitle("Start Recording", for: [])

        } else {
            recordButton.isEnabled = false
            recordButton.setTitle("Recognition not available", for: .disabled)
        }
    }
    
}
