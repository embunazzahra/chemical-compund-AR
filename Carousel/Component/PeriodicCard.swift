//
//  PeriodicCard.swift
//  Unlocked Atom
//
//  Created by Dhau Embun Azzahra on 27/04/24.
//

import SwiftUI

struct PeriodicCard: View {
    var atomicNumber: String
    var atomicWeight: String
    var symbol: String
    var atomicName: String
    var metalType: String
    var color: String
    var fontColor: String
    var isLocked: Bool
    let itemWidth: CGFloat
    
    
    var body: some View {
        
        GeometryReader { reader in
            
            
            ZStack{
                VStack{
                    Spacer()
                    HStack(content: {
                        Text(atomicNumber)
                            .font(.system(size: 38))
                            .bold()
                            .foregroundColor(Color(fontColor))
                        Spacer()
                        
                    })
                    Spacer()
                    Spacer()
                    Text(symbol)
                        .font(.system(size: 90))
                        .bold()
                        .foregroundColor(Color(fontColor))
                    Spacer()
                    Text(atomicName)
                        .font(.system(size: 35))
                        .foregroundColor(Color(fontColor))
                    Spacer()
                    Spacer()
                    Text(atomicWeight)
                        .font(.system(size: 20))
                        .foregroundColor(Color(fontColor))
                    Spacer()
                }
                .padding(.horizontal,20)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: itemWidth * 1.2)
            }
            .background(Color(color))
            .cornerRadius(50)
            .rotation3DEffect(
                getRotationAngle(reader: reader),
                axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
            )
            VStack{
                
            }.frame(height: 50)
            HStack(alignment: .center){
                Spacer()
                VStack{
                    Spacer()
                    Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(fontColor))
                }
//                .padding(.vertical,itemWidth * 0.15)
                Spacer()
            }
        }
        .frame(width: itemWidth - 20*2*2.5, height: itemWidth * 1.55, alignment: .center)
        
    }
    
    func getRotationAngle(reader: GeometryProxy) -> Angle {
        
        let midX = reader.frame(in: .global).midX
        let degrees = Double(midX-itemWidth/2)/4
        
        return Angle(degrees: -degrees)
    }
}

#Preview {
    PeriodicCard(atomicNumber: "1", atomicWeight: "1.008", symbol: "H", atomicName: "Hydrogen", metalType: "Nonmetal", color: "YellowColor", fontColor: "DarkGreen", isLocked: true, itemWidth: 0)
}
