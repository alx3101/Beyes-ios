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
}
