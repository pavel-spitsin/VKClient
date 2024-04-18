//
//  DateFormatter.swift
//  VKClient
//
//  Created by Павел on 17.04.2024.
//

import Foundation

struct DateService {
    //MARK: - Property
    private let dateFormatter = DateFormatter()
    
    //MARK: - Actions
    public func convertInt64ToTimeString(date: Int64) -> String {
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        return dateFormatter.string(from: date)
    }
    
    public func convertInt64ToDayString(date: Int64) -> String {
        dateFormatter.dateFormat = "dd:MM:yyy"
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        return dateFormatter.string(from: date)
    }
}
