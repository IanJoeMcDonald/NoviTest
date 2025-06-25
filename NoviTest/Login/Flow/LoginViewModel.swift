//
//  LoginViewModel.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import Combine
import Foundation
import UIKit

class LoginViewModel {

    // MARK: Initializer
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // MARK: Properties
    @Published private(set) var state: State = .initial
    private let networkManager: NetworkManager
    private var username: String?
    private var password: String?

    // MARK: Custom Methods
    func loginButtonTapped() {
        guard let username, let password else { return }
        state = .isLoading(true)
        login(forUsername: username, withPassword: password)
    }

    func updateUserName(to username: String?) {
        self.username = username
        state = .enableLoginButton(validateInputs())
    }

    func updatePassword(to password: String?) {
        self.password = password
        state = .enableLoginButton(validateInputs())
    }

    // MARK: Private Custom Methods
    private func validateInputs() -> Bool {
        guard
            let username,
            !username.isEmpty,
            let password,
            !password.isEmpty
        else { return false }

        return true
    }

    private func login(forUsername username: String, withPassword password: String) {
        Task {
            do {
                let tokenEndpoint = TokenEndpoint(username: username, password: password)
                let tokenModel: LoginTokenModel = try await networkManager.performRequest(for: tokenEndpoint)
                networkManager.updateAuthorizationToken(with: tokenModel)

                await MainActor.run {
                    self.state = .isLoading(false)
                    self.state = .navigateTo(createHomeViewController())
                }

            } catch let error {
                // Proper error handling should be implemented
                print(error)
                await MainActor.run {
                    self.state = .isLoading(false)
                }
            }
        }
    }

    private func createHomeViewController() -> UIViewController {
        let viewModel = HomeViewModel(networkManager: networkManager)

        return HomeViewController(viewModel: viewModel)
    }
}

// MARK: State Enum
extension LoginViewModel {

    enum State {
        case initial
        case enableLoginButton(Bool)
        case isLoading(Bool)
        case navigateTo(UIViewController)
    }
}
