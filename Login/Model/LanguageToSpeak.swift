//
//  LanguageToSpeak.swift
//  Login
//
//  Created by Atheer Alghannam on 13/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit

class Language{
    
    public static let instance = Language()
    
//    var langCode = NSLocale.preferredLanguages[0]
    var langCode = "ar-sa"

    var regionCode = Locale.current.regionCode!
  
    
    func getlangCode()->String{
        return self.langCode
    }
    
    func getregionCode()->String{
        return self.regionCode
    }
    
    func setlanguage() -> String{
    
        return  self.langCode
    }
    
    func selectedlanguage(language: String){
        langCode =  language
    }
    
}

