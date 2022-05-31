//
//  MovieListCoordinator.swift
//  iOS-Practical-Test
//
//  Created by Maya on 31/5/22.
//

import Foundation
import UIKit

final class MovieListCoordinator: Coordinator,CoordinatorProtocol {
    
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private unowned var navigationController: UINavigationController
    public weak var coordinator: CoordinatorProtocol?
    private unowned var controller: MovieListVC
    
    init(navigationController: UINavigationController,controller: MovieListVC = MovieListVC()) {
        self.navigationController = navigationController
        self.controller = controller
    }
        
    func start() {
        controller = .instantiate()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
        bindToLifecycle(of: controller)
    }
}
