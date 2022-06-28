//
//  TestMissions.swift
//  Mavsdk-Swift-Example
//
//  Created by Dmytro Malakhov on 7/19/21.
//

import Foundation
import MapKit
import Mavsdk


func surveyMissionPlan(center: CLLocationCoordinate2D, gimbalPitchDeg: Float) -> Mavsdk.Mission.MissionPlan {
    let relativeAltitudeM: Float = 100
    let speedMS: Float = 4
    let isFlyThrough = false
    let loiterTimeS: Float = 0
    
    var missionItems = [Mavsdk.Mission.MissionItem]()
    var currentLocation = computeLocation(center, 10, 0)
    currentLocation = computeLocation(currentLocation, 30, 90)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .startPhotoInterval,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 3,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 270,
                                                   cameraPhotoDistanceM: 0))
    
    currentLocation = computeLocation(currentLocation, 60, 270)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .stopPhotoInterval,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 3,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 270,
                                                   cameraPhotoDistanceM: 0))
    
    currentLocation = computeLocation(currentLocation, 20, 180)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .startPhotoInterval,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 3,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 90,
                                                   cameraPhotoDistanceM: 0))
    
    currentLocation = computeLocation(currentLocation, 60, 90)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: 0, // Return gimbal to the initial position after the mission
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .stopPhotoInterval,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 3,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 90,
                                                   cameraPhotoDistanceM: 0))
    
    return Mavsdk.Mission.MissionPlan(missionItems: missionItems)
}

func surveyMissionPlanDistanceTrigger(center: CLLocationCoordinate2D) -> Mavsdk.Mission.MissionPlan {
    let relativeAltitudeM: Float = 100
    let speedMS: Float = 4
    let isFlyThrough = false
    let loiterTimeS: Float = 1
    let gimbalPitchDeg: Float = -90
    
    var missionItems = [Mavsdk.Mission.MissionItem]()
    var currentLocation = computeLocation(center, 10, 0)
    currentLocation = computeLocation(currentLocation, 50, 90)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: 5,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .startPhotoDistance,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 0,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 270,
                                                   cameraPhotoDistanceM: 20))
    
    currentLocation = computeLocation(currentLocation, 100, 270)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .stopPhotoDistance,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 0,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 270,
                                                   cameraPhotoDistanceM: 0))
    
    currentLocation = computeLocation(currentLocation, 20, 180)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: 2,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .startPhotoDistance,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 0,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 90,
                                                   cameraPhotoDistanceM: 5))
    
    currentLocation = computeLocation(currentLocation, 100, 90)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: 0, // Return gimbal to the initial position after the mission
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .stopPhotoDistance,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: 0,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 90,
                                                   cameraPhotoDistanceM: 0))
    
    return Mavsdk.Mission.MissionPlan(missionItems: missionItems)
}

func perimeterMissionPlan(center: CLLocationCoordinate2D) -> Mavsdk.Mission.MissionPlan {
    let altitudes: [Float] = [80, 100]
    let speedMS: Float = 4
    let isFlyThrough = false
    let loiterTimeS: Float = 1
    let gimbalPitchDeg: Float = -45
    
    var missionItems = [Mavsdk.Mission.MissionItem]()
    
    altitudes.forEach { (relativeAltitudeM) in
        var currentLocation = computeLocation(center, 25, 0)
        
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: gimbalPitchDeg,
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .takePhoto,
                                                       loiterTimeS: loiterTimeS,
                                                       cameraPhotoIntervalS: .nan,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 180,
                                                       cameraPhotoDistanceM: 0))
        
        currentLocation = computeLocation(currentLocation, 20, 90)
        currentLocation = computeLocation(currentLocation, 10, 180)
        
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: gimbalPitchDeg,
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .startPhotoInterval,
                                                       loiterTimeS: loiterTimeS,
                                                       cameraPhotoIntervalS: 3,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 270,
                                                       cameraPhotoDistanceM: 0))
        
        currentLocation = computeLocation(currentLocation, 40, 180)
        
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: gimbalPitchDeg,
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .stopPhotoInterval,
                                                       loiterTimeS: loiterTimeS,
                                                       cameraPhotoIntervalS: 3,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 270,
                                                       cameraPhotoDistanceM: 0))
        
        currentLocation = computeLocation(currentLocation, 20, 270)
        currentLocation = computeLocation(currentLocation, 10, 0)
        
        // Pano shot (drone stays at the same location and take photos with different yaw)
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: gimbalPitchDeg,
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .takePhoto,
                                                       loiterTimeS: 3,
                                                       cameraPhotoIntervalS: .nan,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 315,
                                                       cameraPhotoDistanceM: 0))
        
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: gimbalPitchDeg,
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .takePhoto,
                                                       loiterTimeS: 3,
                                                       cameraPhotoIntervalS: .nan,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 0,
                                                       cameraPhotoDistanceM: 0))
        
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: gimbalPitchDeg,
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .takePhoto,
                                                       loiterTimeS: 3,
                                                       cameraPhotoIntervalS: .nan,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 45,
                                                       cameraPhotoDistanceM: 0))
        // Pano shot
        
        
        currentLocation = computeLocation(currentLocation, 20, 270)
        currentLocation = computeLocation(currentLocation, 10, 180)
        
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: gimbalPitchDeg,
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .startPhotoInterval,
                                                       loiterTimeS: loiterTimeS,
                                                       cameraPhotoIntervalS: 3,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 90,
                                                       cameraPhotoDistanceM: 0))
        
        currentLocation = computeLocation(currentLocation, 40, 0)
        
        missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                       longitudeDeg: currentLocation.longitude,
                                                       relativeAltitudeM: relativeAltitudeM,
                                                       speedMS: speedMS,
                                                       isFlyThrough: isFlyThrough,
                                                       gimbalPitchDeg: 0, // Return gimbal to the initial position after the mission
                                                       gimbalYawDeg: 0,
                                                       cameraAction: .stopPhotoInterval,
                                                       loiterTimeS: loiterTimeS,
                                                       cameraPhotoIntervalS: 3,
                                                       acceptanceRadiusM: .nan,
                                                       yawDeg: 90,
                                                       cameraPhotoDistanceM: 0))
    }
    
    
    return Mavsdk.Mission.MissionPlan(missionItems: missionItems)
}

