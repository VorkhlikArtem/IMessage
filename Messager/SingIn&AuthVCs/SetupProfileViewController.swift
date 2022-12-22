//
//  SetuoProfileViewController.swift
//  Messager
//
//  Created by Артём on 01.12.2022.
//

import UIKit
import FirebaseAuth
import SDWebImage

class SetupProfileViewController: UIViewController {
    
    
    let titleLabel = UILabel(text: "Create your profile", font: .avenir26())
    let fillImageView = AddPhotoView()
    
    let fullNameLabel = UILabel(text: "Fullname")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
   
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChartsButton = UIButton(title: "Go to chats!", titleColor: .white, backgroundColor: .darkButtonColor)
    
    let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        
        if let photoUrl = currentUser.photoURL {
            fillImageView.circleImageView.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupConstraints()
        goToChartsButton.addTarget(self, action: #selector(goToChartsButtonTapped), for: .touchUpInside)
        fillImageView.plusButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
    }
    
    @objc private func goToChartsButtonTapped() {
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: fullNameTextField.text,
                                                avatarImage: fillImageView.image,
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { result in
            switch result {
            case .success(let mUser):
                self.presentAlert(withTitle: "Success", andMessage: "You successfully set up your profile") {
                    let mainTBController = MainTabBarController(currentUser: mUser)
                    mainTBController.modalPresentationStyle = .fullScreen
                    self.present(mainTBController, animated: true, completion: nil)
                }
            case .failure(let error):
                self.presentAlert(withTitle: "Failure", andMessage: error.localizedDescription)
            }
        }
    }
    
    @objc private func addImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - setup Constraints
extension SetupProfileViewController {
    private func setupConstraints() {
        let fullnameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 10)
        
        goToChartsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let centralStackView = UIStackView(arrangedSubviews: [
            fullnameStackView,
            aboutMeStackView,
            sexStackView,
            goToChartsButton],
                                           axis: .vertical, spacing: 40)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        fillImageView.translatesAutoresizingMaskIntoConstraints = false
        centralStackView.translatesAutoresizingMaskIntoConstraints = false
   
        view.addSubview(titleLabel)
        view.addSubview(fillImageView)
        view.addSubview(centralStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([
            fillImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([
            centralStackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 50),
            centralStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            centralStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)])
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SetupProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        fillImageView.image = image
    }
}

//MARK: - SwiftUI
import SwiftUI
struct SetupProfileViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }

        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
    }
}
