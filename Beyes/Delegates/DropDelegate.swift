//
//  DropDelegate.swift
//  Beyes
//
//  Created by Alex Popa on 04/05/24.
//

import Foundation
import SwiftUI

struct DropViewDelegate<T>: DropDelegate where T: Equatable {
    let destinationItem: T
    @Binding var items: [T]
    @Binding var item: T?

    func dropUpdated(info _: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info _: DropInfo) -> Bool {
        item = nil
        return true
    }

    func dropEntered(info _: DropInfo) {
        // Swap Items
        if let item {
            let fromIndex = items.firstIndex(of: item)
            if let fromIndex {
                let toIndex = items.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? (toIndex + 1) : toIndex)
                    }
                }
            }
        }
    }
}
