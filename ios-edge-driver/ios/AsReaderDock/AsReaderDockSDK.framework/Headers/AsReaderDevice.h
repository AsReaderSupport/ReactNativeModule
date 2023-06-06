//
//  RcpApi.h

#import <Foundation/Foundation.h>
#import "AsReaderRFIDProtocol.h"
#import "AsReaderBarcodeProtocol.h"
#import "AsReaderNFCProtocol.h"
#import "AsReaderDeviceProtocol.h"

@class UartMgr;
@interface AsReaderDevice : NSObject
//*******************************************************************************//
//  Common API (RFID, NFC, Barcode)
//  This function can use all device
//*******************************************************************************//

+ (NSString *)getSDKVersion;

+ (void)showPrintNSLog:(BOOL)isShow;

+ (void)setTriggerModeDefault:(BOOL)isDefault;

+ (void)setReadRSSIMode:(BOOL)isReadRSSIMode;
/**
 *  @brief      Send the "Get Reader Information" and "Get Region" command to the reader
 *  @return     Returns FALSE if selected mode of reader is not RFID, YES otherwise
 */
- (BOOL)getReaderInformation;

/**
 *  @brief      Send the "Get Reader Information" command to the reader
 *  @details    Get basic information from the reader.
 *  @param      infoType : model(0x00), RFID Version(0x01), Manufacturer(0x02), Frequency(0x03), Tag Type(0x04)
 *  @return     Returns NO if selected mode of reader is not RFID, YES otherwise
 */
- (BOOL)getReaderInfo:(int)infoType;

/**
 *  @brief      Get current battery level
 *  @return     Returns battery level
 */
- (int)getCurrentBattery;

/**
 *  @brief      Send the "setting" command to the reader
 *  @details    Setting when reading a tag. Can set beep, vibration, illumination, led.
 *  @param      beepOn : On(1), Off(0)
 *  @param      vibrationOn : On(1), Off(0)
 *  @param      illuminationOn : On(1), Off(0)
 *  @param      led : On(1), Off(0)
 *  @return     YES
 */
- (BOOL)setBeep:(BOOL)beepOn setVibration:(BOOL)vibrationOn setIllumination:(BOOL)illuminationOn setLED:(BOOL)led;

/**
 *  @brief      Set reader power on/off with beep and other options.
 *  @details    Set reader power on/off with options. When set power on, beep, vibration, illumination, and led can be set at the same time.
 *  @param      isOn : On(YES), Off(NO)
 *  @param      isBeep : On(YES), Off(NO)
 *  @param      isVib : On(YES), Off(NO)
 *  @param      isLed : On(YES), Off(NO)
 *  @param      isIllu : On(YES), Off(NO)
 *  @param      nDeviceType : type of reader
 *  @return     Returns 99 if nDeviceType is unknown, 1 if a command is added to the queue.
 */
- (int)setReaderPower:(BOOL)isOn beep:(BOOL)isBeep vibration:(BOOL)isVib led:(BOOL)isLed illumination:(BOOL)isIllu mode:(int)nDeviceType;

/**
 *  @brief      Set reader power on/off with beep and other options.
 *  @details    Set reader power on/off with options. When set power on, beep, vibration, illumination, led, and PowerOnBeep can be set at the same time.
 *  @param      isOn : On(YES), Off(NO)
 *  @param      isBeep : On(YES), Off(NO)
 *  @param      isVib : On(YES), Off(NO)
 *  @param      isLed : On(YES), Off(NO)
 *  @param      isIllu : On(YES), Off(NO)
 *  @param      isConnectedBeep : On(YES), Off(NO)
 *  @param      nDeviceType : type of reader
 *  @return     Returns 99 if nDeviceType is unknown, 1 if a command is added to the queue.
 */
- (int)setReaderPower:(BOOL)isOn beep:(BOOL)isBeep vibration:(BOOL)isVib led:(BOOL)isLed illumination:(BOOL)isIllu connectedBeep:(BOOL)isConnectedBeep mode:(int)nDeviceType;

/**
 *  @brief      Send the "Set Stop Condition" command to the reader.
 *  @details    Set the stop point of start-auto-read.\n Should only be used on RFID type.
 *  @param      mtnu : Maximum number of tag to read
 *  @param      mtime : Maximum elapsed time to tagging(sec)
 *  @param      repeatCycle : How many times reader perform inventory round
 */
- (void)setTagCount:(int)mtnu
        setScanTime:(int)mtime
           setCycle:(int)repeatCycle;


- (BOOL) setChargingControl:(BOOL)isOn;


- (void) setDelayDisconnectOnBackground:(NSTimeInterval)time;

- (NSTimeInterval) getDelayDisconnectOnBackground;

/**
 *  @brief     return connection status.
 *  @return    plugged (1) , unplugged (0)
 */
- (BOOL)isOpened;

/**
 *  @brief  RFID event delegate
 *  @details Only RFID (See <AsReaderRFIDDeviceDelegate>)
 */
@property (nonatomic, weak, setter = setDelegateRFID:) id<AsReaderRFIDDeviceDelegate> delegateRFID;

/**
 *  @brief  RFID event delegate
 *  @details Only RFID (See <AsreaderBarcodeDeviceProtocol>)
 */
@property (nonatomic, weak, setter = setDelegateBarcode:) id<AsreaderBarcodeDeviceDelegate> delegateBarcode;

/**
 *  @brief  RFID event delegate
 *  @details Only RFID (See <AsReaderNFCDeviceDelegate>)
 */
@property (nonatomic, weak, setter = setDelegateNFC:) id<AsReaderNFCDeviceDelegate> delegateNFC;


/**
 *  @brief  RFID event delegate
 *  @details Device (See <AsReaderDeviceDelegate>)
 */
@property (nonatomic, weak, setter = setDelegateDevice:) id<AsReaderDeviceDelegate> delegateDevice;


@end
