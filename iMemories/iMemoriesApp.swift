//
//  iMemoriesApp.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 26/09/23.
//

import SwiftUI
import SwiftData


@main
struct CameraApp: App {
    
    var body: some Scene {
        WindowGroup {
            PhotosView(isPhotosView: .constant(true))
        }
        .modelContainer(for: ImageDataModel.self)
    }
}
