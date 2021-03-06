//
//  ProductT.h
//  FCRM
//
//  Created by song jiekun on 15/7/29.
//  Copyright (c) 2015年 song jiekun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "InternetImage.h"

@interface ProductT : NSObject

@property (nonatomic, retain) NSDate* createdAt;
@property (nonatomic, retain) NSString* oID;
@property (nonatomic, retain) NSNumber* productLevel;
@property (nonatomic, retain) NSString* managerName;
@property (nonatomic, retain) NSString* managerProfileImageUrl;
@property (nonatomic, retain) NSNumber* productMinAmount;
@property (nonatomic, retain) NSString* productPeriod;
@property (nonatomic, retain) NSString* productName;
@property (nonatomic, retain) NSString* productCategory;
@property (nonatomic, retain) NSDate* updatedAt;
@property (nonatomic, retain) NSNumber* productYieldRate;
@property (nonatomic, retain) NSNumber* userScore;
/*!
 *@discussion 互联网上获取图片
 */
@property (nonatomic, retain) InternetImage* managerProfileInternetImage;

//创建新的product
+(id)createProductWithProductName:(NSString*)productName category:(NSString*)productCategory productID:(NSString*)oID level:(NSNumber*)productLevel minAmount:(NSNumber*)productMinAmount yieldRate:(NSNumber*)productYieldRate userScore:(NSNumber*)userScore  period:(NSString*)productPeriod createdDate:(NSDate*)createdAt updatedDate:(NSDate*)updatedAt profileUrl:(NSString*)managerProfileImageUrl managerName:(NSString*)managerName;

+(id)createProductWithAVObject:(AVObject*)object;

//从intrnet载入products
+(void)reloadProducts:(id)target action:(SEL)reload category:(NSString*)productCategory;

+(void)reloadProducts:(id)target action:(SEL)reload category:(NSString*)productCategory level:(NSNumber*)productLevel sort:(NSString*)productSort;

@end
