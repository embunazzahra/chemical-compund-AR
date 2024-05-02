//
//  ContentView.swift
//  Carousel
//
//  Created by Rania Pryanka Arazi on 26/04/24.
//

import SwiftUI

struct ContentView: View {
    
    //property wrapper --> store and/or retrieve data.
    @State private var currentIndex: Int = 0 //yang nanti di manipulasi
    
    //updates a property while the user performs a gesture and resets the property back to its initial state when the gesture ends.
    // CGFloat (type of data) --> holds either 32-bits of data or 64-bits of data
    @GestureState private var dragoOffset: CGFloat = 0
    
    @State var isActive: Bool  = true//manipulasi is play button
    
    
    //array of image instruction --> diambil dari asset
    private let images: [String] = ["1", "2", "3", "4", "5", "6"]
    
    
    var body: some View{
        
        NavigationStack{
            // This begins a vertical stack, arranging views verticall (kebawah)
            VStack{
                
                //This starts a stack, allowing views to overlap each other (numpuk)
                ZStack{
                    
                    //iterates over the array of images.
                    ForEach(0..<images.count, id: \.self){index in
                        Image(images[index]) //This displays an image from the array.
                            .resizable()
                            .frame(width: 290, height: 550)
                            .cornerRadius(25)

                         
                            //condition
                        
                            //Sets the opacity of the image based on the currentIndex.
                            .opacity(currentIndex == index ? 1.0 : 0.5)
                        
                            //scales the image based on the currentIndex.
                            .scaleEffect(currentIndex == index ? 1.2: 0.8)
                        
                            //offsets the position of the image.
                            .offset(x: CGFloat(index - currentIndex) * 300 + dragoOffset, y: 0)
                    
                        
                        
                    }
                }
                
                
                //adds a drag gesture to the stack of images.
                .gesture(
                    DragGesture()
                        //action to perform when the gesture ends.
                        .onEnded({ value in
                            
                            //Sets a threshold value for determining the drag direction.
                            let threshold: CGFloat = 50
                            
                            // checks the drag direction and updates the currentIndex accordingly.
                            if value.translation.width > threshold{
                                withAnimation{
                                    currentIndex = max(0, currentIndex - 1)
                                }
                            }else if value.translation.width < -threshold{
                                withAnimation{
                                    currentIndex = min(images.count - 1, currentIndex + 1)
                                }
                            }
                        })
                )
                
            }
            
            
            //button bawah
            .toolbar{
                // placed at the bottom of the toolbar
                ToolbarItem(placement: .bottomBar){
                        

                    ZStack {
                        
                        //button carousel
                        //starts a horizontal stack, arranging views horizontally (kesamping)
                        HStack(spacing: 10){
                                
                            //Iterates over the indices of the images array.
                            //indices --> subscripting the collection of array, in ascending order.
                            ForEach(0..<images.count, id: \.self){index in
                                    
                                //tombol play (slide akhir)
                                Circle()
                                    .fill(Color.blue.opacity(currentIndex == index ? 1: 0.2))
                                    .frame(width: 7, height: 7)
                                    .scaleEffect(currentIndex == index ? 1.4 : 1)
                                    .animation(.spring(), value: currentIndex == index)
                            }
                        }
                    
                    
                        //play button (slide akhir)
                        if(currentIndex == images.count-1){
                            ZStack {
                                Rectangle()
                                    .frame(width: 280, height: 50)
                                    .foregroundColor(.white)
                                
//                              nav ke AR page --> playview ganti nanti
                                NavigationLink(destination: PlayView()){
                                    EmptyView()
                                }
                            
                
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .padding()
                                    .foregroundColor(.blue).opacity(0.5)
                                
                                    //animation play button
                                    .symbolEffect(.pulse, isActive: isActive)
                            
                                  
                            }
                            
                        }
                    
                    }
                    
                }//
            }
            

            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
