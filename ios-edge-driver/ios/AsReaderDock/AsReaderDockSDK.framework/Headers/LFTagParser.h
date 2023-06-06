//
//  LFTagParser.h
//  DockSDK
//
//  Created by Y.Oshiro on 2021/09/03.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ProtocolTypeLF) {
    ProtocolTypeLF_FDBX = 0
};

#define Key_FDBX_NationalCode @"Key_FDBX_NationalCode"
#define Key_FDBX_CountryCode @"Key_FDBX_CountryCode"
#define Key_FDBX_StatusFlag @"Key_FDBX_StatusFlag"
#define Key_FDBX_AnimalIndicator @"Key_FDBX_AnimalIndicator"
#define Key_FDBX_Reserved @"Key_FDBX_Reserved"

@interface LFTagParser : NSObject
+ (instancetype)sharedInstance;

- (NSDictionary *)parseDataByProtocolType:(NSData *)data protocolType:(ProtocolTypeLF)protocolType;
@end

NS_ASSUME_NONNULL_END
