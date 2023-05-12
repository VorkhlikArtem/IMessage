//
//  ViewController.swift
//  Messager
//
//  Created by Артём on 30.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AuthViewController: UIViewController {
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "artem"), contentMode: .scaleAspectFit)
    let welcomeLabel = UILabel(text: "Welcome to my Chat App", font: .systemFont(ofSize: 15, weight: .bold))

    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isWithShadow: true).costomizeGoogleButton()
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .darkButtonColor)
    let loginButton = UIButton(title: "Login", titleColor: .redButtonColor, backgroundColor: .white, isWithShadow: true)
    
    lazy var signUpVC = SignUpViewController()
    lazy var loginVC = LoginViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupConstraints()
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func emailButtonTapped() {
        signUpVC.navigationDelegate = self
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        loginVC.navigationDelegate = self
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped() {
        googleSingIn(withPresentingVC: self)
    }

    
    func setupConstraints() {
        let logoStack = UIStackView(arrangedSubviews: [logoImageView, welcomeLabel], axis: .horizontal, spacing: 15)
        logoStack.alignment = .center
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        logoStack.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoStack)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoStack.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoStack.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

extension AuthViewController: AuthNavigationDelegate {
    func presentLoginVC() {
        loginVC.navigationDelegate = self
        present(loginVC, animated: true, completion: nil)
    }
    
    func presentSignupVC() {
        signUpVC.navigationDelegate = self
        present(signUpVC, animated: true, completion: nil)
    }
}

extension UIViewController {
    func googleSingIn(withPresentingVC presentingVC: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC) { [unowned self] gidUser, error in
            AuthService.shared.loginGoogle(user: gidUser, error: error) { result in
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
                    self.presentAlert(withTitle: "Google Login Failure", andMessage: error.localizedDescription)
                }
            }
        }
    }
}




//MARK: - SwiftUI
import SwiftUI
struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        let viewController = AuthViewController()
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
