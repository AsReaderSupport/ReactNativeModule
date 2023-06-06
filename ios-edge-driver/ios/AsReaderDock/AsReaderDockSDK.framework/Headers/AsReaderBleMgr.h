#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AsReaderProtocol.h"


@interface AsReaderBleMgr : NSObject
@property (nonatomic, weak) id<AsReaderProtocol> delegate;
//BLE 스탠시작
- (BOOL) scanBLE;
- (BOOL) stopSacnBLE;

//발견한 주변 기기목록
+ (instancetype) sharedInstance;
-(NSArray *) getPreripheralList;
- (BOOL) open;
- (BOOL) isOpened;
- (void) close;
- (BOOL) send:(NSData*)data;
- (BOOL) sendPower:(NSData*)data;
- (void) connectBLE:(NSString *)name;
@end

