//
//  ParseCertifiationController.m
//  DataHandler
//
//  Created by lbxia on 2017/5/23.
//  Copyright © 2017年 LBX. All rights reserved.
//

#import "ParseCertifiationController.h"
#import "LBXCertificate.h"
#import "NSString+LBXConverter.h"
#import "NSData+LBXConverter.h"
#import "NSData+LBXHash.h"
#import "NSData+LBXCommonCrypto.h"
#import "NSString+LBXHash.h"

@interface ParseCertifiationController ()
@property (unsafe_unretained) IBOutlet NSTextView *srcTextView;
@property (unsafe_unretained) IBOutlet NSTextView *dstTextView;
@property (weak) IBOutlet NSPopUpButton *popUpSrcDataType;

@end

@implementation ParseCertifiationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [_popUpSrcDataType removeAllItems];
    [_popUpSrcDataType addItemWithTitle:@"hex"];
}


- (IBAction)parseCerData:(id)sender
{
   if( [[LBXCertificate sharedManager]loadCerHexString:_srcTextView.string] )
   {
       _dstTextView.string = [self formatCerInfo];
   }
   else
   {
       [self showAlertWithMessage:@"解析失败"];
   }
}

- (NSString*)formatCerInfo
{
    NSMutableString *str = [[NSMutableString alloc]init];
    
    LBXCertificationModel *baseModel = [[LBXCertificate sharedManager]certficationBaseInfo];
    
    [str appendFormat:@"  --- 证书基本信息 ---\r\n"];
    [str appendFormat:@"序列号: %@\r\n",baseModel.hexSerialNumber.disperseHexString];
    [str appendFormat:@"序列号(大数表示): %@\r\n",baseModel.bigNumSerialNumber];
    [str appendFormat:@"版本号: %@\r\n",baseModel.cerVersion];
    [str appendFormat:@"签名算法: %@\r\n",baseModel.signAlgorithm];
    [str appendFormat:@"在此之前无效: %@ 中国标准时间\r\n",baseModel.enableCerFrom];
    [str appendFormat:@"在此之后无效: %@ 中国标准时间\r\n",baseModel.disableCerTo];
    
    
    LBXCertificateIssuerModel *signUserInfo = [[LBXCertificate sharedManager]certificationIssuerInfo];
    [str appendString:@"\r\n  --- 签发者名称 ---\r\n"];
    if (signUserInfo.country) {
         [str appendFormat:@"国家/地区: %@\r\n",signUserInfo.country];
    }
    if (signUserInfo.province) {
        [str appendFormat:@"省/市/自治区: %@\r\n",signUserInfo.province];
    }
    if (signUserInfo.localPlace) {
        [str appendFormat:@"所在地: %@\r\n",signUserInfo.localPlace];
    }
    if (signUserInfo.organization) {
        [str appendFormat:@"组织: %@\r\n",signUserInfo.organization];
    }
    if (signUserInfo.organizationUnit) {
        [str appendFormat:@"组织单位: %@\r\n",signUserInfo.organizationUnit];
    }
    if (signUserInfo.commonName) {
        [str appendFormat:@"常用名称: %@\r\n",signUserInfo.commonName];
    }
    
    if (signUserInfo.serialNumber) {
        [str appendFormat:@"序列号: %@\r\n",signUserInfo.serialNumber];
    }
    if (signUserInfo.email) {
        [str appendFormat:@"邮件: %@\r\n",signUserInfo.email];
    }
    
    signUserInfo = [[LBXCertificate sharedManager]certificationSubjectInfo];
    [str appendString:@"\r\n  --- 主题名称 ---\r\n"];
    if (signUserInfo.country) {
        [str appendFormat:@"国家/地区: %@\r\n",signUserInfo.country];
    }
    if (signUserInfo.province) {
        [str appendFormat:@"省/市/自治区: %@\r\n",signUserInfo.province];
    }
    if (signUserInfo.localPlace) {
        [str appendFormat:@"所在地: %@\r\n",signUserInfo.localPlace];
    }
    if (signUserInfo.organization) {
        [str appendFormat:@"组织: %@\r\n",signUserInfo.organization];
    }
    if (signUserInfo.organizationUnit) {
        [str appendFormat:@"组织单位: %@\r\n",signUserInfo.organizationUnit];
    }
    if (signUserInfo.commonName) {
        [str appendFormat:@"常用名称: %@\r\n",signUserInfo.commonName];
    }
    
    if (signUserInfo.serialNumber) {
        [str appendFormat:@"序列号: %@\r\n",signUserInfo.serialNumber];
    }
    if (signUserInfo.email) {
        [str appendFormat:@"邮件: %@\r\n",signUserInfo.email];
    }
    
    signUserInfo = [[LBXCertificate sharedManager]certificationWhoHave];
    [str appendString:@"\r\n  --- 持有者名称 ---\r\n"];
    if (signUserInfo.country) {
        [str appendFormat:@"国家/地区: %@\r\n",signUserInfo.country];
    }
    if (signUserInfo.province) {
        [str appendFormat:@"省/市/自治区: %@\r\n",signUserInfo.province];
    }
    if (signUserInfo.localPlace) {
        [str appendFormat:@"所在地: %@\r\n",signUserInfo.localPlace];
    }
    if (signUserInfo.organization) {
        [str appendFormat:@"组织: %@\r\n",signUserInfo.organization];
    }
    if (signUserInfo.organizationUnit) {
        [str appendFormat:@"组织单位: %@\r\n",signUserInfo.organizationUnit];
    }
    if (signUserInfo.commonName) {
        [str appendFormat:@"常用名称: %@\r\n",signUserInfo.commonName];
    }
    
    if (signUserInfo.serialNumber) {
        [str appendFormat:@"序列号: %@\r\n",signUserInfo.serialNumber];
    }
    if (signUserInfo.email) {
        [str appendFormat:@"邮件: %@\r\n",signUserInfo.email];
    }

    [str appendString:@"\r\n  --- 公共密钥信息 ---\r\n"];
//    [str appendFormat:@"算法: %@\r\n",baseModel.signAlgorithm];
    [str appendFormat:@"公共密钥 %ld 字节:%@\r\n",baseModel.publicKey.length/2,baseModel.publicKey.disperseHexString];
    [str appendFormat:@"密钥用途: %@\r\n",baseModel.keyUsage];
    
    [str appendString:@"\r\n  --- 签名信息 ---\r\n"];
    //    [str appendFormat:@"算法: %@\r\n",baseModel.signAlgorithm];
    [str appendFormat:@"签名值 %ld 字节: %@\r\n",baseModel.signature.length/2,baseModel.signature.disperseHexString];
    
    
    [str appendString:@"\r\n  --- 指纹信息 ---\r\n"];
    [str appendFormat:@"MD5: %@\r\n",[self fingerPrint_md5]];
    [str appendFormat:@"SHA1: %@\r\n",[self fingerPrint_sha1]];
    
    
    
    return str;
}

