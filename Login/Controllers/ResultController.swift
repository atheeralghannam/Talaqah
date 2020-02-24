//
//  ResultController.swift
//  Talaqah
//
//  Created by Horiah on 30/06/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import UIKit

class ResultController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
