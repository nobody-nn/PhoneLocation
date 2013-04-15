//
//  DataCenter.h
//  SmsManager
//
//  Created by Nana Zhang on 12-2-17.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "Waiting.h"

#define kCommonTitleKey @"title"
#define kCommonSectionArray @"sectionArray"
#define kTitleKey @"title"
#define kContentKey @"content"
#define kSendToKey @"sendTo"
#define kWhaleNameKey @"name"
#define kWhaleContentKey @"content"


#define kTMobileIndexKey @"TMobileIndex"

#define H_CONTROL_ORIGIN CGPointMake(20, 70)

#define kSmsTitlesKey @"titles"
#define kSmsSymbolsKey @"symbols"

@interface DataCenter : NSObject
{
    BOOL addressFinishLoad,canWait;
    NSString *documentPath;
    NSDictionary *allContactsDic;
    NSDictionary *whaleDic,*commonDic;
    ViewController *rootViewController;
    
    int totalContactCount;
    
    NSDictionary *TMobileDic;
    
    int TMobileIndex;
    NSMutableDictionary *selectedContactsDic;
    
    NSDictionary *emojisDic,*androidDic;
    NSArray *comboArray;
    int currentFaceType;
    
    NSDictionary *tableDic;
    
    UIViewController *whosWaiting;
    
    UIImage *emojiImage,*androidImage;
    UIView *SendSmsTip;
    
    NSDictionary *allSmsDic;
    NSArray *selectedSmsArray;
    Waiting *waiting;
}
@property(nonatomic,retain) NSMutableDictionary *selectedContactsDic;
@property(nonatomic,retain) NSDictionary *allContactsDic,*whaleDic,*commonDic,*TMobileDic,*emojisDic,*androidDic,*tableDic;
@property(nonatomic,retain) NSString *documentPath;
@property(nonatomic,assign) int totalContactCount,TMobileIndex,currentFaceType;
@property(nonatomic,assign) BOOL addressFinishLoad,canWait;
@property(nonatomic,retain) ViewController *rootViewController;
@property(nonatomic,retain) NSArray *comboArray;
@property(nonatomic,retain) Waiting *waiting;
@property(nonatomic,retain) UIViewController *whosWaiting;
@property(nonatomic,retain) UIImage *emojiImage,*androidImage;
@property(nonatomic,retain) UIView *SendSmsTip;
@property(nonatomic,retain) NSDictionary *allSmsDic;
@property(nonatomic,retain) NSArray *selectedSmsArray;

+(DataCenter *)sharedInstance;
-(void)saveCommonDic;

@end
