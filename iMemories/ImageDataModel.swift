//
//  ImageDataModel.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 27/09/23.
//
import Foundation
import SwiftData

@Model
final class ImageDataModel {
    var id = UUID()
    var image: Data
    var isFavorite = false
    var date:Date
    var locationName:String
    var latitude:Double
    var longitude:Double
    init(image: Data, date: Date,locationName:String,latitude:Double,longitude:Double) {
        self.image = image
        self.date = date
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        
    }
}
extension Date {
    
    func getCurrentDate(date: Date) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        return dateFormatter.string(from: date)

    }
    func getCurrentTime(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
}
