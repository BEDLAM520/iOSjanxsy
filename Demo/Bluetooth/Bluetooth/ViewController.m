//
//  ViewController.m
//  Bluetooth
//
//  Created by liaonaigang on 2017/3/1.
//  Copyright © 2017年 gangnailiao. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>


static NSString * const kServiceUUID = @"38E5979ED-9933-4FDC-B356-E199E76ECC81";
static NSString * const kCharacteristicUUID = @"B1854722-A0A5-45B1-9923-1382E63EE63E";


@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)CBMutableCharacteristic *customCharacteristic;
@property (nonatomic,strong)CBCentralManager *manager;
@property (nonatomic,strong)CBMutableService *customService;
@property (strong, nonatomic)CBPeripheralManager *peripheralManager;/* 外围设备管理器 */
@property (nonatomic,strong)NSMutableArray *deviceArray;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"---");
    });
    
//    self.deviceArray = [NSMutableArray new];
//    self.tableview.delegate = self;
//    self.tableview.dataSource = self;
//    
//    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
}


#pragma mark - tableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *dict = self.deviceArray[indexPath.row];
    CBPeripheral *peripherl = dict[@"peripheral"];
    cell.textLabel.text = peripherl.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Sign:%@",dict[@"RSSI"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [self.deviceArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = dict[@"peripheral"];
    
    // 连接某个蓝牙外设
    [self.manager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@(YES)}];
    
    // 设置外设的代理是为了后面查询外设的服务和外设的特性，以及特性中的数据。
    [peripheral setDelegate:self];
    
    // 既然已经连接到某个蓝牙了，那就不需要在继续扫描外设了
    [self.manager stopScan];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setupService {
    // Creates the characteristic UUID
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:kCharacteristicUUID];
    // Creates the characteristic
    self.customCharacteristic = [[CBMutableCharacteristic alloc] initWithType:
                                 characteristicUUID properties:CBCharacteristicPropertyNotify
                                                                        value:nil permissions:CBAttributePermissionsReadable];
    // Creates the service UUID
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    // Creates the service and adds the characteristic to it
    self.customService = [[CBMutableService alloc] initWithType:serviceUUID
                                                        primary:YES];
    // Sets the characteristics for this service
    [self.customService setCharacteristics:
     @[self.customCharacteristic]];
    // Publishes the service
    [self.peripheralManager addService:self.customService];
}

/*
 Request CBCentralManager to scan for all available services
 */
- (void) startScan {
    NSLog(@"scaning");
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber  numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    
    [self.manager scanForPeripheralsWithServices:nil options:options];
    
    
    //    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]
    //                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
}


- (void) centralManagerDidUpdateState:(CBCentralManager*)central {
    switch(central.state) {
        case CBManagerStatePoweredOn:
            [self startScan]; //加到这里这里这里！
            break;
        default:
            break;
    }
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (peripheral.name.length <= 0) {
        return ;
    }
    
    NSLog(@"Discovered name:%@,identifier:%@,advertisementData:%@,RSSI:%@", peripheral.name, peripheral.identifier,advertisementData,RSSI);
    
    if (self.deviceArray.count == 0) {
        NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
        [self.deviceArray addObject:dict];
    } else {
        BOOL isExist = NO;
        for (int i = 0; i < self.deviceArray.count; i++) {
            NSDictionary *dict = [self.deviceArray objectAtIndex:i];
            CBPeripheral *per = dict[@"peripheral"];
            if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                isExist = YES;
                NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
                [_deviceArray replaceObjectAtIndex:i withObject:dict];
            }
        }
        
        if (!isExist) {
            NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
            [self.deviceArray addObject:dict];
        }
    }
    
    [self.tableview reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s",__FUNCTION__);
    
    // Stop scanning
    [self.manager stopScan];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // 连接成功后，查找服务
    [peripheral discoverServices:nil];
    
    
    // Search only for services that match our UUID
    //    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
}


