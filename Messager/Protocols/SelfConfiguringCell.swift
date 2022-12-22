//
//  SelfConfiguringCell.swift
//  Messager
//
//  Created by Артём on 02.12.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String {get}
    func configure<U: Hashable>(with value: U)
}
