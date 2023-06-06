# ios-edge-driver

## Getting started

https://xemelgo.atlassian.net/wiki/spaces/XENG/pages/1479081987/Edge+Architecture+Design+for+iOS

`npm install @xemelgo/ios-edge-driver`
`pod install`

For AsReaderDock, in the project's build phases, add ExternalAccessory.framework in Link Binray with Binaries

For the ASR-0230D, add jp.co.asx.asreader.0240D as a supported external accessory protocol in the project's info.plist

## Usage

```javascript
import { NativeEventEmitter, NativeModules } from "react-native";
const { RNReaderModule } = NativeModules;

const events = new NativeEventEmitter(RNReaderModule);
events.addListener("rfidRead", (tagData) => {
  console.log(tagData.epc, tagData.rssi, tagData.tagCount);
});

await RNReaderModule.loadDriver({
  vendor: "AsReader",
  model: "ASR-0230D",
  modelType: "ASR-0230D",
});
await RNReaderModule.connect("localhost");
await RNReaderModule.switchToScanRfidMode();
```
