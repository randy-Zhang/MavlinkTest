//
//  DemoUtils.swift
//  AliyunLogSwift
//
//  Created by gordon on 2021/12/17.
//

import Foundation

class DemoUtils {

    static let shared = DemoUtils()
    
    var endpoint = "cn-qingdao.log.aliyuncs.com"
    var project = "test-back"
    var logstore = "test-back-lg-1"
    var accessKeyId = ""
    var accessKeySecret = ""
    var pluginAppId = ""
    var securityToken = ""
    
    
    private init() {}
    
}
