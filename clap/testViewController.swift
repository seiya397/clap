//
//  testViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/10/15.
//  Copyright © 2018 Seiya. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var testImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        testImage.image = UIImage(named: "https://firebasestorage.googleapis.com/v0/b/clap-b855d.appspot.com/o/users%2FawIvUotnE9bzb77IAtON78akGV53%2FprofileImage.jpg?alt=media&token=e24d6229-f497-40ca-863f-59209352b6b7")
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
