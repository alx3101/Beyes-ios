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
        VStack(alignment: .leading, spacing: 0) {
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

            Spacer()
                .frame(height: 16)

            VStack(spacing: 4) {
                Text(shop.brand)
                    .font(.system(size: 16))
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(shop.shortAddress ?? shop.address)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding(8)
        .frame(maxHeight: 130)
        .background {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.5), radius: 5, y: 2.5)
        }
    }
}

#Preview {
    VStack {
        let columns = Array(repeating: GridItem(.flexible()), count: 3)

        LazyVGrid(columns: columns, content: {
            ForEach(1 ... 2, id: \.self) { _ in
                HomeCell(shop: .mock())
            }
        })
    }
    .padding(.horizontal, 8)
}
