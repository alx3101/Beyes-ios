//
//  TopBar.swift
//  Beyes
//
//  Created by Alex Popa on 15/04/24.
//

import Foundation
import SwiftUI

struct TopBar: View {
    let action: () -> Void
    var body: some View {
        HStack {
            Button { action() } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 13, height: 20)
                    .foregroundStyle(.text)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 50, alignment: .top)
    }
}
