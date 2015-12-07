//
//  ViewController.m
//  动态添加大头针实现掉落的效果
//
//  Created by 陈高健 on 15/12/3.
//  Copyright © 2015年 陈高健. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "ZKAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>
//创建管理者
@property (nonatomic,strong)CLLocationManager *locationManager;
//mapView
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建大头针模型
    ZKAnnotation *annotation = [[ZKAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.9, 116);
    annotation.title = @"北京";
    annotation.subtitle = @"默认显示的为首都北京";
    
    //添加第一个大头针模型
    [self.mapView addAnnotation:annotation];
    //设置代理
    self.mapView.delegate = self;
    
    //请求授权
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    //设置用户跟踪模式
    //self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

//点击屏幕的时候调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取用户点击的位置
    CGPoint point=[[touches anyObject]locationInView:self.mapView];
    //将具体的位置转换为经纬度
    CLLocationCoordinate2D coordinate=[self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    //添加大头针
    ZKAnnotation *annotation=[[ZKAnnotation alloc]init];
    annotation.coordinate=coordinate;
    
    //反地理编码
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error==nil && placemarks.count==0) {
            NSLog(@"错误信息:%@",error);
            return ;
        }
        //获取地标信息
        CLPlacemark *placemark=[placemarks firstObject];
        //获取父标题名称
        annotation.title=placemark.locality;
        //获取子标题名称
        annotation.subtitle=placemark.name;
        
        //添加大头针到地图
        [self.mapView addAnnotation:annotation];
    }];

}

//创建大头针时调用
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //如果返回空,代表大头针样式交由系统去管理
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *ID = @"annotation";
    // MKAnnotationView 默认没有界面  可以显示图片
    // MKPinAnnotationView有界面      默认不能显示图片
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        //设置大头针颜色
        annotationView.pinTintColor = [UIColor redColor];
        //设置为动画掉落的效果
        annotationView.animatesDrop = YES;
        //显示详情
        annotationView.canShowCallout = YES;
    }
    return annotationView;
}
@end
