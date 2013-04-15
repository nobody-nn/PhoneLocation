//
//  DataCenter.m
//  SmsManager
//
//  Created by Nana Zhang on 12-2-17.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter
@synthesize allContactsDic,documentPath,whaleDic,totalContactCount,addressFinishLoad,commonDic,rootViewController,TMobileDic,TMobileIndex,selectedContactsDic,emojisDic,comboArray,androidDic,currentFaceType,tableDic,waiting,whosWaiting,emojiImage,androidImage,SendSmsTip,allSmsDic,selectedSmsArray,canWait;

static DataCenter *instance;
+(DataCenter *)sharedInstance
{
    if (!instance) 
    {
        instance = [[DataCenter alloc] init];
    }
    return instance;
}

-(id)init
{
    if (self = [super init]) 
    {
        self.totalContactCount = 0;
        self.addressFinishLoad = NO;
        self.documentPath = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.commonDic = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/common.plist",documentPath]];
        if (!commonDic) 
        {
            self.commonDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"common" ofType:@"plist"]];
            //第一次初始化,并且保存到用户文档目录
            [self saveCommonDic];
        }
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"EmojiFace" ofType:@"plist"]];
        self.emojisDic = [faceDic objectForKey:@"0"];
        self.androidDic = [faceDic objectForKey:@"1"];
        self.comboArray = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"combo" ofType:@"plist"]]objectForKey:@"combo"];
        [[faceDic objectForKey:@"1"]objectForKey:kContentKey];
        
        self.whaleDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WhaleSms" ofType:@"plist"]];
        self.TMobileDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TMobileSms" ofType:@"plist"]];
        TMobileIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kTMobileIndexKey];
        self.selectedContactsDic = [NSMutableDictionary dictionary];
        NSString *sysVersionString = [[UIDevice currentDevice] systemVersion];
        if([sysVersionString rangeOfString:@"5."].location != NSNotFound)
            self.canWait = YES;
        else
            self.canWait = NO; 
    }
    return self;
}

-(void)saveCommonDic
{
    if(![self.commonDic writeToFile:[NSString stringWithFormat:@"%@/common.plist",self.documentPath] atomically:YES])
    {
        //should not be able to get here
    }
}

@end
