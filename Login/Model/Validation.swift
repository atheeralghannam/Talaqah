//
//  Validation.swift
//  Login
//  Created by Atheer Alghannam on 11/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import Foundation

class Validation {




    public func validateName(name: String) ->Bool {
        // Length be 18 characters max and 3 characters minimum, you can always modify.
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    public func validaPhoneNumber(phoneNumber: String) -> Bool {
        let phoneNumberRegex = "d{10}$"
        let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
        let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = validatePhone.evaluate(with: trimmedString)
        return isValidPhone
    }
    public func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    public func validatePassword(password: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        //     "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    public func validateAnyOtherTextField(otherField: String) -> Bool {
        let otherRegexString = "Your regex String"
        let trimmedString = otherField.trimmingCharacters(in: .whitespaces)
        let validateOtherString = NSPredicate(format: "SELF MATCHES %@", otherRegexString)
        let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
        return isValidateOtherString
    }
    public func isValidateId(id: String)-> Bool{
        do {
            let resutl = try ValidateSAID.check(id)
            
            // this will print NationaltyType description
            print(resutl)
        } catch {
            // this will print error description
            return false
            //                                            print(error)
            //                                    self.showToast(message: "رقم الهوية/الإقامة غير صالح", font: UIFont(name: "Times New Roman", size: 12.0)!)
            //                                                  idTextField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
        }
        return true
    }
    
 public func isValidPhoneNumber(phoneNumber: String) -> Bool {
//         let phoneNumberRegex = "^[05]\\d{8}$"
//               let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
//               let isValidPhone = phoneTest.evaluate(with: self)
//               return isValidPhone
    if phoneNumber.prefix(2)=="05" && phoneNumber.count == 10
    {
        return true
    }else {
        return false
    }
    
    }

}
