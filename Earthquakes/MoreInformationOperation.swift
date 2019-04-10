/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file contains the code to present more information about an earthquake as a modal sheet.
*/

import Foundation
import SafariServices
import TMOperations

/// An `Operation` to display an `NSURL` in an app-modal `SFSafariViewController`.
class MoreInformationOperation: TMOperation {
    // MARK: Properties

    let url: URL
    
    // MARK: Initialization
    
    init(URL: URL) {
        self.url = URL

        super.init()
        
        addCondition(condition: MutuallyExclusive<UIViewController>())
    }
    
    // MARK: Overrides
 
    override func execute() {
        DispatchQueue.main.async {
            self.showSafariViewController()
        }
    }
    
    private func showSafariViewController() {
        if let context = UIApplication.shared.keyWindow?.rootViewController {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = true
            let safari = SFSafariViewController(url: url, configuration: configuration)
            safari.delegate = self
            context.present(safari, animated: true, completion: nil)
        }
        else {
            finish()
        }
    }
}

extension MoreInformationOperation: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            self.finish()
        }
    }
}
