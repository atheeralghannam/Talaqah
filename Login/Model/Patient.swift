//
//  Patient.swift
//  Login
//
//  Created by Haneen Abdullah on 09/02/2020.
//  Copyright © 2020 Gary Tokman. All rights reserved.
//

import Foundation
struct Patient {
    var nID:String
    var firstName:String
    var lastName:String
    var gender:String
    var phoneNumber:String
    var email:String
    
    func printName() {
        print("\(self.firstName) \(self.lastName)")
    }
    
}
