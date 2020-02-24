//
//  Authorization.swift
//  Login
//
//  Created by Atheer Alghannam on 13/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//


import UIKit
import Speech

extension TrialController{
    
  func requestAuthorization(){
    SFSpeechRecognizer.requestAuthorization { authStatus in
        
        OperationQueue.main.addOperation {
            switch authStatus {
            case .authorized:
                self.recordButton.isEnabled = true
                
            case .denied:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                
            case .restricted:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                
            case .notDetermined:
                self.recordButton.isEnabled = false
                self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
            }
        }
    }
  }
    
}
