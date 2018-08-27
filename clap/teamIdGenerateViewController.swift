//
//  teamIdGenerateViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/27.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase

class teamIdGenerateViewController: UIViewController {

    @IBOutlet weak var generateTeamId: UILabel!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
        let resultNum = self.randomString(length: 10)
        databaseRef.childByAutoId().setValue(resultNum)
        print(self.randomString(length: 10))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goLoginButton(_ sender: Any) {
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
