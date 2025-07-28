//
//  CircleIconButton.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-23.
//

import SwiftUI

struct CircleIconButton: View {
    
    let systemImageName: String
    let action:() -> Void
    let iconColor: Color = .black
    let backgroundColor: Color = .white
    var strokeColor:Color = .gray
    var size:CGFloat = 20
    
    
    
    var body: some View {
        
        Button(action: action){
            Image(systemName: systemImageName)
                           .resizable()
                           .scaledToFit()
                           .foregroundColor(iconColor)
                           .frame(width: size, height: size)
                           .padding()
                           .background(backgroundColor)
                           .clipShape(Circle())
                           .shadow(radius: 3)
                           .overlay(Circle().stroke(strokeColor, lineWidth: 1))
        }
    }
}


