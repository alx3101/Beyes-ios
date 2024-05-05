//
//  ShopInteractor.swift
//  Beyes
//
//  Created by Alex Popa on 04/05/24.
//

import Foundation

protocol ServiceInteractorProvider {
    func getShops(data: @escaping (Loadable<[Shop]>) -> Void)
}

class ShopInteractor: ServiceInteractorProvider {
    private let service: ShopServices

    init(service: ShopServices) {
        self.service = service
    }

    func getShops(data: @escaping (Loadable<[Shop]>) -> Void) {
        data(.loading)
        Task {
            do {
                let shops = try await service.getAllShops()
                data(.loaded(shops))
            } catch {
                debugPrint(error)
                data(.failed(error))
            }
        }
    }
}
