//
//  ViewController.swift
//  PopupViewControllerDemo
//
//  Created by Henry Heguang Miao on 13/6/17.
//  Copyright © 2017 Henry Heguang Miao. All rights reserved.
//

import UIKit
import PopupViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func popup(sender: UIButton) {

        let contentView = UINib.init(nibName: "TestContentView", bundle: nil)
            .instantiate(withOwner: nil, options: nil).first as! TestContentView
        contentView.label.text = "long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text long text "
        let popupController = PopupViewController(contentView: contentView)
        popupController.beginPosition = .belowBottom
        popupController.endPosition = .bottom
        popupController.marginBottom = 40
        self.present(popupController, animated: true, completion: nil)
    }

}

