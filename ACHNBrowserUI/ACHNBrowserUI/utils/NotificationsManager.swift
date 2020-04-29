//
//  NotificationsManager.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 29/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (_, _) in
            
        }
    }
    
    func removePendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func registerTurnipsPredictionNotification(prediction: TurnipPredictions) {
        removePendingNotifications()
        if let average = prediction.averagePrices {
            var dayOfTheWeek = 2
            let today = Calendar.current.component(.weekday, from: Date())
            let todayHour = Calendar.current.component(.hour, from: Date())
            for (index, day) in average.enumerated()  {
                let isMorning = index % 2 == 0
                
                if dayOfTheWeek >= today && (dayOfTheWeek != today && todayHour > 12) {
                    let content = UNMutableNotificationContent()
                    content.title = "Turnips prices"
                    content.body = "Your price prediction for \(isMorning ? "this morning": "this afternoon") should be around \(day) bells"
                    
                    var components = DateComponents()
                    components.calendar = Calendar(identifier: .gregorian)
                    components.weekday = dayOfTheWeek
                    components.hour = isMorning ? 8 : 12
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error while registering notification: \(error.localizedDescription)")
                        }
                    }
                    
                }
                
                if !isMorning {
                    dayOfTheWeek += 1
                }
            }
        }
    }
    
    func pendingNotifications(completion: @escaping (([UNNotificationRequest]) -> Void)) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
}
