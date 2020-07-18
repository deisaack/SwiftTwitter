//
//  ConversationsController.swift
//  Twitter
//
//  Created by De Isaac on 7/8/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit


class ConversationsController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
