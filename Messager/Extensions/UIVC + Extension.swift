//
//  UIVC + Extension.swift
//  Messager
//
//  Created by Артём on 15.12.2022.
//

import UIKit
import FirebaseCore
import GoogleSignIn

extension UIViewController {
    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to dequeue cell")}
        cell.configure(with: value)
        return cell
    }
}

extension UIViewController {
    func presentAlert(withTitle title: String, andMessage message: String, handler: @escaping ()->Void = {} ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in handler() }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
