//
//  BottomListSheet.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-24.
//

import SwiftUI

struct BottomListSheet: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack(spacing: 12) {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 6)

            Text("Results: (\(dataManager.filteredCentres.count)) centres")
                .font(.headline)
                .padding(.bottom, 4)

            List(dataManager.filteredCentres) { centre in
                Text(centre.name) 
            }
        }
        .background(.ultraThinMaterial)
    }
}
 
