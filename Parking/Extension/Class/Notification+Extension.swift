//
//  Notification.swift
//  Parking
//
//  Created by Genapi on 23/01/2022.
//

import Foundation

enum NotificationName: String {
    case bikeIsRequesting
    case bikeIsDone
    case bikeHasData
    case carIsRequesting
    case carIsDone
    case carHasData
}

extension Notification.Name {
    static let bikeIsRequesting = Notification.Name(NotificationName.bikeIsRequesting.rawValue)
    static let bikeIsDone = Notification.Name(NotificationName.bikeIsDone.rawValue)
    static let bikeHasData = Notification.Name(NotificationName.bikeHasData.rawValue)
    static let carIsRequesting = Notification.Name(NotificationName.carIsRequesting.rawValue)
    static let carIsDone = Notification.Name(NotificationName.carIsDone.rawValue)
    static let carHasData = Notification.Name(NotificationName.carHasData.rawValue)
}

extension Notification {
    static let bikeIsRequesting = Notification(name: Notification.Name(rawValue: NotificationName.bikeIsRequesting.rawValue))
    static let bikeIsDone = Notification(name: Notification.Name(rawValue: NotificationName.bikeIsDone.rawValue))
    static let bikeHasData = Notification(name: Notification.Name(rawValue: NotificationName.bikeHasData.rawValue))
    static let carIsRequesting = Notification(name: Notification.Name(rawValue: NotificationName.carIsRequesting.rawValue))
    static let carIsDone = Notification(name: Notification.Name(rawValue: NotificationName.carIsDone.rawValue))
    static let carHasData = Notification(name: Notification.Name(rawValue: NotificationName.carHasData.rawValue))
}
