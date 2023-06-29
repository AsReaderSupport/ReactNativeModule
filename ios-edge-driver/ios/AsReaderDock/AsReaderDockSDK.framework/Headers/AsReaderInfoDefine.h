//
//  AsReaderInfoDefine.h
//  AsReaderDockSDK
//
//  Created by Y.Oshiro on 2021/08/30.
//  Copyright © 2021 Asterisk.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ReaderMode){
    ReaderModeUnknown = -1,
    ReaderModeBarcode = 0,
    ReaderModeRFID,
    ReaderModeNFC,
    ReaderModeDual,
    ReaderModeRFIDLF
};

typedef NS_ENUM(NSInteger, SupportType){
    SupportTypeNone = -1,
    SupportTypeBarcode = 0,
    SupportTypeRFID,
    SupportTypeNFC,
    SupportTypeDual,
    SupportTypeRFIDLF
};

typedef NS_ENUM(NSInteger, ReceiveDataType){
    ReceiveDataTypeUnknown = -1,
    ReceiveDataTypeBarcode = 0,
    ReceiveDataTypeRFID,
    ReceiveDataTypeNFC,
    ReceiveDataTypeRFIDLF
};

//#define ASREADER_DEVICE_UNKNOWN 99
//#define ASREADER_DEVICE_BARCODE 0
//#define ASREADER_DEVICE_RFID    1
//#define ASREADER_DEVICE_NFC     2
//#define ASREADER_DEVICE_LFRFID  3
//#define ASREADER_DEVICE_DUAL    4
