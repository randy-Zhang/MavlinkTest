//
//  MissionOperator.swift
//  Mavsdk-Swift-Example
//
//  Created by Dmytro Malakhov on 7/19/21.
//

import Foundation
import Mavsdk
import MapKit

final class MissionOperator: ObservableObject {
    
    var siteScan: SiteScanMavsdk?
    
    static let shared = MissionOperator()
    
//    init() {
//        siteScan = SiteScanMavsdk()
//    }

    func subscribeToAllSiteScan() {
        siteScan = SiteScanMavsdk()
    }
    
    var missions: [Mission] = Mission.allCases
    var currentMissionPlan: Mavsdk.Mission.MissionPlan? {
        didSet {
            missionPlanCoordinates = currentMissionPlan?.missionItems
                .map{ CLLocationCoordinate2D(latitude: $0.latitudeDeg, longitude: $0.longitudeDeg) } ?? []
        }
    }
    private(set) var downloadedMissionPlan: Mavsdk.Mission.MissionPlan? {
        didSet {
            updateMissionPlan()
        }
    }

    var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 36.99350, longitude: 120.97236)
    @Published var missionPlanCoordinates = [CLLocationCoordinate2D]()
    var startCoordinate = CLLocationCoordinate2D(latitude: 36.99350, longitude: 120.97236) {
        didSet {
            updateMissionPlan()
        }
    }
    
    @Published var currentMission: Mission? {
        didSet {
            updateMissionPlan()
        }
    }
    
    func selectMission(_ mission: Mission?) {
        if currentMission == mission || mission == nil {
            currentMission = nil
            return
        }
        
        subscribeToAllSiteScan()
        
        guard let position = siteScan?.dronePosition else {
            MessageViewModel.shared.message = "No drone position"
            return
        }
        
        let droneCoord = CLLocationCoordinate2D(latitude: position.latitudeDeg, longitude: position.longitudeDeg)
        
        startCoordinate = droneCoord
        currentMission = mission
    }
    
    func updateMissionPlan() {
        print("lat: \(startCoordinate.latitude), lon: \(startCoordinate.longitude)")
        currentMissionPlan = currentMission?.missionPlan(center: startCoordinate)
    }
    
    func moveMissionPlan(to coord: CLLocationCoordinate2D) {
        startCoordinate = coord
    }
    
    func centerToMap() {
        moveMissionPlan(to: mapCenterCoordinate)
    }
    
    func addDownloadedMission(plan: Mavsdk.Mission.MissionPlan) {
        downloadedMissionPlan = plan
    }
    
    func removeDownloaededMissionPlan() {
        downloadedMissionPlan = nil
    }
}
