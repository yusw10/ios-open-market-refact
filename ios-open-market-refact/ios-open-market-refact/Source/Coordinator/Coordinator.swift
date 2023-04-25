//
//  Coordinator.swift
//  ios-open-market-refact
//
//  Created by Hansuk.YU on 2023/04/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}


/*
 1. childCoordinator가 필요한이유?
 > 앱의 흐름이 여러개이고 각 흐름당 뎁스가 많을 경우 단일 코디네이터로는 이를 구현하기 어렵기 때문에 sub coordinator에게 각 흐름을 위임하는것.
 
 */
