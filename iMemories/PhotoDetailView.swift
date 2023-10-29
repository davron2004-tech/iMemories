//
//  PhotoDetailView.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 01/10/23.
//

import SwiftUI
import SwiftData
import MapKit
struct PhotoDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) var context
    @State var isShowingInfo = false
    let photo:ImageDataModel
    var body: some View {
        NavigationView{
            GeometryReader{geo in
                ZStack{
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    VStack{
                        Image(uiImage: UIImage(data: photo.image)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top,0)
                            .padding(.leading,0)
                            .padding(.trailing,0)
                            .modifier(ImageModifier(contentSize: CGSize(width: geo.size.width, height: geo.size.height)))
                        
                        HStack{
                            Button{
                                photo.isFavorite.toggle()
                            } label: {
                                Image(systemName: photo.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 30))
                            }
                            .padding(.leading,20)
                            Spacer()
                            Button{
                                isShowingInfo = true
                            } label: {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 30))
                            }
                            Spacer()
                            Button{
                                presentationMode.wrappedValue.dismiss()
                                context.delete(photo)
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 30))
                            }
                            .padding(.trailing,20)
                        }
                        .padding(.top,5)
                        .padding(.bottom,5)
                    }
                }
            }
            
            
        }
        .sheet(isPresented: $isShowingInfo){
            ZStack{
                Color("BackgroundColor")
                    .ignoresSafeArea()
                VStack(alignment: .leading,spacing: 7){
                    Text("Date: \(photo.date.getCurrentDate(date:photo.date))")
                        .font(.title2)
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                    Text("Time: \(photo.date.getCurrentTime(date:photo.date))")
                        .font(.title2)
                        .padding(.leading)
                        .padding(.trailing)
                    Text("Location: \(photo.locationName)")
                        .font(.title2)
                        .padding(.leading)
                        .padding(.trailing)
                    Spacer()
                    if(photo.locationName != "No location"){
                        Map{
                            Marker("Photo Location", coordinate: CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude))
                                .tint(.green)
                        }
                    }
                    
                    
                    
                }
            }
            
            
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}


