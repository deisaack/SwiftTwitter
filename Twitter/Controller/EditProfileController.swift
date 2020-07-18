//
//  EditProfileController.swift
//  Twitter
//
//  Created by De Isaac on 7/16/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit


private let reuseIdentifier = "EditProfileCell"


protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}


class EditProfileController: UITableViewController  {
    //MARK: - Properties
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    weak var delegate: EditProfileControllerDelegate?
    private let footerView = EditProfileFooter()
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    private var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage}
    }
    
    private var userInfoChanged = false
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        configureNavigationBar()
        configureTableView()
    }
    
    init(user: User){
        self.user = user
        super.init(style: .plain)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        guard imageChanged || userInfoChanged else {
            return
        }
        updateUserData()
    }
    
    //MARK: - API
    
    func updateUserData() {
        if imageChanged {
            if userInfoChanged {
                UserService.shared.saveUserData(user: user) { (err, ref) in
                    self.updateProfileImage()
                }
            } else {
                    self.updateProfileImage()
                }
            }
        else {
            if userInfoChanged {
                UserService.shared.saveUserData(user: user) { (err, ref) in
                    self.delegate?.controller(self, wantsToUpdate: self.user)
                }
            }
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else {
            return
        }
        UserService.shared.uploadProfileImage(image: image) { profileImageUrl in
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    //MARK: - Helpers
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureTableView(){
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        footerView.delegate = self
        tableView.tableFooterView = footerView
        
        headerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

//MARK: -  UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0}
        return option == .bio ? 100 : 48
    }
}

// MARK: -  UITableViewDataSource

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        cell.delegate = self
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {
            return cell
        }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
}

//MARK: -  EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: -  UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        selectedImage = image
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -  EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else {
            return
        }
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else {
                return
            }
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else {
                return
            }
            user.username = username
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}

//MARK: -  EditProfileFooterDelegate
extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you wnt to logout?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
               
        
    }
}
