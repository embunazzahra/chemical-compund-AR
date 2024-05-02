//
//  ContentView.swift
//  Unlocked Atom
//
//  Created by Dhau Embun Azzahra on 26/04/24.
//

import SwiftUI

struct HistoryPage: View {
    @State private var selectedOption = 0
    //    let options = ["My Unlocked Atom", "Locked Atom"]
    let padding: CGFloat = 50
    
    
    var body: some View {
        
        NavigationView{
            GeometryReader{
                reader in
                
                ScrollView(.horizontal){
                    LazyHStack{
                        ForEach(0..<allAtoms.count){
                            i in
                            PeriodicCard(atomicNumber: allAtoms[i].atomicNumber, atomicWeight: allAtoms[i].atomicWeight, symbol: allAtoms[i].symbol, atomicName: allAtoms[i].atomicName, metalType: allAtoms[i].metalType, color: allAtoms[i].color, fontColor: allAtoms[i].fontColor,
                                         isLocked: allAtoms[i].isLocked,
                                         itemWidth: reader.size.width
                                         
                            )
                        }
                    }
                    .padding(.horizontal, padding)
                }
                .navigationBarHidden(true)
            }
        }
        
        
        
        
        
        //        //previous design
        //        ScrollView{
        //            VStack{
        //                UnlockedPicker()
        //                showCard()
        //            }
        //            .frame(width: 300)
        //
        //        }
        //        .scrollIndicators(.hidden)
        //
        
    }
    
    let atoms = [
        Atom(atomicNumber: "1", atomicWeight: "1.008", symbol: "H", atomicName: "Hydrogen", metalType: "Nonmetal",
             color: "Yellow",
             fontColor: "DarkYellow",
             isLocked: false),
        Atom(atomicNumber: "8", atomicWeight: "1.008", symbol: "O", atomicName: "Oxygen", metalType: "Nonmetal",
             color: "Blue",
             fontColor: "DarkBlue",
             isLocked: false),
        Atom(atomicNumber: "11", atomicWeight: "22.99", symbol: "Na", atomicName: "Sodium", metalType: "Alkali Metal",
             color: "Purple",
             fontColor: "DarkPurple",
             isLocked: true),
        Atom(atomicNumber: "17", atomicWeight: "35.45", symbol: "Cl", atomicName: "Chlorine", metalType: "Halogen",
             color: "Green",
             fontColor: "DarkGreen",
             isLocked: true)
    ]
    
    var allAtoms: [Atom] {
        return atoms
    }
    
    var filteredAtoms: [Atom] {
        if selectedOption == 0 {
            return atoms.filter { !$0.isLocked }
        } else {
            return atoms.filter { $0.isLocked }
        }
    }
    
    var backButton: some View {
        Button(action: {
            // Handle back button action here
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
        }
    }
    
    //    func showCard() -> some View {
    //        VStack (spacing: 30){
    //            ForEach(0..<filteredAtoms.count){
    //                i in
    //                PeriodicCard(atomicNumber: filteredAtoms[i].atomicNumber, atomicWeight: filteredAtoms[i].atomicWeight, symbol: filteredAtoms[i].symbol, atomicName: filteredAtoms[i].atomicName, metalType: filteredAtoms[i].metalType, color: filteredAtoms[i].color)
    //            }
    //        }
    //    }
    
    //    func UnlockedPicker() -> some View {
    //            return HStack {
    //                Picker(selection: $selectedOption, label: Text("Options")) {
    //                    ForEach(0..<options.count) { index in
    //                        Text(self.options[index]).tag(index)
    //                    }
    //                }
    //                .accentColor(.black)
    //                .scaleEffect(1.5)
    //            }
    //            .padding(.vertical, 30)
    //        }
}

//struct UnlockedAtom_Previews: PreviewProvider{
//    static var previews: some View{
//        ContentView(size: CGSize)
//    }
//}

//struct CarouselView: View{
//    let padding: CGFloat = 20
//    //size of available space
//    let size: CGSize
//
//    var body: some View{
//        ScrollView(.horizontal){
//            LazyHStack{
//                ForEach(0..<filteredAtoms.count){
//                    i in
//                    PeriodicCard(atomicNumber: filteredAtoms[i].atomicNumber, atomicWeight: filteredAtoms[i].atomicWeight, symbol: filteredAtoms[i].symbol, atomicName: filteredAtoms[i].atomicName, metalType: filteredAtoms[i].metalType, color: filteredAtoms[i].color,
//                        itemWidth: size.width
//
//                    )
//                }
//            }
//            .padding(.horizontal, padding)
//        }
//    }
//
//}

#Preview {
    HistoryPage()
}

