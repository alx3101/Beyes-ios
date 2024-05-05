//
//  HomeCell.swift
//  Beyes
//
//  Created by Alex Popa on 04/05/24.
//

import SwiftUI

struct HomeCell: View {
    @State private var customersCount: Int = 0
    let shop: Shop

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 8)

            HStack {
                Text("\(customersCount)")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    }

                Spacer()
            }
            .padding(.horizontal, 4)

            Spacer().frame(height: 16)

            VStack(spacing: 2) {
                Text(shop.brandName)

                Text(shop.shopAddress)
            }

            Spacer().frame(height: 8)
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.5), radius: 5, y: 2.5)
        }
    }
}

#Preview {
    HomeCell(shop: .mock())
}
