//
//  LoginViewController.swift
//  Messager
//
//  Created by Артём on 01.12.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Welcome back!", font: .avenir26())
    
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "Or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")

    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isWithShadow: true).costomizeGoogleButton()
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let loginButton = UIButton(title: "Log in", titleColor: .white, backgroundColor: .darkButtonColor)
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.redButtonColor, for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    weak var navigationDelegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupConstraints()
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)

    }
    
    @objc private func loginTapped() {
        AuthService.shared.login(email: emailTextField.text,
                                 password: passwordTextField.text) { result in
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { result in
                    switch result {
                    case .success(let mUser):
                        let mainTBController = MainTabBarController(currentUser: mUser)
                        mainTBController.modalPresentationStyle = .fullScreen
                        self.present(mainTBController, animated: true, completion: nil)
                    case .failure(_):
                        self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                    }
                }

            case .failure(let error):
                self.presentAlert(withTitle: "Failure", andMessage: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpTapped() {
        dismiss(animated: true) {
            self.navigationDelegate?.presentSignupVC()
        }
    }
    
    @objc private func googleTapped() {
        googleSingIn(withPresentingVC: self)
    }
    
}
    
    // MARK: - Setup Constraints
extension LoginViewController {
    private func setupConstraints() {
        let loginWithView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let centralStackView = UIStackView(arrangedSubviews: [
            loginWithView,
            orLabel,
            emailStackView,
            passwordStackView,
            loginButton
        ],
                                           axis: .vertical, spacing: 40)
        
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 20)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        centralStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(centralStackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([
            centralStackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 70),
            centralStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            centralStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)])
        
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),

        ])
    }
}


//MARK: - SwiftUI
import SwiftUI
struct LoginViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = LoginViewController()
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
