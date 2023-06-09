#import <Foundation/Foundation.h>

typedef enum {
    BarcodeTypeNoRead,
    BarcodeTypeAustralianPost,
    BarcodeTypeAztecCode,
    BarcodeTypeBooklandEAN,
    BarcodeTypeBritishPost,
    BarcodeTypeCanadianPost,
    BarcodeTypeChinaPost,
    BarcodeTypeCodabar,
    BarcodeTypeCodablockF,
    BarcodeTypeCode11,
    BarcodeTypeCode128,
    BarcodeTypeCode16K,
    BarcodeTypeCode32,
    BarcodeTypeCode39,
    BarcodeTypeCode49,
    BarcodeTypeCode93,
    BarcodeTypeComposite,
    BarcodeTypeD2of5,
    BarcodeTypeDataMatrix,
    BarcodeTypeEAN128,
    BarcodeTypeEAN13,
    BarcodeTypeEAN13CouponCode,
    BarcodeTypeEAN8,
    BarcodeTypeI2of5,
    BarcodeTypeIATA,
    BarcodeTypeISBT128,
    BarcodeTypeISBT128Concat,
    BarcodeTypeJapanesePost,
    BarcodeTypeKixPost,
    BarcodeTypeKoreaPost,
    BarcodeTypeMacroMicroPDF,
    BarcodeTypeMaxiCode,
    BarcodeTypeMicroPDF,
    BarcodeTypeMSI,
    BarcodeTypeMultipacketFormat,
    BarcodeTypeOCR,
    BarcodeTypeParameterFNC3,
    BarcodeTypePDF417,
    BarcodeTypePlanetCode,
    BarcodeTypePlesseyCode,
    BarcodeTypePosiCode,
    BarcodeTypePostnet,
    BarcodeTypeQRCode,
    BarcodeTypeR2of5,
    BarcodeTypeGS1DataBar,
    BarcodeTypeGS1128,
    BarcodeTypeScanletWebcode,
    BarcodeTypeTelepen,
    BarcodeTypeTLC39,
    BarcodeTypeTriopticCode,
    BarcodeTypeUPCA,
    BarcodeTypeUPCE,
    BarcodeTypeVeriCode,
    BarcodeTypeX2of5,
    BarcodeTypeRSSLimited,
    BarcodeTypeChineseSensible,
    BarcodeTypeCodablockA,
    BarcodeTypeInfoMail,
    BarcodeTypeIntelligentMailBarCode,
    BarcodeTypePostal4i,
    BarcodeTypeNEC2of5,
    BarcodeTypeRSSExpanded
} BarcodeType;

@interface AsBarcodeType : NSObject
+ (BarcodeType)getBarcodeType:(unsigned char)byte;
+ (BarcodeType)getNotRFPRISMABarcodeType:(unsigned char)byte;
+ (NSString *)getBarcodeString:(BarcodeType)barcodeType;
@end
