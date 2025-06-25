//
//  LoginView.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import UIKit

class LoginView: UIView, ViewCode {

    // MARK: Initializers
    init() {
        super.init(frame: .zero)
        setupViewCode()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Components
    let userNameTextField: UITextField = {
        let view = InsetTextField(horizontalInset: Spacing.lg.rawValue, verticalInset: Spacing.sm.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardType = .namePhonePad
        view.autocapitalizationType = .none
        view.placeholder = "Username"
        view.borderStyle = .roundedRect
        view.backgroundColor = .systemGray
        view.textColor = .label

        return view
    }()

    let passwordTextField: UITextField = {
        let view = InsetTextField(horizontalInset: Spacing.lg.rawValue, verticalInset: Spacing.sm.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSecureTextEntry = true
        view.keyboardType = .namePhonePad
        view.autocapitalizationType = .none
        view.placeholder = "Password"
        view.borderStyle = .roundedRect
        view.backgroundColor = .systemGray
        view.textColor = .label

        return view
    }()

    let loginButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Login", for: .normal)
        view.layer.cornerRadius = Sizes.cornerRadius.rawValue
        view.clipsToBounds = true
        view.setTitleColor(.label, for: .normal)
        view.setTitleColor(.systemGray, for: .disabled)
        view.backgroundColor = .systemRed
        view.isEnabled = false

        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Welcome to NoviTest\nPlease login"
        view.font = .preferredFont(forTextStyle: .largeTitle)
        view.numberOfLines = 0
        view.textAlignment = .center

        return view
    }()

    // MARK: Properties
    lazy var loginButtonBottomConstraint = loginButton.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor,
        constant: loginButtonBottomConstraintConstant
    )
    let loginButtonBottomConstraintConstant: CGFloat = -Spacing.lg.rawValue

    // MARK: ViewCode
    func setupViewHierarchy() {
        addSubview(titleLabel)
        addSubview(userNameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

                userNameTextField.topAnchor.constraint(
                    equalTo: titleLabel.bottomAnchor,
                    constant: Spacing.lg.rawValue
                ),
                userNameTextField.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: Spacing.lg.rawValue
                ),
                userNameTextField.trailingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.trailingAnchor,
                    constant: -Spacing.lg.rawValue
                ),

                passwordTextField.topAnchor.constraint(
                    equalTo: userNameTextField.bottomAnchor,
                    constant: Spacing.lg.rawValue
                ),
                passwordTextField.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: Spacing.lg.rawValue
                ),
                passwordTextField.trailingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.trailingAnchor,
                    constant: -Spacing.lg.rawValue
                ),

                loginButton.heightAnchor.constraint(equalToConstant: Sizes.buttonHeight.rawValue),
                loginButton.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: Spacing.lg.rawValue
                ),
                loginButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.lg.rawValue),
                loginButtonBottomConstraint
            ]
        )
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemBackground
    }
}
