//
//  FavouritesView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-17.
//

import SwiftUI

struct FavouritesView: View {
    
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        
        List{
            ForEach(dataManager.centres.filter{dataManager.favourites.contains(String($0.id))}){ centre in
                Text(centre.name)
                
            }
        }
    }
}

#Preview {
    FavouritesView()
}
