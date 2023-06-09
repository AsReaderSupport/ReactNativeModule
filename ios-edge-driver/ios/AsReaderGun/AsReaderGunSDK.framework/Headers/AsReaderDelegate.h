#ifndef RFBlasterDemo_Header_h
#define RFBlasterDemo_Header_h

#import "AsRfidValues.h"
#import "AsPacket.h"
#import "AsBarcodeType.h"

#define REMOTE_KEY_UP           0
#define REMOTE_KEY_DOWN         1

@class AsReader;
@protocol AsReaderDelegate <NSObject>

@optional
- (void)readerInitialized:(AsReader *)reader;
- (void)updateDeviceState:(ResultCode)error;
- (void)readTag:(NSString *)tag rssi:(float)rssi phase:(float)phase frequency:(float)frequency;
- (void)changedActionState:(CommandType)action resultCode:(NSInteger)resultCode;
- (void)detectBarcode:(BarcodeType)barcodeType codeId:(NSString *)codeId barcode:(NSString *)barcode;
- (void)detectBarcode:(BarcodeType)barcodeType codeId:(NSString *)codeId barcodeData:(NSData *)barcodeData;

- (void)accessResult:(ResultCode)error actionState:(CommandType)action epc:(NSString *)epc data:(NSString *)data rssi:(float)rssi phase:(float)phase frequency:(float)frequency;
- (void)readTagWithTid:(ResultCode)error actionState:(CommandType)action epc:(NSString *)epc tid:(NSString *)data rssi:(float)rssi phase:(float)phase frequency:(float)frequency;

- (void)commandComplete:(CommandType)command;

- (void)onModuleOverHeated;
- (void)onResetReader;

- (BOOL)onAsReaderLeftModeKeyEvent:(BOOL)status;
- (BOOL)onAsReaderRightModeKeyEvent:(BOOL)status;
- (BOOL)onAsReaderTriggerKeyEvent:(BOOL)status;
- (void)readTagWithRFM:(ResultCode)error actionState:(CommandType)action epc:(NSString *)epc rssi:(float)rssi phase:(float)phase frequency:(float)frequency tid:(NSString *)tid temCode:(NSString*)tempCode calibaration:(NSString*)calibration sensorCode:(NSString*)sensorCode;

@end

#endif
