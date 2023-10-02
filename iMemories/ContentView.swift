//
//  ContentView.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 26/09/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var isShowingAlert = false
    @State var isPhotosView = false
    @Binding var location:CLLocationCoordinate2D?
    var body: some View {
        CameraView(isPhotosView: $isPhotosView,location: location)
            .onAppear{
                if(location == nil){
                    isShowingAlert = true
                }
            
            }
            .alert("Location services is disabled", isPresented: $isShowingAlert) {
                Button("OK",role: .cancel){
                    
                }
            }
            .ignoresSafeArea()
            
            
        .fullScreenCover(isPresented: $isPhotosView){
            PhotosView(isPhotosView: $isPhotosView)
        }
        
        
        
    }
}
