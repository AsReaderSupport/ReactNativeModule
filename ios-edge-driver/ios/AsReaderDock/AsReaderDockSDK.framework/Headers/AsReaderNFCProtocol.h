//
//  AsReaderNFCProtocol.h
//  AsReaderDockSDK
//
//  Created by mac on 2017/9/7.
//  Copyright © 2017年 ZYL. All rights reserved.
//

/**
 本メソッドはISO15693のタグだけに適用します。
 */
typedef NS_ENUM(NSUInteger, SDK4StatusCode) {
    SDK4_STS_OK = 0x00,              //正常終了
    SDK4_STS_TIME_OVR = 0x02,        //タイムオーバー 規定時間内にタグとの通信が正常終了しなかった
    SDK4_STS_ERR = 0x07,             //コマンド実行エラー
    SDK4_STS_ERR_WRITE = 0x09,       //タグへの書き込みが不完全
    SDK4_STS_PROTECT_OPERATE = 0x0A, //保護回路動作
    SDK4_STS_DATANUM_ERR = 0x41,
    SDK4_STS_SUM_ERR = 0x42,         //SUM の値が不正です
    SDK4_STS_CMD_ERR = 0x44,         //コマンドまたはパラメータが不正です
    SDK4_STS_ADRS_ERR = 0x49,        //指定アドレスのデバイスが存在しない
    SDK4_STS_RDM_BLOCKS_ERR = 0x4C,  //読出しブロック数が最大ブロック数を超えている
    SDK4_STS_NO_UID = 0x4D,          //UID 無し
    SDK4_STS_UID_POS_ERR = 0x4E,     //UID 取得開始位置エラー
    SDK4_STS_UID_NUM_ERR = 0x4F,     //取得 UID 数エラー
    SDK4_STS_SYSTEM_ERR = 0xF1,      //システムエラー
};

#ifndef AsReaderNFCProtocol_h
#define AsReaderNFCProtocol_h


#endif /* AsReaderNFCProtocol_h */

@protocol AsReaderNFCDeviceDelegate <NSObject>

@required

@optional

/**
 *  @brief      Function that is called when a tag’s data is received (nfc type)
 *  @param      data : Data of nfc tag read
 */
- (void)nfcDataReceived:(NSData *)data;

/**
 *  @brief      Response to "readMultiBlockWithBlockIndex".
 *  @param      dataArray : NFC tag data that is read.
 *  @param      statusCode : SDK4StatusCode. Error status code will be returned if statusCode is not SDK4_STS_OK. In this case, dataArray is set to null
 */
- (void)nfcReadMultiBlockReceived:(NSArray *)dataArray
                       statusCode:(SDK4StatusCode)statusCode;

/**
 *  @brief      Response to "writeSingleBlockWithBlockIndex".
 *  @param      statusCode : SDK4StatusCode. Error status code will be returned if statusCode is not SDK4_STS_OK.
 */
- (void)nfcWriteSingleBlockStatusCode:(SDK4StatusCode)statusCode;

/**
 *  @brief      Response to "writeBytesWithBlockIndex".
 *  @param      statusCode : SDK4StatusCode. Error status code will be returned if statusCode is not SDK4_STS_OK.
 */
- (void)nfcWriteBytesStatusCode:(SDK4StatusCode)statusCode;

@end
