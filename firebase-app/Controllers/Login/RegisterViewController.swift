//
//  RegisterViewController.swift
//  firebase-app
//
//  Created by KimJongHee on 2022/05/19.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.badge.plus")
        image.tintColor = UIColor.green
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.green.cgColor
        return image
    }()
    
    private let firstNameField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "이름을 입력하세요"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let secondNameField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.placeholder = "성을 입력하세요"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let emailField: UITextField = {
        let email = UITextField()
        email.autocapitalizationType = .none
        email.autocorrectionType = .no
        email.returnKeyType = .continue
        email.layer.cornerRadius = 12
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.black.cgColor
        email.placeholder = "이메일을 입력하세요"
        email.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        email.leftViewMode = .always
        email.backgroundColor = .white
        return email
    }()
    
    private let passwordField: UITextField = {
        let password = UITextField()
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.layer.cornerRadius = 12
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.black.cgColor
        password.placeholder = "비밀번호를 입력하세요"
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        password.leftViewMode = .always
        password.backgroundColor = .white
        password.isSecureTextEntry = true
        return password
    }()
    
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        title = "회원가입"
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(secondNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        
    }
    
    
    
    //MARK: - viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = view.wigth/3
        let size2 = view.height/2
        let paddingSize = view.wigth/20
        let widthSize = view.wigth - paddingSize * 2
        let heightSize = view.height/15
        print(size)
        print(size2)
        imageView.frame = CGRect(x: (scrollView.wigth-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.wigth/2
        
        firstNameField.frame = CGRect(x: paddingSize, y: imageView.bottom+paddingSize, width: widthSize, height: heightSize)
        
        secondNameField.frame = CGRect(x: paddingSize, y: firstNameField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        emailField.frame = CGRect(x: paddingSize, y: secondNameField.bottom+paddingSize, width: widthSize, height: heightSize)
        print(imageView.frame)
        
        passwordField.frame = CGRect(x: paddingSize, y: emailField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        registerButton.frame = CGRect(x: paddingSize, y: passwordField.bottom+100, width: widthSize, height: heightSize)
    }
    
    
    //MARK: - func
    
    
    @objc private func registerButtonTapped() {
        
        firstNameField.resignFirstResponder()
        secondNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
              let secondName = secondNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firstName.isEmpty,
              !secondName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count > 6 else {
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let result = authResult, error == nil else {
                return
            }
            
            let user = result.user
            print("Created User : \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func alertUserLoginError() {
        print("Error \(emailField), \(passwordField)")
        let alert = UIAlertController(title: "오류", message: "다시 확인해 주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
}


extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            //            registerButtonTapped()
            
        }
        
        return true
    }
}
