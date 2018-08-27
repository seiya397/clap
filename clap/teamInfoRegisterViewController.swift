//
//  teamInfoRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/26.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase

class teamInfoRegisterViewController: UIViewController {
    
    @IBOutlet weak var belongTo: UITextField!
    @IBOutlet weak var sports: UITextField!
    @IBOutlet weak var managerName: UITextField!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managerRegisterNextButton(_ sender: Any) {
        let messageData = ["belong": belongTo.text!, "sport": sports.text!, "manager": managerName.text!]
        databaseRef.childByAutoId().setValue(messageData)
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
