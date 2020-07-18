//
//  MainTabController.swift
//  Twitter
//
//  Created by De Isaac on 7/8/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case tweet
    case message
}

class MainTabController: UITabBarController {
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    var user : User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {
                return
            }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - "Lifecycle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func fetchUser() {
        let uid = USER_ID
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func logUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DE: Failed to sign out \(error.localizedDescription)")
        }
    }
    
    //MARK: - Selectors
    @objc func actionButtonTapped() {
        let controller: UIViewController
        switch buttonConfig{
        case .tweet:
            guard let user = user else { return }
            print("DEBUG: A")
            controller = UploadTweetController(user: user, config: .tweet)
            print("DEBUG: B")
        case .message:
            controller = ExploreController()
            print("DEBUG: D")
        }
        print("DEBUG: C")
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        self.delegate = self
    }
    
    func configureViewControllers(){
        let fd = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feed = templateNavigationController(imageName: "home_unselected", rootViewController: fd)
        let explore = templateNavigationController(imageName: "search_unselected", rootViewController: ExploreController())
        let notifications = templateNavigationController(imageName: "like_unselected", rootViewController: NotificationsController())
        let conversations = templateNavigationController(imageName: "ic_mail_outline_white_2x-1", rootViewController: ConversationsController())
        
        viewControllers = [feed, explore, notifications, conversations]
    }
    
    func templateNavigationController(imageName: String, rootViewController: UIViewController) -> UINavigationController {
        let image = UIImage(named: imageName)
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
    
}


extension MainTabController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let image = index == 3 ? #imageLiteral(resourceName: "mail") : #imageLiteral(resourceName: "new_tweet")
        actionButton.setImage(image, for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
    }
}
