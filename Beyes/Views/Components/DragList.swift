//
//  DragList.swift
//  Beyes
//
//  Created by Alex Popa on 04/05/24.
//
import SwiftUI
import UniformTypeIdentifiers

struct DragList<Element, RowContent: View>: View where Element: Equatable & Identifiable {
    @Binding var items: [Element]
    private let rowContent: (Element) -> RowContent
    @State private var selectedItem: Element?

    public init(_ items: Binding<[Element]>,
                @ViewBuilder rowContent: @escaping (Element) -> RowContent) {
        _items = items
        self.rowContent = rowContent
    }

    var body: some View {
        ForEach(items, id: \.id) { item in
            rowContent(item)
                .contentShape([.dragPreview], RoundedRectangle(cornerRadius: 20))
                .onDrag {
                    selectedItem = item
                    return NSItemProvider()
                } preview: {
                    rowContent(item)
                        .contentShape([.dragPreview], RoundedRectangle(cornerRadius: 20))
                }
                .onDrop(of: [UTType.text],
                        delegate: DropViewDelegate(destinationItem: item, items: $items, item: $selectedItem))
        }
    }
}
