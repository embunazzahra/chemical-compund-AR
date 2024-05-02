//
//  SplashScreenView.swift
//  Carousel
//
//  Created by Rania Pryanka Arazi on 01/05/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.3
    @State private var opacity = 0.3
    
    
    var body: some View {
        
        if isActive{
            ContentView()
        }else{
            VStack{
                VStack{
                    Image(systemName: "atom")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.spring(duration: 2.0)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
        
    }
}

#Preview {
    SplashScreenView()
}
