//
//  ProductListCoordinator.swift
//  ios-open-market-refact
//
//  Created by Hansuk.YU on 2023/04/25.
//

import UIKit

class ProductListCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: MainCoordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProductListViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didFinishListView() {
        parentCoordinator?.childDidFinish(self)
    }
}
