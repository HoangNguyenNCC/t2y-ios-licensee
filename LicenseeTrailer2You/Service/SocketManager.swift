//
//  SocketManager.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 10/07/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string: "https://t2ybeta.herokuapp.com")!,config: [.log(true)])
    var socket : SocketIOClient!
    
    override init() {
        super.init()
        self.socket = manager.defaultSocket
        self.socket.connect()
    }
    
    func connect(_ invoice : String){
        self.socket.on(clientEvent: .connect) { (data, ack) in
            print("socket connected")
            
            let data = CustomData(invoiceNumber: invoice)
                        
            let myData = try! JSONEncoder().encode(data)
            
            print(invoice)
            
            
            self.socket.emit("licenseeJoin", myData){
                print("YOLO")
            }
        }
    }
    
    func sendLocation(_ location : locationData){
        //let data2 = locationData(invoiceNumber: "5f0857120629370017b23f8d", lat: "19.082903", long: "72.850522")
        let data = location
        let myData = try! JSONEncoder().encode(data)
        self.socket.emit("licenseeLocation", myData) {
            print("location sent")
        }
    }
    
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}


struct CustomData : SocketData, Codable {
    let invoiceNumber: String
    
    func socketRepresentation() -> SocketData {
        return ["invoiceNumber": invoiceNumber]
    }
}

struct locationData :  Codable {
    let invoiceNumber: String
    let lat: String
    let long : String
}
