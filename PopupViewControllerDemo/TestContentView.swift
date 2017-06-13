//
//  TestContentView.swift
//  PopupViewController
//
//  Created by Henry Heguang Miao on 13/6/17.
//  Copyright © 2017 Henry Heguang Miao. All rights reserved.
//

import UIKit
import PopupViewController

class TestContentView: UIView, PopupContentViewType {

    @IBOutlet weak var label: UILabel!

    weak var popupViewController: PopupViewController?

    func setParentController(_ controller: PopupViewController) {
        popupViewController = controller
    }

    @IBAction func dismiss(_ sender: UIButton) {
        popupViewController?.dismiss(animated: true, completion: nil)
    }
}
