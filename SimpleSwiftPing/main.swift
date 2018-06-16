/*
 * main.swift
 * SimpleSwiftPing
 *
 * Created by François Lamboley on 13/06/2018.
 * Copyright © 2018 Frizlab. All rights reserved.
 */

import Foundation



class PingDelegate : SimplePingDelegate {
	
	func simplePing(_ pinger: SimplePing, didStart address: Data) {
		print("ping start with address" + address.reduce("", { $0 + " " + String($1) }))
		pinger.sendPing(data: nil)
	}
	
	func simplePing(_ pinger: SimplePing, didFail error: Error) {
		print("ping failed with error \(error)")
	}
	
	func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
		print("ping did send packet (sequence number \(sequenceNumber)): \(packet.reduce("", { $0 + String(format: "%02x", $1) }))")
	}
	
	func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
		print("ping did fail to send packet (sequence number \(sequenceNumber)) with error \(error). Packet: \(packet.reduce("", { $0 + String(format: "%02x", $1) }))")
	}
	
	func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
		print("ping did receive ping response packet (sequence number \(sequenceNumber)): \(packet.reduce("", { $0 + String(format: "%02x", $1) }))")
	}
	
	func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
		print("ping did receive unexpected packet: \(packet.reduce("", { $0 + String(format: "%02x", $1) }))")
	}
	
}

autoreleasepool{
	var delegate: PingDelegate? = PingDelegate()
	var p: SimplePing? = SimplePing(hostName: "9.9.9.9")
	p?.delegate = delegate
	p?.start()
	
	var i = 0
	repeat {
		i += 1
		RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
	} while i < 2
	
	p?.stop()
	
	delegate = nil
	p = nil
}
