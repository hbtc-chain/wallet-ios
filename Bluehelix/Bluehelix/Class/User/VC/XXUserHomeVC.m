//
//  XXUserHomeVC.m
//  Bhex
//
//  Created by BHEX on 2018/6/12.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXUserHomeVC.h"
#import "XXUserHomeCell.h"
#import "XXTabBarController.h"
#import "IQKeyboardManager.h"
#import "XXAccountManageVC.h"
#import "XXUserHeaderView.h"
#import "XXBackupMnemonicPhraseVC.h"
#import "XXPasswordView.h"
#import "Signature.h"
#import <CommonCrypto/CommonDigest.h>
#import "Account.h"
#import "SecureData.h"
#import "XXTransactionRequest.h"

@interface XXUserHomeVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *itemsArray;

@property (strong, nonatomic) XXButton *settingButton;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *iconArray;

@property (strong, nonatomic) XXUserHeaderView *headerView;

@end

@implementation XXUserHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)initData {
    self.itemsArray = [NSMutableArray array];
    self.iconArray = [NSMutableArray array];
    if (KUser.currentAccount.mnemonicPhrase) {
        self.itemsArray[0] = @[LocalizedString(@"BackupMnemonicPhrase"), LocalizedString(@"ModifyPassword")];
    } else {
        self.itemsArray[0] = @[LocalizedString(@"ModifyPassword")];
    }
}

