//
//  ViewController.swift
//  TestNotifPos
//
//  Created by Bill Martensson on 2020-11-26.
//

import UIKit
import CoreLocation
import UserNotifications


class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var thelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .authorized {
                print(" Yes > if settings.authorizationStatus == .authorized")
            } else {
                center.requestAuthorization(options: [.alert, .sound], completionHandler: { granted, error in
                    if granted && error == nil {
                        print("Yes > granted && error == nil")
                    } else {
                        print("NOT >granted && error == nil")
                    }
                })
            }
        })
        
        UNUserNotificationCenter.current().delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let center = UNUserNotificationCenter.current()
        
        
        center.getPendingNotificationRequests() { allpend in
            print("ALLPENDING")
            for pend in allpend
            {
                print(pend.identifier)
                
            }
            
            DispatchQueue.main.async {
                self.thelabel.text = String(allpend.count)
            }
            
        }
        
    }
    
    
    @IBAction func dostuff(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Gather your things.."
        content.body = "SAKER"
        content.badge = 1
        
        
        let id = "reminder-\(UUID().uuidString)"
        
        print(locationManager.location!.coordinate)
        
        let destRegion = CLCircularRegion(center: locationManager.location!.coordinate,
                                          radius: 100,
                                          identifier: id)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = true
        
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: true)
        
        
        
        
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        center.getPendingNotificationRequests() { allpend in
            print("ALLPENDING")
            for pend in allpend
            {
                print(pend.identifier)
                
            }
        }
        
        /*
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            print(error.debugDescription)
            DispatchQueue.main.async {
                
            }
        }
        */
        
        center.add(request, withCompletionHandler: { error in
            print("NOTIFADD")
            print(error.debugDescription)
            
            center.getPendingNotificationRequests() { allpend in
                print("ALLPENDING DONE")
                for pend in allpend
                {
                    print(pend.identifier)
                    
                }
            }
            
            DispatchQueue.main.async {
                
            }
        })
        
    
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Alert", message: "didReceive", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        let alert = UIAlertController(title: "Alert", message: "WILL PRESENT", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
}

