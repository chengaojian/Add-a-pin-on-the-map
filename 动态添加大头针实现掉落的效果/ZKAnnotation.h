//
//  ZKAnnotation.h
//  动态添加大头针实现掉落的效果
//
//  Created by 陈高健 on 15/12/3.
//  Copyright © 2015年 陈高健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZKAnnotation : NSObject<MKAnnotation>
//经纬度
@property (nonatomic) CLLocationCoordinate2D coordinate;
//标题
@property (nonatomic, copy) NSString *title;
//子标题
@property (nonatomic, copy) NSString *subtitle;
@end