- (void)setupUI {
    self.navView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.itemsArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXUserHomeCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXUserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXUserHomeCell"];
    if (!cell) {
        cell = [[XXUserHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXUserHomeCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *namesArray = self.itemsArray[indexPath.section];
    cell.nameLabel.text = namesArray[indexPath.row];
    cell.contentView.backgroundColor = kViewBackgroundColor;
    cell.nameLabel.textColor = kDark100;
    cell.lineView.backgroundColor = KLine_Color;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *itemsArray = @[];
    if (indexPath.section < self.itemsArray.count) {
        itemsArray = self.itemsArray[indexPath.section];
    } else {
        return;
    }
    
    NSString *itemString = @"";
    if (indexPath.row < itemsArray.count) {
        itemString = itemsArray[indexPath.row];
    } else {
        return;
    }
    
    if ([itemString isEqualToString:LocalizedString(@"BackupMnemonicPhrase")]) { // 备份助记词
        [self pushBackupPhrase];
    }
    if ([itemString isEqualToString:LocalizedString(@"ModifyPassword")]) {
        
    }
}

- (void)pushBackupPhrase {
    MJWeakSelf
    [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
        XXBackupMnemonicPhraseVC *backup = [[XXBackupMnemonicPhraseVC alloc] init];
        backup.text = text;
        [weakSelf.navigationController pushViewController:backup animated:YES];
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kTabbarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhite100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (XXUserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(256))];
    }
    return _headerView;
}

//- (void)initRPCData {
//    //msgs
//       NSMutableDictionary *amount = [NSMutableDictionary dictionary];
//       amount[@"amount"] = @"50000000000000000000";
//       amount[@"denom"] = @"bht";
//       NSMutableArray *amounts = [NSMutableArray array];
//       [amounts addObject:amount];
//
//       NSMutableDictionary *msgValue = [NSMutableDictionary dictionary];
//       msgValue[@"amount"] = amounts;
//       msgValue[@"from_address"] = @"BHgE934R84XUxETVFoVav46NKs6aakgoq8b";
//       msgValue[@"to_address"] = @"BHV1EuSkWMYHWNa5bAUAm6DTbLzT4QPNoGn";
//
//       NSMutableDictionary *msg = [NSMutableDictionary dictionary];
//       msg[@"type"] = @"cosmos-sdk/MsgSend";
//       msg[@"value"] = msgValue;
//       NSMutableArray *msgs = [NSMutableArray array];
//       [msgs addObject:msg];
//
//       //fee
//       NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
//       feeAmount[@"amount"] = @"2000000000000000000";
//       feeAmount[@"denom"] = @"bht";
//       NSMutableArray *feeAmounts = [NSMutableArray array];
//       [feeAmounts addObject:feeAmount];
//       NSMutableDictionary *fee = [NSMutableDictionary dictionary];
//       fee[@"amount"] = feeAmounts;
//       fee[@"gas"] = @"2000000";
//
//    //signatures
//    NSMutableDictionary *pubKey = [NSMutableDictionary dictionary];
//    pubKey[@"type"] = @"tendermint/PubKeySecp256k1";
//    pubKey[@"value"] = @"AnBvPmb+JuI/oznYBpex49ZGVsPKLoKR0L9MfRe/xeVy";
//    NSMutableDictionary *signature = [NSMutableDictionary dictionary];
//    signature[@"pub_key"] = pubKey;
////    signature[@"signature"] = @"mNqNN9MGp3VeI6VebdeTSejmevV5kPi8AtK9AGlmqisYMXq4voljUOfWUo1OnZHnIJCberfkn6dOjG7zQJ1PcA==";
//    signature[@"signature"] = @"nzTJ1nuKb1BDxjHj6LOcmDbia3uaA6/uWPhRfmZ14IBMe1Un7a7Mruzj2nsCK9+tMH3st04SlPEB4QgtT0uEJg==";
//
//    NSMutableArray *signatures = [NSMutableArray array];
//    [signatures addObject:signature];
//
//    //rpc
//    NSMutableDictionary *value = [NSMutableDictionary dictionary];
//    value[@"msg"] = msgs;
//    value[@"fee"] = fee;
//    value[@"signatures"] = signatures;
//    value[@"memo"] = @"test memo";
//
//    NSMutableDictionary *rpc = [NSMutableDictionary dictionary];
//    rpc[@"type"] = @"bhchain/StdTx";
//    rpc[@"value"] = value;
//
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rpc options:0 error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSString *jsonB = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//    NSData *jsonD = [jsonB dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@",jsonB);
//
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.operationQueue.maxConcurrentOperationCount = 5;
////    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
//
//    [manager POST:@"http://bhchain-testnet-node1-751700059.ap-northeast-1.elb.amazonaws.com:1317/txs" parameters:rpc headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@ %@",task,error);
//        NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
//        NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
//    }];
//}
//- (void)testSign {
//     //msgs
//
//        NSMutableDictionary *amount = [NSMutableDictionary dictionary];
//        amount[@"amount"] = @"50000000000000000000";
//        amount[@"denom"] = @"bht";
//        NSMutableArray *amounts = [NSMutableArray array];
//        [amounts addObject:amount];
//
//        NSMutableDictionary *value = [NSMutableDictionary dictionary];
//        value[@"amount"] = amounts;
//        value[@"from_address"] = @"BHj2wujKtAxw9XZMA7zDDvjGqKjoYUdw1FZ";
//        value[@"to_address"] = @"BHV1EuSkWMYHWNa5bAUAm6DTbLzT4QPNoGn";
//
//        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
//        msg[@"type"] = @"cosmos-sdk/MsgSend";
//        msg[@"value"] = value;
//        NSMutableArray *msgs = [NSMutableArray array];
//        [msgs addObject:msg];
//
//        //fee
//        NSMutableDictionary *feeAmount = [NSMutableDictionary dictionary];
//        feeAmount[@"amount"] = @"2000000000000000000";
//        feeAmount[@"denom"] = @"bht";
//        NSMutableArray *feeAmounts = [NSMutableArray array];
//        [feeAmounts addObject:feeAmount];
//        NSMutableDictionary *fee = [NSMutableDictionary dictionary];
//        fee[@"amount"] = feeAmounts;
//        fee[@"gas"] = @"2000000";
//
//        //TX
//        NSMutableDictionary *tx = [NSMutableDictionary dictionary];
//        tx[@"chain_id"] = @"bhchain-testnet";
//        tx[@"cu_number"] = @"0";
//        tx[@"fee"] = fee;
//        tx[@"memo"] = @"test memo";
//        tx[@"msgs"] = msgs;
//        tx[@"sequence"] = @"1";
//
//        if (@available(iOS 11.0, *)) {
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tx options:NSJSONWritingSortedKeys error:nil];
//            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSString *jsonB = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//            NSData *jsonD = [jsonB dataUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"%@",jsonB);
//
//            NSData *sec256Data = [SecureData SHA256:jsonD];
//             NSString *sec256Base64 = [NSString base64StringFromData:sec256Data length:0];
//    //        NSData *key = [@"d0f6c44a31c845bb1e752d15442f4f931376f1a852fad062ffb45510374a128a" dataUsingEncoding:NSUTF8StringEncoding];
//            SecureData *keyData = [SecureData secureDataWithHexString:@"37ef53a59ca92d983c41c1b6681275637ebb9aa85bb035c39d75b48c77b20baa"];
//
//
//            NSData *daa = [NSData base64DataFromString:@"/wtAQf7Kd3HLFL1I50geWRWnUVSf0h0GGVQoVS/v1/c="];
//
//
//            Account *account = [Account accountWithPrivateKey:keyData.data];
//           Signature *sig = [account signDigest:daa];
//
//            SecureData *data10S = [SecureData secureDataWithData:sig.r];
//
//
//            SecureData *resultD = [SecureData secureDataWithHexString:@"98da8d37d306a7755e23a55e6dd79349e8e67af57990f8bc02d2bd006966aa2b18317ab8be896350e7d6528d4e9d91e720909b7ab7e49fa74e8c6ef3409d4f70"];
//            NSString *ddddd = [NSString base64StringFromData:resultD.data length:0];
//            unsigned char hash[CC_SHA256_DIGEST_LENGTH];
//            if (CC_SHA256([jsonData bytes], [jsonData length], hash)) {
//               NSData *sha1 = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
//                NSString *shaBase64 = [NSString base64StringFromData:sha1 length:0];
//    //           Signature *s = [Signature signatureWithData:sha1];
//
//               Signature *s = [account signDigest:sha1];
//                SecureData *r = [SecureData secureDataWithData:s.r];
//                SecureData *ss = [SecureData secureDataWithData:s.s];
//                NSLog(@"%@",s);
//
//               NSData *base64Data = [NSData base64DataFromString:@"mNqNN9MGp3VeI6VebdeTSejmevV5kPi8AtK9AGlmqisYMXq4voljUOfWUo1OnZHnIJCberfkn6dOjG7zQJ1PcA=="];
//                NSString *base64Str = [NSString base64StringFromData:r.data length:0];
//                NSString *base641 = [NSString base64StringFromData:ss.data length:0];
//    //            NSData *rd = [NSJSONSerialization dataWithJSONObject:r.bytes options:NSJSONWritingSortedKeys error:nil];
//    //            NSData *ssd = [NSJSONSerialization dataWithJSONObject:ss.bytes options:NSJSONWritingSortedKeys error:nil];
//
//                NSLog(@"sdfsd");
//            }
//        }
//}

@end
