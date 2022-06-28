//
//  LogManager.swift
//  MAVSDK_Swift_Example
//
//  Created by 云世纪 on 2022/6/28.
//

import UIKit
import Alamofire
import CommonCrypto
import AliyunLogProducer

class LogManager: NSObject {

    static let shared = LogManager()
    
    var client:     LogProducerClient!
    let utils = DemoUtils.shared
    
    func requestLogConfig() {

        let now = Date()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        
        let signStr = "166eecbb4ea54ed2a3a6272863f3ad82\(millisecond)319bcd7267a44f9280be2762bb1b3139"
        
        let sign = signStr.md5
        
        print("millisecond: \(millisecond), sign: \(sign)")
        
        AF.request("http://api-dev.findmaster.cn:13389/api/aliSls/third/getLogSTS", method: .get, parameters: ["key": "166eecbb4ea54ed2a3a6272863f3ad82", "sign": sign, "timestamp": millisecond]).responseJSON { response in

            switch response.result{
            case .success(let json):
                    print("json:\(json)")
                
                if let dic = json as? [String: Any] {
                    
                    let jsonString: String? = dic["ResultExt"] as? String
                    let data: Data? = jsonString?.data(using: .utf8)
                    let jsonNew = (try? JSONSerialization.jsonObject(with: data ?? Data(), options: [])) as? [String:AnyObject]
                     print(jsonNew ?? "Empty Data")
                    
                    self.utils.securityToken = jsonNew?["securityToken"] as! String
                    self.utils.accessKeyId = jsonNew?["accessKeyId"] as! String
                    self.utils.accessKeySecret = jsonNew?["accessKeySecret"] as! String
                    
                    self.configAliyunLog()
                }
                
                    break
                case .failure(let error):
                    print("error:\(error)")
                    break
            }
        }
    }
    
