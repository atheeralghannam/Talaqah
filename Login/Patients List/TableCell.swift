//
//  TableCell.swift
//  Talaqah
//
//  Created by Atheer Alghannam on 07/07/1441 AH.
//  Copyright © 1441 Gary Tokman. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var idLabel: UILabel!
//    @IBOutlet private var thumbnailImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        idLabel.text = nil
//        thumbnailImageView.image = nil
    }

    // MARK: Cell Configuration

    func configurateTheCell(_ patient : Patient) {
        let name = patient.FirstName+" "+patient.LastName

        nameLabel.text = name
        idLabel.text = "رقم هوية/إقامة المريض: " + patient.NID
//        thumbnailImageView.image = UIImage(named: "disclousre.png")
    }

}
