//  NFCApi.h
//  Created by Robin on 2016. 5. 11..

#import "AsReaderDevice.h"

#define NFC_CMD_INVENTORYSET                {0x02, 0x00, 0x6F, 0x02, 0x03, 0xE8, 0x03,0x61, 0x0D}
#define NFC_CMD_STARTSCAN                   {0x02, 0x00, 0x4E, 0x07, 0x00, 0x51, 0x0F, 0x80, 0xFF, 0xFF, 0x00, 0x03, 0x38, 0x0D}
#define NFC_CMD_STOPSCAN                    {0x02, 0x00, 0x4E, 0x07, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x03, 0xDA, 0x0D}

@interface AsReaderNFCDevice : AsReaderDevice
+ (instancetype)sharedInstance;

/**
 *  @brief      Send the "Send Raw Data" command to the reader
 *  @details    Send "Send Raw Data" command including "sendData"
 *  @param      sendData : Byte type data
 *  @return     YES
 */
- (BOOL)sendData:(NSData *)sendData;

/**
 *  @brief      Send the "Set Inventory" command to the reader
 *  @return     YES
 */
- (BOOL)setInventoryTime:(float)inventoryTime;

/**
 *  @brief      NFC Start Scan
 *  @details    Start a tag(NFC) read operation, tag IDs are sent back to the user though notification packets.
 *  @return     YES
 */
- (BOOL)startScan;


/**
 *  @brief      NFC Stop Scan
 *  @details    Stop a read operation
 *  @return     YES
 */
- (BOOL)stopScan;

#pragma mark -- ISO15693 Function --
/**
 *  @brief      Send the "Read Multi Block" command to the reader.
 *  @details    指定された UID を持つ IC タグメモリ上の連続した複数ブロックのデータを読み出す.
 *  @param      index : 最初に読み出すブロック番号(0~255).
 *  @param      count : 読み出すブロック数(0~255).
 *  @return     YES or NO.
 */
- (BOOL)readMultiBlockWithBlockIndex:(int)index
                               count:(int)count;

/**
 *  @brief      Send the "Write Single Block" command to the reader.
 *  @details    指定された UID を持つ IC タグのメモリ上の指定したブロックへデータを書き込む.
 *  @param      index : ブロック番号(0~255).
 *  @param      writeData : 書き込むデータ(ブロックサイズが4バイトの場合).
 *  @param      uid : UID(オプションフラグの UID が「1」の時のみ付加(下位バイトから)).
 *  @return     YES or NO.
 */
- (BOOL)writeSingleBlockWithBlockIndex:(int)index
                             writeData:(NSData *)writeData
                                   uid:(NSData *)uid;

/**
 *  @brief      Send the "Write Bytes" command to the reader.
 *  @details    指定された UID を持つ指定ブロックから指定バイト数のデータを書き込む
                ※ タグへのデータの書き込みはブロック単位に行われます。 書き込むデータ長(データのバイト数)がブロックサイズに満たない場合、書き込まれる最終 ブロックのデータは、最後に「0x00」が付加され書き込まれます。
 *  @param      index : ブロック番号(0~255).
 *  @param      writeData : 書き込むデータ(ブロックサイズが4バイトの場合).
 *  @param      uid : UID(オプションフラグの UID が「1」の時のみ付加(下位バイトから)).
 *  @return     YES or NO.
 */
- (BOOL)writeBytesWithBlockIndex:(int)index
                       writeData:(NSData *)writeData
                             uid:(NSData *)uid;

@end
