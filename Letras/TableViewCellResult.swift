// Package: Letras,
// File name: TableViewCellResultTableViewCell.swift,
// Created by David Herrero on 26/11/2019.

import UIKit

class TableViewCellResult: UITableViewCell {
    
    
    @IBOutlet weak var wordOKLabel: UILabel!
    @IBOutlet weak var wordScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
