//
//  UIView+Ext.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import UIKit

extension UIView {

    // MARK: Properties
    private static var internalIsLoading = false
    private static var internalViewTag = -101010

    // MARK: Custom Methods
    func isLoading(_ value: Bool, backgroundColor: UIColor? = nil, loaderColor: UIColor? = nil) {
        if value {
            showLoader(backgroundColor: backgroundColor, loaderColor: loaderColor)
        } else {
            hideLoader()
        }
    }

    // MARK: Private Custom Methods
    private func showLoader(backgroundColor: UIColor?, loaderColor: UIColor?) {
        guard !UIView.internalIsLoading else { return }
        UIView.internalIsLoading = true
        Task {
            await MainActor.run {
                let loaderView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
                loaderView.backgroundColor = backgroundColor ?? UIColor(white: 0, alpha: 0.7)
                loaderView.tag = UIView.internalViewTag
                let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
                loader.center = loaderView.center
                loader.color = loaderColor ?? .systemBackground
                loader.startAnimating()
                loaderView.addSubview(loader)
                addSubview(loaderView)
            }
        }
    }

    private func hideLoader() {
        UIView.internalIsLoading = false
        Task {
            await MainActor.run {
                self.viewWithTag(UIView.internalViewTag)?.removeFromSuperview()
            }
        }
    }
}
