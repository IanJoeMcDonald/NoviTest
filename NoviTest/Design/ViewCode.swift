//
//  ViewCode.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

protocol ViewCode {

    func setupViewCode()
    func setupViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
}

extension ViewCode {

    func setupViewCode() {
        setupViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
