//
//  TableViewCell.swift
//  clap
//
//  Created by オムラユウキ on 2018/10/11.
//  Copyright © 2018 Seiya. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var texttex: UITextView!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(name: String?, text: String?, time: String?) {
        self.name.text = name
        
        self.texttex.text = text
        self.time.text = time
    }
    
}