func orbitVideoMissionPlan(center: CLLocationCoordinate2D) -> Mavsdk.Mission.MissionPlan {
    let relativeAltitudeM: Float = 100
    let speedMS: Float = 4
    let isFlyThrough = true
    let loiterTimeS: Float = .nan
    let gimbalPitchDeg: Float = -45
    
    var missionItems = [Mavsdk.Mission.MissionItem]()
    
    var currentLocation = computeLocation(center, 25, 0)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .startVideo,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: .nan,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 225,
                                                   cameraPhotoDistanceM: .nan))
    
    currentLocation = computeLocation(currentLocation, 25, 90)
    currentLocation = computeLocation(currentLocation, 25, 180)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .none,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: .nan,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 225,
                                                   cameraPhotoDistanceM: 0))
    
    currentLocation = computeLocation(currentLocation, 25, 180)
    currentLocation = computeLocation(currentLocation, 25, 270)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: gimbalPitchDeg,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .none,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: .nan,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 315,
                                                   cameraPhotoDistanceM: 0))
    
    currentLocation = computeLocation(currentLocation, 25, 0)
    currentLocation = computeLocation(currentLocation, 25, 270)
    
    missionItems.append(Mavsdk.Mission.MissionItem(latitudeDeg: currentLocation.latitude,
                                                   longitudeDeg: currentLocation.longitude,
                                                   relativeAltitudeM: relativeAltitudeM,
                                                   speedMS: speedMS,
                                                   isFlyThrough: isFlyThrough,
                                                   gimbalPitchDeg: 0,
                                                   gimbalYawDeg: 0,
                                                   cameraAction: .stopVideo,
                                                   loiterTimeS: loiterTimeS,
                                                   cameraPhotoIntervalS: .nan,
                                                   acceptanceRadiusM: .nan,
                                                   yawDeg: 45,
                                                   cameraPhotoDistanceM: 0))
    
    
    return Mavsdk.Mission.MissionPlan(missionItems: missionItems)
}

private func computeLocation(_ coordinate: CLLocationCoordinate2D, _ radius: Double, _ bearing: Double) -> CLLocationCoordinate2D {
    let earthRadius: Double = 6371000
    let bearingRadius: Double = ((.pi * bearing) / 180)
    let latitudeRadius: Double = ((.pi * (coordinate.latitude)) / 180)
    let longitudeRadius: Double = ((.pi * (coordinate.longitude)) / 180)

    let computedLatitude: Double = asin(sin(latitudeRadius) * cos(radius / earthRadius) + cos(latitudeRadius) * sin(radius / earthRadius) * cos(bearingRadius))
    let computedLongitude: Double = longitudeRadius + atan2(sin(bearingRadius) * sin(radius / earthRadius) * cos(latitudeRadius), cos(radius / earthRadius) - sin(latitudeRadius) * sin(computedLatitude))

    let computedLoc = CLLocationCoordinate2D(latitude: ((computedLatitude) * (180.0 / .pi)), longitude: ((computedLongitude) * (180.0 / .pi)))

    return computedLoc
}
