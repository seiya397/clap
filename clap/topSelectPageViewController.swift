//
//  topSelectPageViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/02.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit

class topSelectPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func teamIdRegisterButton(_ sender: Any) {
        let teamInfoRegister = self.storyboard?.instantiateViewController(withIdentifier: "teamInfoRegisterViewController") as! teamInfoRegisterViewController
        self.present(teamInfoRegister, animated: true, completion: nil)
        //segueで繋いでいる理由は、視覚的にわかりやすくするため
    }
    @IBAction func userRegisterButton(_ sender: Any) {
        let teamIdConfirmation = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmationViewController") as! teamIdConfirmationViewController
        self.present(teamIdConfirmation, animated: true, completion: nil)
        //segueで繋いでいる理由は、視覚的にわかりやすくするため
    }
}
