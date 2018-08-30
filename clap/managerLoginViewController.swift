//
//  managerLoginViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/26.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit

class managerLoginViewController: UIViewController {
    
    @IBOutlet weak var managerMailaddress: UITextField!
    @IBOutlet weak var managerPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managerNextButton(_ sender: Any) {
    }
    
    @IBAction func managerRegisterButton(_ sender: Any) {
        performSegue(withIdentifier: "goManagerRegister", sender: nil)
    }
    
    @IBAction func updateRegisterInfoButton(_ sender: Any) {
        performSelector(inBackground: Selector("goUpdatePage"), with: nil)
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
