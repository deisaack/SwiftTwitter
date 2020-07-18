//
//  EditProfileCell.swift
//  Twitter
//
//  Created by De Isaac on 7/16/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit

protocol EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    //MARK: -  Properties
    var viewModel: EditProfileViewModel? {
        didSet{ configure() }
    }
    
    var delegate: EditProfileCellDelegate?
    
    var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        tf.text = "test user attribute"
        return tf
    }()
    
    let bioTextView: InputTextView = {
       let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .twitterBlue
//        tv.placeholderLabel.text = ""
        return tv
    }()
    
    //MARK: -  Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 4)
        
//        addSubview(bioTextView)
//        bioTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  Selectors
    @objc func handleUpdateUserInfo() {
        print("DEBUG: Hello world")
        delegate?.updateUserInfo(self)
    }
    
    //MARK: -  Helpers
    func configure() {
        guard let vm = viewModel else {
            return
        }
        infoTextField.isHidden = vm.shouldHideTextField
        bioTextView.isHidden = vm.shouldHideTextField
        
        titleLabel.text = vm.titleText
        
        infoTextField.text = vm.optionValue
        bioTextView.text = viewModel?.optionValue
    }
}


extension EditProfileCell: InputTextViewDelegate {
    func inputValueChanged(_ input: InputTextView) {
        print("DEBUG: B")
        delegate?.updateUserInfo(self)
    }
    
    
}
