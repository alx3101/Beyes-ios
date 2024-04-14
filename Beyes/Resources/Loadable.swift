//
//  Loadable.swift
//  Beyes
//
//  Created by Alex Popa on 12/04/24.
//

import SwiftUI

enum Loadable<Value> {
    case notRequested
    case loading
    case loaded(Value)
    case failed(Error)

    var isLoading: Bool {
        if case .loading = self {
            return true
        } else {
            return false
        }
    }

    var hasError: Error? {
        if case let .failed(error) = self {
            return error
        } else {
            return nil
        }
    }
}
