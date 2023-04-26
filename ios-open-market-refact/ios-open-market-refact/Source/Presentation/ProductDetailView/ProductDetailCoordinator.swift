//
//  ProductDetailCoordinator.swift
//  ios-open-market-refact
//
//  Created by Hansuk.YU on 2023/04/25.
//

import UIKit

class ProductDetailCoordinator: Coordinator {
    
    var productId: Int?
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, productId: Int) {
        self.productId = productId
        self.navigationController = navigationController
    }
    
    func start() {
        guard let productId = productId else { return }
        let vc = ProductDetailViewController()
        vc.receiveProductNumber(productNumber: productId)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishDetailView() {
        parentCoordinator?.childDidFinish(self)
    }
}

extension ProductDetailCoordinator: RegistCoordinating {
    func registSubscription() {
        let child = ProductRegistCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
