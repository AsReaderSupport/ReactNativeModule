//
//  AsReaderBLEProtocol.h
//  AsReaderDockSDK
//
//  Created by MRX_ZYL on 27/1/2021.
//  Copyright © 2021 ZYL. All rights reserved.
//

#ifndef AsReaderBLEProtocol_h
#define AsReaderBLEProtocol_h
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, BleStatusCode) {
    BLE_STS_SCANNING = 0x00,
    BLE_STS_SCAN_STOP = 0x01,
};
@protocol AsReaderBLEDelegate <NSObject>
@optional
- (void)scanningBleDeive:(CBPeripheral*)device;
- (void)scanBleStatus:(BleStatusCode)status;
@end

#endif /* AsReaderBLEProtocol_h */
