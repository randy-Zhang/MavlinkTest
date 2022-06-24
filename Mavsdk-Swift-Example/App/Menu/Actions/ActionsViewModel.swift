//
//  ActionsViewModel.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 14/05/21.
//

import Foundation
import Mavsdk
import RxSwift

final class ActionsViewModel: ObservableObject {
    let drone = mavsdkDrone.drone
    let disposeBag = DisposeBag()
    
    var altitude: Float = 0.0
    var takeoffAltitude: Float = 0.0
    
    var actions: [Action] {
        return [
            Action(text: "Arm", action: armAction),
            Action(text: "Disarm", action: disarmAction),
            Action(text: "TakeOff", action: takeOffAction),
            Action(text: "Land", action: landAction),
            Action(text: "RTL", action: rtlAction),
            Action(text: "Set RTL Altitude", action: setRTLAltitude),
//            Action(text: "Kill", action: killAction),
            Action(text: "Set takeoff Altitude", action: setTakeoffAltitudeAction)
        ]
    }
    
    init() {}
    
    func armAction() {
        drone?.action.arm()
            .subscribe {
                MessageViewModel.shared.message = "Armed Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Arming: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func disarmAction() {
        drone?.action.disarm()
            .subscribe {
                MessageViewModel.shared.message = "Disarmed Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Disarming: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func takeOffAction() {
        drone?.action.takeoff()
            .subscribe {
                MessageViewModel.shared.message = "Taking Off Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Taking Off: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func landAction() {
        drone?.action.land()
            .subscribe {
                MessageViewModel.shared.message = "Landing Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Landing: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func rtlAction() {
        drone?.action.returnToLaunch()
            .subscribe {
                MessageViewModel.shared.message = "RTL Success"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error RTL: \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func setRTLAltitude() {
        
        if altitude == 0 {
            MessageViewModel.shared.message = "Error Setting RTL Altitude"
            return
        }
        
        drone?.action.setReturnToLaunchAltitude(relativeAltitudeM: altitude)
            .subscribe(onCompleted: {
                MessageViewModel.shared.message = "Set RTL Altitude \(self.altitude)m Success"
            }, onError: { (error) in
                MessageViewModel.shared.message = "Error Setting RTL Altitude: \(error)"
            })
            .disposed(by: disposeBag)
    }
    
    func killAction() {
        drone?.action.kill()
            .subscribe(onCompleted: {
                MessageViewModel.shared.message = "kill action"
            }, onError: { (error) in
                MessageViewModel.shared.message = "Error kill action: \(error)"
            })
            .disposed(by: disposeBag)
    }
    
    func setTakeoffAltitudeAction() {
        
        if takeoffAltitude == 0 {
            MessageViewModel.shared.message = "Error Set Takeoff Altitude Fail"
            return
        }
        
        drone?.action.setTakeoffAltitude(altitude: takeoffAltitude)
            .subscribe(onCompleted: {
                MessageViewModel.shared.message = "Set Takeoff Altitude Success"
            }, onError: { (error) in
                MessageViewModel.shared.message = "Error Set Takeoff Altitude Fail"
            })
            .disposed(by: disposeBag);
        
        drone?.action.setMaximumSpeed(speed: 5)
            .subscribe(onCompleted: {
                print("Success")
            }, onError: { error in
                print("error")
            })
            .disposed(by: disposeBag)
    }
}
