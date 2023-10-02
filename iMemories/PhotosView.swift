//
//  PhotosView.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 01/10/23.
//

import SwiftUI
import SwiftData
struct PhotosView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Binding var isPhotosView:Bool
    @State var isFavorite = false
    @Query var allPhotos:[ImageDataModel]
    @Query(filter: #Predicate<ImageDataModel>{$0.isFavorite == true}) var favoritePhotos:[ImageDataModel]
    @State var manager = LocationManager()
    var photos:[ImageDataModel]{
        if(isFavorite){
            return favoritePhotos
        }
        else{
            return allPhotos
        }
    }
    var columns:[GridItem] {
        if verticalSizeClass == .regular{
            [GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible())
        ]
        }
        else{
            [GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible()),
                       GridItem(.flexible())
        ]
        }
    }
    var body: some View {

        
        NavigationView{
            if (allPhotos.count == 0){
                VStack{
                    Text("No Photos")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("Press camera icon to add photo")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                    .toolbar{
                        ExtractedToolBar(isPhotosView: $isPhotosView, manager: $manager, isFavorite: $isFavorite)
                    }
            }
            else if(favoritePhotos.count == 0 && isFavorite){
                Text("No Favorite Photos")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .toolbar{
                        ExtractedToolBar(isPhotosView: $isPhotosView, manager: $manager, isFavorite: $isFavorite)
                    }
            }
            else{
                ScrollView(.vertical){
                    LazyVGrid(columns: columns){
                        ForEach(photos){photo in
                            NavigationLink{
                                PhotoDetailView(photo: photo)
                            }label: {
                                Image(uiImage: UIImage(data: photo.image)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                }
                .toolbar{
                    ExtractedToolBar(isPhotosView: $isPhotosView, manager: $manager, isFavorite: $isFavorite)
                }
            }
            
            
            
        }
        .onAppear(){
            manager.checkIfLocationServicesEnabled()
        }
    
        
    }
        
}
#Preview{
    PhotosView(isPhotosView: .constant(true))
}



struct ExtractedToolBar: ToolbarContent {
    @Binding var isPhotosView:Bool
    @Binding var manager:LocationManager
    @Binding var isFavorite:Bool
    var body: some ToolbarContent {
        
            ToolbarItem(placement: .topBarLeading){
                NavigationLink {
                    ContentView(location: $manager.location)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Image(systemName: "camera")
                }
                .onTapGesture {
                    isPhotosView = false
                }
                
            }
            
            ToolbarItem(placement: .principal){
                Text("Photos")
                    .font(.title2)
                    .foregroundColor(Color(.label))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                }
                
            }
        
        
    }
}
