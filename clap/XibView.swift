//
//  XibView.swift
//  clap
//
//  Created by Seiya on 2018/09/28.
//  Copyright © 2018年 Seiya. All rights reserved.
//


import UIKit

class XibView: UIView {
    
    // コードから生成した時の初期化処理
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibInit()
    }
    
    // ストーリーボードで配置した時の初期化処理
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibInit()
    }
    
    // xibファイルを読み込んでviewに重ねる
    fileprivate func nibInit() {
        
        // File's OwnerをXibViewにしたので ownerはself になる
        guard let view = UINib(nibName: "XibView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(view)
    }
    
}
