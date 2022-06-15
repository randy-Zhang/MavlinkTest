//
//  CameraSettingsViewModel.swift
//  Mavsdk-Swift-Example
//
//  Created by Dmytro Malakhov on 7/16/21.
//

import Foundation
import RxSwift
import Mavsdk

final class CameraSettingsViewModel: ObservableObject {
    let drone = mavsdkDrone.drone
    let disposeBag = DisposeBag()
    
    @Published private(set) var currentSettings: [Camera.Setting] = []
    @Published private(set) var settingOptions: [Camera.SettingOptions] = []
    
    init() {
        observeCameraSettings()
    }
    
    func settingOptions(_ setting: Camera.Setting) -> Camera.SettingOptions? {
        return settingOptions.filter { $0.settingID == setting.settingID }.first
    }
    
    func observeCameraSettings() {
        drone?.camera.currentSettings
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (currentSettings) in
                self?.currentSettings = currentSettings
            })
            .disposed(by: disposeBag)

        drone?.camera.possibleSettingOptions
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (possibleSettingOptions) in
                self?.settingOptions = possibleSettingOptions
            })
            .disposed(by: disposeBag)
    }
    
    func setCameraSetting(_ setting: Camera.Setting, option: Camera.Option) {
        let newSetting = Camera.Setting(settingID: setting.settingID,
                                        settingDescription: setting.settingDescription,
                                        option: option,
                                        isRange: setting.isRange)
        
        drone?.camera.setSetting(setting: newSetting)
            .subscribe(on: MavScheduler)
            .observe(on: MainScheduler.instance)
            .subscribe {
                MessageViewModel.shared.message = "Set Camera Setting \(newSetting.settingDescription) to \(newSetting.option.optionDescription)"
            } onError: { (error) in
                MessageViewModel.shared.message = "Error Setting Camera Setting: \(error)"
            }
            .disposed(by: disposeBag)
    }
}
