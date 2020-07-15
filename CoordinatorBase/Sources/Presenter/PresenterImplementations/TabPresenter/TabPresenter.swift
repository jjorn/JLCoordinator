// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public final class TabPresenter: Presenter, TabPresenting {
    public var observers: WeakCache<PresenterObserving> = .init()
    public let tabBarController: UITabBarController

    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    public func present(_ viewController: UIViewController, animated: Bool = false) {
        guard tabBarController.viewControllers?.contains(viewController) != true else { return }

        presentOnTab(viewController, animated: animated)
    }

    public func dismiss(_ viewController: UIViewController, animated: Bool = false) {
       NSLog("⚠️ Presenter \(String(describing: self)) - \(#function): TabPresenter doesn't dismiss its root views")
    }

    public func dismissRoot(animated: Bool) {
        tabBarController.dismiss(animated: animated) { [weak self] in
            guard let self = self else { return }

            self.tabBarController.viewControllers?.forEach { self.notifyObserverAboutDismiss(of: $0) }
            self.notifyObserverAboutDismiss(of: self.tabBarController)
        }
    }
}
