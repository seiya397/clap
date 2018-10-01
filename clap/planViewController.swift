//
//  planViewController.swift
//  clap
//
//  Created by Seiya on 2018/09/29.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit

class planViewController: UIViewController {
    
    var memo: String?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var planTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //文字メモに値がセットされていたらtextfieldにメモを渡す。
    //navigation itemのタイトルをEdit memoにする
    if let memo = self.memo {
        self.planTitle.text = memo
        self.navigationItem.title = "イベント"
    }
    self.updateSaveButtonState()
    }
    
    //
    private func updateSaveButtonState(){
        let memo = self.planTitle.text ?? ""
        self.saveButton.isEnabled = !memo.isEmpty
        //nilの場合空文字にする
        //空文字の場合saveボタンを無効化
    }

    //textField に入力された値を検出
    @IBAction func memoTextFieldChanged(_ sender: Any) {
        self.updateSaveButtonState()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //画面遷移した時にメモが保存されたままにする関数
    //この memo に値を設定したいのですが、今回 segue を巻き戻すことで TableView に戻したいので、 segue による遷移が行われる前に実行される prepare というメソッドの中で書いていけばいいですね。
    //こちらの prepare で memo に値を設定していきたいのですが、 Save ボタンが押された時の処理かどうかをチェックしておきましょう。
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else{
            //Save ボタンを押した時、こちらの sender に saveButton が入ってくるはずなので guard でチェック
            //button が saveButton と同じオブジェクトかどうかチェックしたいので button === self.saveButton
            return
            //同じだったらいいのですが、そうでなかったら処理を止めたいので return
        }
        //チェックがOKの場合
        self.memo = self.planTitle.text ?? ""
        //memo に値を設定したいので self.memo = としてあげて self.memoTextField.text を入る
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
