//
//  ViewController.swift
//  Smarty News1
//
//  Created by User on 2017/07/11.
//  Copyright © 2017年 Yusuke Hirose. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var pageMenu:CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArray : [UIViewController] = []
        
//        let controller6:News6ViewController = News6ViewController()
//        controller6.title = "テスト"
//        controllerArray.append(controller6)

        let controller1:News1ViewController = News1ViewController()
        controller1.title = "トップ"
        controllerArray.append(controller1)
        
        let controller2:News2ViewController = News2ViewController()
        controller2.title = "エンタメ"
        controllerArray.append(controller2)
        
        let controller3:News3ViewController = News3ViewController()
        controller3.title = "スポーツ"
        controllerArray.append(controller3)
        
        let controller4:News4ViewController = News4ViewController()
        controller4.title = "グルメ"
        controllerArray.append(controller4)
        
        let controller5:News5ViewController = News5ViewController()
        controller5.title = "コラム"
        controllerArray.append(controller5)
        
        let parameters:[CAPSPageMenuOption] = [
        
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1)
        
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:20.0, width:self.view.frame.width, height:self.view.frame.height), pageMenuOptions: parameters)
        
        
        //pageMenuのビューを親のビューに追加
        self.view.addSubview(pageMenu!.view)
        //pageMenuのビューをtoolbarの後ろへ移動
        self.view.sendSubview(toBack: pageMenu!.view)
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