#pragma mark - CBPeripheralDelegate
//// 找到我们刚刚指定的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    
    NSString *UUID = [peripheral.identifier UUIDString];
    //    NSLog(@"didDiscoverServices:%@",UUID);
    if (error) {
        NSLog(@"出错");
        return;
    }
    
    CBUUID *cbUUID = [CBUUID UUIDWithString:UUID];
    NSLog(@"%s  cbUUID:%@",__FUNCTION__,cbUUID);
    
    for (CBService *service in peripheral.services) {
        NSLog(@"service-----**: %@",service.UUID);
        
        //如果我们知道要查询的特性的CBUUID，可以在参数一中传入CBUUID数组。
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
//    for (CBService *service in peripheral.services) {
//        NSLog(@"Service found with UUID: %@",
//              service.UUID);
//        // Discovers the characteristics for a given service
//        if ([service.UUID isEqual:[CBUUID
//                                   UUIDWithString:kServiceUUID]]) {
//            [peripheral discoverCharacteristics:
//  @[[CBUUID UUIDWithString:
//     kCharacteristicUUID]] forService:service];
//        }
//    }

    
    //    // Discover the characteristic we want...
    //
    //    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    //    for (CBService *service in peripheral.services) {
    //        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    //    }
    
    
}

//// 找到我们刚刚指定的属性
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    
    NSLog(@"%s",__FUNCTION__);
    
    if (error) {
        NSLog(@"出错");
        return;
    }
    
    for (CBCharacteristic *character in service.characteristics) {
        // 这是一个枚举类型的属性
        CBCharacteristicProperties properties = character.properties;
        if (properties & CBCharacteristicPropertyBroadcast) {
            //如果是广播特性
        }
        
        if (properties & CBCharacteristicPropertyRead) {
            //如果具备读特性，即可以读取特性的value
            [peripheral readValueForCharacteristic:character];
        }
        
        if (properties & CBCharacteristicPropertyWriteWithoutResponse) {
            //如果具备写入值不需要响应的特性
            //这里保存这个可以写的特性，便于后面往这个特性中写数据
            //            _chatacter = character;
        }
        
        if (properties & CBCharacteristicPropertyWrite) {
            //如果具备写入值的特性，这个应该会有一些响应
        }
        
        if (properties & CBCharacteristicPropertyNotify) {
            //如果具备通知的特性，无响应
            [peripheral setNotifyValue:YES forCharacteristic:character];
        }
    }
    
    
    //    // Again, we loop through the array, just in case.
    //    for (CBCharacteristic *characteristic in service.characteristics) {
    //        // And check if it's the right one
    //        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
    //            // If it is, subscribe to it
    //            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    //        }
    //    }
    //
    //    // Once this is complete, we just need to wait for the data to come in.
}




- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    
    NSLog(@"%s",__FUNCTION__);
    
    if (error) {
        NSLog(@"错误didUpdateNotification：%@",error);
        return;
    }
    
    CBCharacteristicProperties properties = characteristic.properties;
    if (properties & CBCharacteristicPropertyRead) {
        //如果具备读特性，即可以读取特性的value
        [peripheral readValueForCharacteristic:characteristic];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"hahah" message:[self hexadecimalString:characteristic.value] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
    // 收到数据
    NSLog(@"data---== %@",[self hexadecimalString:characteristic.value]);
    
    //    // Exit if it's not the transfer characteristic
    //    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
    //        return;
    //    }
    //
    //    // Notification has started
    //    if (characteristic.isNotifying) {
    //        NSLog(@"Notification began on %@", characteristic);
    //    }
    //    // Notification has stopped
    //    else {
    //        // so disconnect from the peripheral
    //        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
    //        [self.manager cancelPeripheralConnection:peripheral];
    //    }
    
}





- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"更新特征值%@时发生错误:%@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    NSData *data = characteristic.value;
    if (data.length <= 0) {
        return;
    }
    
    // 收到数据
    NSLog(@"data---**- %@",[self hexadecimalString:characteristic.value]);
}

//将传入的NSData类型转换成NSString并返回
- (NSString*)hexadecimalString:(NSData *)data{
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}
//将传入的NSString类型转换成NSData并返回
- (NSData*)dataWithHexstring:(NSString *)hexstring{
    NSData *aData;
    return aData = [hexstring dataUsingEncoding: NSASCIIStringEncoding];
}



- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected  %@",error.description);
    //    self.discoveredPeripheral = nil;
    //    
    //    // We're disconnected, so start scanning again
    //    [self scan];
}






@end
