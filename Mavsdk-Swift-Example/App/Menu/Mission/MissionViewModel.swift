//
//  MissionViewModel.swift
//  Mavsdk-Swift-Example
//
//  Created by Douglas on 21/05/21.
//

import Foundation
import RxSwift
import Mavsdk

final class MissionViewModel: ObservableObject {
    let missionOperator: MissionOperator
    let drone = mavsdkDrone.drone!
    let disposeBag = DisposeBag()
    
    var actions: [Action] {
        return [
            Action(text: "Upload Mission", action: uploadMission),
            Action(text: "Cancel Mission Upload", action: cancelUpload),
            Action(text: "Start Mission", action: startMission),
            Action(text: "Arm & Start Mission", action: armAndStartMission),
            Action(text: "Pause Mission", action: pauseMission),
            Action(text: "Set Mission Index", action: setIndex),
            Action(text: "Download Mission", action: downloadMission),
            Action(text: "Cancel Mission Download", action: cancelMissionDownload),
            Action(text: "Clear Mission", action: clearMission),
            Action(text: "Enable RTL After Mission", action: enableRTLAfterMission),
            Action(text: "Disable RTL After Mission", action: disableRTLAfterMission),
            Action(text: "Get RTL After Mission", action: getRTLAfterMission),
            Action(text: "Is Mission Finished", action: isMissionFinished),
            Action(text: "Gimbal transform", action: gimbalTransform),
            Action(text: "Gimbal reset", action: gimbalReset)
        ]
    }
    
    init(missionOperator: MissionOperator) {
        self.missionOperator = missionOperator
    }
    
    func uploadMission() {
        guard let missionPlan = missionOperator.currentMissionPlan else {
            MessageViewModel.shared.message = "No mission selected to upload"
            return
        }
        
        drone.mission.uploadMission(missionPlan: missionPlan)
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .do(onError: { (error) in
                MessageViewModel.shared.message = "Error Uploading Mission \(error)"
            }, onCompleted: {
                MessageViewModel.shared.message = "Mission Uploaded"
            }, onSubscribe: {
                MessageViewModel.shared.message = "Uploading Mission"
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func cancelUpload() {
        drone.mission.cancelMissionUpload()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "Cancelled Mission Upload"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Cancelling Mission Upload \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func startMission() {
        drone.mission.startMission()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "Mission Started"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Starting Mission \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func armAndStartMission() {
        drone.action.arm()
            .andThen(drone.mission.startMission())
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "Mission Started"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Starting Mission \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func pauseMission() {
        drone.mission.pauseMission()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "Mission Paused"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Pausing Mission \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func setIndex() {
        drone.mission.setCurrentMissionItem(index: 0)
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "Current Index Set to 0"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Setting Current Index \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func downloadMission() {
        drone.mission.downloadMission()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .do(onSuccess: {  [weak self] (mission) in
                MessageViewModel.shared.message = "Mission Downloaded with \(mission.missionItems.count) Items"
                self?.missionOperator.addDownloadedMission(plan: mission)
            }, onError: { (error) in
                MessageViewModel.shared.message = "Error Downloading Mission \(error)"
            },  onSubscribe: {
                MessageViewModel.shared.message = "Downloading Mission"
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func cancelMissionDownload() {
        drone.mission.cancelMissionDownload()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "Cancelled Mission Download"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Cancelling Mission Download \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func clearMission() {
        drone.mission.clearMission()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                MessageViewModel.shared.message = "Mission Cleared"
                self?.missionOperator.removeDownloaededMissionPlan()
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Clearing Mission \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func enableRTLAfterMission() {
        drone.mission.setReturnToLaunchAfterMission(enable: true)
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "RTL After Mission Enabled"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Enabling RTL After Mission \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func disableRTLAfterMission() {
        drone.mission.setReturnToLaunchAfterMission(enable: false)
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "RTL After Mission Disabled"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Disabling RTL After Mission \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func getRTLAfterMission() {
        drone.mission.getReturnToLaunchAfterMission()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe { value in
                MessageViewModel.shared.message = "RTL After Mission Set To \(value)"
            } onFailure: { (error) in
                MessageViewModel.shared.message = "Error Getting RTL After Mission \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func isMissionFinished() {
        drone.mission.isMissionFinished()
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe { value in
                MessageViewModel.shared.message = value ? "Mission Finished" : "Mission Not Finished"
            } onFailure: { (error) in
                MessageViewModel.shared.message = "Error Getting Mission Finished \(error)"
            }
            .disposed(by: disposeBag)
    }
    
    func gimbalTransform() {
        
        let pitchDeg: Float = Float(arc4random() % 90)
        let yawDeg: Float = Float(arc4random() % 360)  - 180
        print("云台转动角度 pitch:\(-pitchDeg), yaw:\(yawDeg)")
        drone.gimbal.setPitchAndYaw(pitchDeg: -pitchDeg, yawDeg: yawDeg)
            .subscribe(on: MavScheduler)
            .subscribe(on: MainScheduler.instance)
            .subscribe {
                print("旋转云台成功")
            } onError: { error in
                print("旋转云台失败 \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
    
    func gimbalReset() {
        
        drone.gimbal.setPitchAndYaw(pitchDeg: 0, yawDeg: 0)
            .subscribe(on: MavScheduler)
            .subscribe(on: MainScheduler.instance)
            .subscribe {
                print("旋转云台成功")
            } onError: { error in
                print("旋转云台失败 \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
}
