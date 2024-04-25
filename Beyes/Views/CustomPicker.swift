//
//  CustomPicker.swift
//  Beyes
//
//  Created by Alex Popa on 23/04/24.
//

import SwiftUI

struct CustomPicker<SelectionValue, Content>: View where SelectionValue == Content.Element, Content: RandomAccessCollection, Content.Element: Identifiable & Equatable, Content.Element.ID == String {
    let topTitle: String?
    @Binding var selection: SelectionValue?
    let items: () -> Content
    let placeholder: String
    let title: (Content.Element) -> Text
    let getImageView: (Content.Element) -> AnyView?

    @State var isPicking = false
    @State var hoveredItem: SelectionValue?
    @Environment(\.isEnabled) var isEnabled

    let buttonHeight: CGFloat = 44
    let arrowSize: CGFloat = 16
    let cornerRadius: CGFloat = 10

    var body: some View {
        // Select Button - Selected item
        VStack(alignment: .leading, spacing: 4) {
            if let topTitle {
                Text(topTitle)
                    .padding(.leading, 4)
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
            }

            HStack {
                if let selection {
                    row(selection)
                } else {
                    Text(placeholder)
                        .font(.system(size: 16))
                        .foregroundStyle(.gray.opacity(0.5))
                }
                Spacer()
                Image(systemName: "chevron.up")
                    .rotationEffect(isPicking ? Angle(degrees: -180) : Angle(degrees: 0))
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isPicking.toggle()
            }
            // Picker
            .overlay(alignment: .topLeading) {
                LazyVStack {
                    if isPicking {
                        Spacer(minLength: buttonHeight + 10)

                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(items()) { item in

                                    Button {
                                        selection = item
                                        isPicking.toggle()

                                    } label: {
                                        VStack {
                                            row(item)

                                            if item != items().last {
                                                Divider()
                                                    .padding(.trailing, 20)
                                            }
                                        }
                                    }
                                    .onHover { isHovered in
                                        if isHovered {
                                            hoveredItem = item
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .buttonStyle(.plain)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .scrollIndicators(.never)
                        .frame(height: 250)
                        .background {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(.regularMaterial)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .transition(.scale(scale: 0.8, anchor: .top).combined(with: .opacity).combined(with: .offset(y: -10)))
                    }
                }
            }
            .opacity(isEnabled ? 1.0 : 0.6)
            .font(.custom("RetroComputer", size: 13))
            .animation(.easeInOut(duration: 0.12), value: isPicking)
            .sensoryFeedback(.selection, trigger: selection)
            .zIndex(1)
        }
    }
}

private extension CustomPicker {
    @ViewBuilder
    func row(_ item: Content.Element) -> some View {
        HStack(spacing: 0) {
            if let imageView = getImageView(item) {
                AnyView(imageView)
                    .frame(width: 20, height: 20)
            }
            title(item)
                .minimumScaleFactor(0.7)
                .frame(height: buttonHeight)
                .padding(.horizontal, 10)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(hoveredItem == item ? Color.accentColor.opacity(0.8) : Color.clear)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 10)
                        .offset(y: 5)
                }
            Spacer()
        }
    }
}

#Preview {
    CustomPicker(topTitle: "Nation",
                 selection: .constant(nil), items: {
                     Fruit.allCases
                 }, placeholder: "Select") { item in
        Text(item.rawValue)
    } getImageView: { item in
        AnyView(Image(item.image))
    }
}

enum Fruit: String, CaseIterable, Identifiable {
    case apple, banana, mango, orange, strawberry, grape
    var image: String { "apple.logo" }
    var id: String { rawValue }
}
