//
//  InputTextView.swift
//  Twitter
//
//  Created by De Isaac on 7/17/20.
//  Copyright © 2020 De Isaac. All rights reserved.
//

import UIKit


protocol InputTextViewDelegate: class {
    func inputValueChanged(_ input: InputTextView)
}

class InputTextView: UITextView {
    //MARK: -  Properties
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "Whats happening"
        return label
    }()
    
    weak var fieldDelegate: InputTextViewDelegate?
    
    
    //MARK: -  Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  Selectors
    @objc func handleTextInputChange() {
        print("DEBUG: Text view has changed")
        fieldDelegate?.inputValueChanged(self)
    }
}
