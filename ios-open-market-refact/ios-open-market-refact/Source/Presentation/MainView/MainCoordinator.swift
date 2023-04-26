//
//  ParentCoordinator.swift
//  ios-open-market-refact
//
//  Created by Hansuk.YU on 2023/04/25.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(){
        let vc = MainViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?){
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension MainCoordinator: ListCoordinating, DetailCoordinating {
    func detailSubscription(at productId: Int) {
        let child = ProductDetailCoordinator(
            navigationController: navigationController,
            productId: productId
        )
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func listSubscription() {
        let child = ProductListCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