- (NSString*)fingerPrint_md5
{
    NSData *cerData = [_srcTextView.string hexString2Data];
    
    return cerData.MD5Sum.hexString.disperseHexString;
}

- (NSString*)fingerPrint_sha1
{
    NSData *cerData = [_srcTextView.string hexString2Data];
    
    return cerData.SHA1Hash.hexString.disperseHexString;
}

//ok!
- (IBAction)openSelectedDialog:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setMessage:@""];
    [panel setPrompt:@"OK"];
    [panel setCanChooseDirectories:YES];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:YES];
    NSString *path_all;
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        path_all = [[panel URL] path];
        NSLog(@"path:%@", path_all);
        
        NSData *fileData = [NSData dataWithContentsOfURL:[panel URL]];
        
        _srcTextView.string = fileData.utf8String;
    }
}

- (void)showAlertWithMessage:(NSString*)message
{
    NSAlert *alert = [[NSAlert alloc]init];
    alert.messageText = message;
    [alert addButtonWithTitle:@"确定"];
    
    NSUInteger action = [alert runModal];
    //响应window的按钮事件
    if(action == NSAlertDefaultReturn)
    {
        NSLog(@"defaultButton clicked!");
    }
    else if(action == NSAlertAlternateReturn )
    {
        NSLog(@"alternateButton clicked!");
    }
    else if(action == NSAlertOtherReturn)
    {
        NSLog(@"otherButton clicked!");
    }
}


@end
