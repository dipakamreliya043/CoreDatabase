//
//  Story_Cell.swift
//  DAiOSTest
//
//  Created by Dipak on 05/08/22.
//

import UIKit

class Story_Cell: UITableViewCell {

    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var img_Thumnil: UIImageView!
    @IBOutlet weak var btn_Like: UIButton!
    @IBOutlet weak var btn_Delete: UIButton!
    
    var btnLikeHandling: (()->())?
    var btnDeleteHandling: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        btnLikeHandling?()
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        btnDeleteHandling?()
    }
    
}
