//
//  MyVideoMapVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/12/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <SMCalloutView/SMCalloutView.h>
#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVFoundation.h>

#import "MyVideoMapVC.h"
#import "OwnStreamModel.h"
#import "VideoVC.h"
#import "MetaModel.h"
#import "LocationTracker.h"

static const CGFloat CalloutYOffset = 50.0f;

@interface MyVideoMapVC () <GMSMapViewDelegate>

@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;

@end

@implementation MyVideoMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D coordinate = [AppDelegate shared].locationTracker.myLastLocation;
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:10.0];
    [self.view_map animateToCameraPosition:camera];
    self.view_map.myLocationEnabled = YES;
}

/**
 * Originally it was diaplying streamed videos location but now we are just displaying user location (2017.06.29)
 * When it's required again just uncomment this code again
 */

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:48.8 longitude:2.3 zoom:8.0];
//    
//    self.view_map.camera = camera;
//    self.view_map.delegate = self;
//    
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self loadStreams:0 block:^(BOOL success) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self reloadMap];
//    }];
//}

//- (void) loadStreams:(int) page block:(void(^)(BOOL success))block  {
//    if(self.mStreams) {
//        [self.mStreams removeAllObjects];
//    } else {
//        self.mStreams = [[NSMutableArray alloc] init];
//    }
//        
//    
//    [[MyService shared] getOwnStreamsForPage:page
//                                  channelIds:[AppDelegate shared].selectedChannels
//                               streamTypeIds:[AppDelegate shared].selectedNews
//                                     dayType:[AppDelegate shared].selectedDayType
//                                       block:^(BOOL success, id res) {
//
//                                           BOOL isSuccess = NO;
//                                           if(success) {
//                                               if([res[@"status"] isEqualToString:@"ok"]) {
////                                                   MetaModel* metaData = [[MetaModel alloc] initWith:res];
//                                                   NSArray* datas = [res objectForKey:@"data"];
//                                                   for(NSDictionary* item in datas) {
//                                                       [self.mStreams addObject:[[OwnStreamModel alloc] initWith:item]];
//                                                   }
//                                                   
//                                                   isSuccess = YES;
//                                               }
//                                           }
//                                           
//                                           if(block) {
//                                               block(isSuccess);
//                                           }
//                                       }];
//}
//
//
//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    self.calloutView = [[SMCalloutView alloc] init];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [button addTarget:self
//               action:@selector(calloutAccessoryButtonTapped:)
//     forControlEvents:UIControlEventTouchUpInside];
//    self.calloutView.rightAccessoryView = button;
//    
//    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
//}
//
//- (void) reloadMap {
//    [self.view_map clear];
//    
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
//    CLLocationCoordinate2D location;
//    for (OwnStreamModel* item in self.mStreams)
//    {
//        location.latitude = item.latitude;
//        location.longitude = item.longitude;
//        // Creates a marker in the center of the map.
//        GMSMarker *marker = [[GMSMarker alloc] init];
//        marker.icon = [UIImage imageNamed:(@"marker.png")];
//        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
//        marker.title = item.streamName;
//        marker.userData = item;
//        marker.map = self.view_map;
//        
//        bounds = [bounds includingCoordinate:marker.position];
//    }
//    [self.view_map animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
//}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    [self.calloutView setHidden:YES];
//    self.emptyCalloutView = nil;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//- (void)calloutAccessoryButtonTapped:(id)sender {
//    if (self.view_map.selectedMarker) {
//        
//        GMSMarker *marker = self.view_map.selectedMarker;
//        OwnStreamModel *selectedModel = (OwnStreamModel*)marker.userData;
//        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[MyService shared] getStreamVideo:(int)selectedModel.stream_id block:^(BOOL success, id res) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if(success) {
//                if([res[@"status"] isEqualToString:@"ok"]) {
//                    NSDictionary* data = res[@"data"];
//                    NSString* url = data[@"url"];
//                    
//                    VideoVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoVC"];
//                    vc.videoURL = [NSURL URLWithString:url];
//                    vc.isWebVideo = YES;
//                    [self.navigationController presentViewController:vc animated:YES completion:nil];
//                }
//            }
//        }];
//    }
//}
//
//
//#pragma mark - GMSMapViewDelegate
//
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
//    OwnStreamModel* info = (OwnStreamModel*)marker.userData;
//    
//    CLLocationCoordinate2D anchor = marker.position;
//    CGPoint point = [mapView.projection pointForCoordinate:anchor];
//    
//    
//    UIImageView* streamImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 0, 50.0f, 30.0f)];
//    streamImageView.contentMode = UIViewContentModeScaleAspectFit;
//    NSString* encodedString = [info.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL* url = [NSURL URLWithString:encodedString];
//    [streamImageView sd_setImageWithURL:url
//                     placeholderImage:[UIImage imageNamed:@"img_default_channel"]
//                              options:SDWebImageRefreshCached];
//    
//    self.calloutView.leftAccessoryView = streamImageView;
//    self.calloutView.title = [NSString stringWithFormat:@"%@ (%@)", marker.title, info.streamType.name] ;
//    self.calloutView.subtitle = [NSString stringWithFormat:@"%@", info.createdTime];
//    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
//    self.calloutView.hidden = NO;
//    
//    CGRect calloutRect = CGRectZero;
//    calloutRect.origin = point;
//    calloutRect.size = CGSizeZero;
//    [self.calloutView presentCalloutFromRect:calloutRect
//                                      inView:mapView
//                           constrainedToView:mapView
//                                    animated:YES];
//    
//    return self.emptyCalloutView;
//}
//
//- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position {
//    /* move callout with map drag */
//    if (pMapView.selectedMarker != nil && !self.calloutView.hidden) {
//        CLLocationCoordinate2D anchor = [pMapView.selectedMarker position];
//        
//        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
//        
//        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
//        pt.x -= arrowPt.x;
//        pt.y -= arrowPt.y + CalloutYOffset;
//        
//        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
//    } else {
//        self.calloutView.hidden = YES;
//    }
//}
//
//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    self.calloutView.hidden = YES;
//}
//
//- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
//    /* don't move map camera to center marker on tap */
//    mapView.selectedMarker = marker;
//    return YES;
//}

@end
