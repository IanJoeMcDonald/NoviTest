//
//  InsetTextField.swift
//  NoviTest
//
//  Created by Ian McDonald on 24/06/25.
//

import UIKit

class InsetTextField: UITextField {

    // MARK: Initializer
    init(horizontalInset: CGFloat = 0, verticalInset: CGFloat = 0) {
        self.horizontalInset = horizontalInset
        self.verticalInset = verticalInset
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}

    // MARK: Properties
    var horizontalInset: CGFloat = 0
    var verticalInset: CGFloat = 0

    // MARK: Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , horizontalInset , verticalInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , horizontalInset , verticalInset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds , horizontalInset , verticalInset)
    }
}
