//
//  LoginViewController.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Combine
import UIKit

class LoginViewController: UIViewController {

    // MARK: Initializers
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Properties
    private let customView = LoginView()
    private let viewModel: LoginViewModel
    private var cancellable: AnyCancellable?

    // MARK: View Lifecycle
    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationObservers()
        setupDismissKeyboard()
        setupCancellable()
        setupDelegates()
        setupTargets()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        view.endEditing(true)
    }

    // MARK: Private Custom Methods
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setupDismissKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        customView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func setupCancellable() {
        cancellable = viewModel.$state.sink { [weak self] state in self?.handleViewModelState(state) }
    }

    private func setupDelegates() {
        customView.passwordTextField.delegate = self
        customView.userNameTextField.delegate = self
    }

    private func setupTargets() {
        customView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    private func navigateTo(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func handleViewModelState(_ state: LoginViewModel.State) {
        switch state {
        case .initial: break
        case let .enableLoginButton(isEnabled): customView.loginButton.isEnabled = isEnabled
        case let .isLoading(isLoading): customView.isLoading(isLoading)
        case let .navigateTo(viewController): navigateTo(viewController)
        }
    }

    // MARK: Actions
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard
            let keyboardNSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        customView.loginButtonBottomConstraint.constant = -keyboardNSValue.cgRectValue.height
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        customView.loginButtonBottomConstraint.constant = customView.loginButtonBottomConstraintConstant
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func loginButtonTapped() {
        viewModel.loginButtonTapped()
    }
}

// MARK: Extension TextField Delegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case customView.userNameTextField: viewModel.updateUserName(to: textField.text)
        case customView.passwordTextField: viewModel.updatePassword(to: textField.text)
        default: break
        }
    }
}
