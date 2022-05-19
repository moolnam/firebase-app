//
//  LoginViewController.swift
//  firebase-app
//
//  Created by KimJongHee on 2022/05/19.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: - UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        return image
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "이메일을 입력하세요"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "비밀번호를 입력하세요"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    //MARK: - vireDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "로그인"
        view.backgroundColor = UIColor(named: "LoginColor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "회원가입", style: .plain, target: self, action: #selector(didTapRegister))
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        // 로그인 실패시 올라오는 팝업 같은 것 

        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        
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
        logoImage.frame = CGRect(x: (scrollView.wigth-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailTextField.frame = CGRect(x: paddingSize, y: logoImage.bottom+paddingSize, width: widthSize, height: heightSize)
        print(logoImage.frame)
        
        passwordTextField.frame = CGRect(x: paddingSize, y: emailTextField.bottom+paddingSize, width: widthSize, height: heightSize)
        
        loginButton.frame = CGRect(x: paddingSize, y: passwordTextField.bottom+100, width: widthSize, height: heightSize)

    }
    
    
    //MARK: - func
    
    @objc private func loginButtonTapped() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count > 6 else {
            print("로그인 에러")
            alertUserLoginError()
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email : \(email)")
                return
            }
            
            let user = result.user
            print("Logged In User : \(user)")
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func alertUserLoginError() {
        print("Error \(emailTextField), \(passwordTextField)")
        let alert = UIAlertController(title: "오류", message: "다시 확인해 주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
    
    @objc private func didTapRegister() {
        print("Did Tap Register Clicked")
        let vc = RegisterViewController()
        vc.title = "계정 만들기"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

//MARK: - UITextViewDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            // emailField 에 있다면 키보드를 유지시키고
        }
        else if textField == passwordTextField {
            loginButtonTapped()
            // passwordfield 에 있다면 loginButtonTapped() 메소드를 실행 시킨다.
            // loginButtonTapped 안에 있는 resignFirstResponder() 각각 텍스트필드에 있는 키보드를 전체 내리게 한다.
        }
        return true
    }
}