    func configAliyunLog() {
        
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = file! + "/log.dat"
    
        // 指定sts token 创建config，过期之前调用ResetSecurityToken重置token
        let config = LogProducerConfig(endpoint: self.utils.endpoint, project: self.utils.project, logstore: self.utils.logstore, accessKeyID: self.utils.accessKeyId, accessKeySecret: self.utils.accessKeySecret, securityToken: self.utils.securityToken)!
        
        // 设置主题
        config.setTopic("test_topic")
        // 设置tag信息，此tag会附加在每条日志上
        config.addTag("test", value:"iOS Mavlink 测试App")
        // 每个缓存的日志包的大小上限，取值为1~5242880，单位为字节。默认为1024 * 1024
        config.setPacketLogBytes(1024*1024)
        // 每个缓存的日志包中包含日志数量的最大值，取值为1~4096，默认为1024
        config.setPacketLogCount(1024)
        // 被缓存日志的发送超时时间，如果缓存超时，则会被立即发送，单位为毫秒，默认为3000
        config.setPacketTimeout(3000)
        // 单个Producer Client实例可以使用的内存的上限，超出缓存时add_log接口会立即返回失败
        // 默认为64 * 1024 * 1024
        config.setMaxBufferLimit(64*1024*1024)
        // 发送线程数，默认为1
        config.setSendThreadCount(1)
        
        // 1 开启断点续传功能， 0 关闭
        // 每次发送前会把日志保存到本地的binlog文件，只有发送成功才会删除，保证日志上传At Least Once
        config.setPersistent(1)
        // 持久化的文件名，需要保证文件所在的文件夹已创建。
        config.setPersistentFilePath(path)
        // 是否每次AddLog强制刷新，高可靠性场景建议打开
        config.setPersistentForceFlush(1)
        // 持久化文件滚动个数，建议设置成10。
        config.setPersistentMaxFileCount(10)
        // 每个持久化文件的大小，建议设置成1-10M
        config.setPersistentMaxFileSize(1024*1024)
        // 本地最多缓存的日志数，不建议超过1M，通常设置为65536即可
        config.setPersistentMaxLogCount(65536)
        
        //网络连接超时时间，整数，单位秒，默认为10
        config.setConnectTimeoutSec(10)
        //日志发送超时时间，整数，单位秒，默认为15
        config.setSendTimeoutSec(10)
        //flusher线程销毁最大等待时间，整数，单位秒，默认为1
        config.setDestroyFlusherWaitSec(2)
        //sender线程池销毁最大等待时间，整数，单位秒，默认为1
        config.setDestroySenderWaitSec(2)
        //数据上传时的压缩类型，默认为LZ4压缩， 0 不压缩，1 LZ4压缩， 默认为1
        config.setCompressType(1)
        //设备时间与标准时间之差，值为标准时间-设备时间，一般此种情况用户客户端设备时间不同步的场景
        //整数，单位秒，默认为0；比如当前设备时间为1607064208, 标准时间为1607064308，则值设置为 1607064308 - 1607064208 = 100
        config.setNtpTimeOffset(1)
        //日志时间与本机时间之差，超过该大小后会根据 `drop_delay_log` 选项进行处理。
        //一般此种情况只会在设置persistent的情况下出现，即设备下线后，超过几天/数月启动，发送退出前未发出的日志
        //整数，单位秒，默认为7*24*3600，即7天
        config.setMaxLogDelayTime(7*24*3600)
        //对于超过 `max_log_delay_time` 日志的处理策略
        //0 不丢弃，把日志时间修改为当前时间; 1 丢弃，默认为 1 （丢弃）
        config.setDropDelayLog(1)
        //是否丢弃鉴权失败的日志，0 不丢弃，1丢弃
        //整数，默认为 0，即不丢弃
        config.setDropUnauthorizedLog(0)
        //注册 获取服务器时间 的函数
        config.setGetTimeUnixFunc({ () -> UInt32 in
            let time = Date().timeIntervalSince1970
            return UInt32(time);
        })
        
        let callbackFunc: on_log_producer_send_done_function = {config_name,result,log_bytes,compressed_bytes,req_id,error_message,raw_buffer,user_param in
            let res = LogProducerResult(rawValue: Int(result))
//            print(res!)
//            let reqId = req_id == nil ? "":String(cString: req_id!)
//            print(reqId)
//            let errorMessage = error_message == nil ? "" : String(cString: error_message!)
//            print(errorMessage)
//            print(log_bytes)
//            print(compressed_bytes)
        }
        client = LogProducerClient(logProducerConfig:config, callback:callbackFunc)
        
        self.sendOneLog()
    }
    
    func sendOneLog(_ params: [String: String]? = nil) {
        let log = getOneLog()
        if let logParams = params {
            log.putContents(logParams)
        }
        let res = client?.add(log, flush:1)
        print("log是否发送\(res!)")
    }
    
    func getOneLog() -> Log {
        let infoDictionary = Bundle.main.infoDictionary
        let appDisplayName: AnyObject? = infoDictionary!["CFBundleDisplayName"] as AnyObject //程序名称
        let majorVersion: AnyObject? = infoDictionary!["CFBundleShortVersionString"] as AnyObject//主程序版本号
        let minorVersion: AnyObject? = infoDictionary!["CFBundleVersion"] as AnyObject//版本号（内部标示）
        
        
        
        let log = Log()
        let logTime = Date().timeIntervalSince1970
        log.setTime(useconds_t(logTime))
        log.putContents(["app_id": "iOS_com.yunshiji.MAVSDKExample"])
        log.putContents(["app_name": appDisplayName!,
                         "app_version": "\(majorVersion!)|build:(\(minorVersion!))",
                         "record": getCurrentTime()])
        return log
    }
    
    func getCurrentTime() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let timezone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timezone
        let dateTime = formatter.string(from: Date.init())
        return dateTime
    }
}

extension String {
    
    //用法
    //let md5 =  "Some thing".md5
 
    //如果需要小写，将"%02X"改成"%02x"
    
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}
