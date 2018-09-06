//
//  teamIdGenerateViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/27.
//  Copyright © 2018年 Seiya. All rights reserved.
//

//userdefaultsでキャッシュしたデータを呼び出して表示（teamIDのための確認）

import UIKit
import Firebase

class teamIdGenerateViewController: UIViewController {

    @IBOutlet weak var generateTeamId: UILabel!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = userDefaults.string(forKey: "teamID")!
        print("これはチームID\(teamID)")
        self.generateTeamId.text! = teamID
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goLoginButton(_ sender: Any) {
        
    }
    

}
