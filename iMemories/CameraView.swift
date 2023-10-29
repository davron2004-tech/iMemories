//
//  CameraView.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 26/09/23.
//

import SwiftUI
import UIKit
import CoreLocation
struct CameraView: UIViewControllerRepresentable {
    
    @Environment(\.modelContext) var context
    @Binding var isPhotosView:Bool
    var location:CLLocationCoordinate2D?
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(cameraView: self)
    }
}

final class Coordinator:NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var cameraView: CameraView
    
    init(cameraView: CameraView) {
        self.cameraView = cameraView
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[.originalImage] as? UIImage{
            let imageToSave = image.jpeg(.low)!
            let date = Date()
            if let location = cameraView.location{
                fetchData(location,imageToSave,date)
            }
            else{
                let locationName = "No location"
                cameraView.context.insert(ImageDataModel(image: imageToSave,date: date,locationName: locationName,latitude: 0,longitude: 0))
                cameraView.isPhotosView = true
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cameraView.isPhotosView = true
    }
    
    
    func fetchData(_ location:CLLocationCoordinate2D,_ imageToSave:Data,_ date:Date){
        var urlString:String{ "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=\(location.latitude)&longitude=\(location.longitude)&localityLanguage=en"
        }
        guard let url = URL(string: urlString)else{
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let unwrappedData = data{
                self.decodeData(unwrappedData,imageToSave,date)
            }
            
        }
        task.resume()
        
    }
    func decodeData(_ data: Data,_ imageToSave:Data,_ date:Date){
        let decoder = JSONDecoder()
        do{
            let result = try decoder.decode(LocationModel.self, from: data)
            let locationName = "\(result.city), \(result.countryName)"
            
            cameraView.context.insert(ImageDataModel(image: imageToSave,date: date,locationName: locationName,latitude: result.latitude,longitude: result.longitude))
            cameraView.isPhotosView = true
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
