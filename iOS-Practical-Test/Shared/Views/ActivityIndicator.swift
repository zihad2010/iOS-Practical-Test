//
//  ActivityIndicator.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import UIKit

@objc open class ActivityIndicator: NSObject {

    let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.color = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @objc func showLoading(view: UIView?) {
        if let view = view {
            view.addSubview(loadingIndicator)
            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor
                    .constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor
                    .constraint(equalTo: view.centerYAnchor),
                loadingIndicator.widthAnchor
                    .constraint(equalToConstant: 50),
                loadingIndicator.heightAnchor
                    .constraint(equalTo: loadingIndicator.widthAnchor)
            ])
            loadingIndicator.startAnimating()
        }
    }
    
    @objc func hideLoading() {
        DispatchQueue.main.async { [self] in
            self.loadingIndicator.stopAnimating()
        }
    }
}
