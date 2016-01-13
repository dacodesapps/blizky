//
//  MapViewController.m
//  Blizky
//
//  Created by Dacodes on 19/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "MapViewController.h"
#import "ProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "TagPin.h"
#import "ServiceProfileViewController.h"

@import MapKit;

@interface MapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Map";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    self.locationManager.headingFilter = 5;
    
    self.map.delegate = self;
    self.map.showsCompass = YES;
    self.map.showsTraffic = YES;
    self.map.showsScale = YES;
    self.map.showsUserLocation = YES;
    
    [self createAnotationsWithStores];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    self.tabBarController.tabBar.hidden=YES;
//}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}

-(void)createAnotationsWithStores {
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (int i=0; i<[self.services count]; i++) {
        if (![self.services[i][@"location"] isEqual:[NSNull null]]) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.services[i][@"location"][@"lat"] floatValue], [self.services[i][@"location"][@"lng"] floatValue]);
            
            TagPin *pin = [[TagPin alloc] init];
            pin.title = self.services[i][@"serviceName"];
            pin.subtitle = self.services[i][@"address"];
            pin.coordinate = location;
            pin.tag = i;
            
            [services addObject:pin];
        }
    }
    [self.map showAnnotations:services animated:YES];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.map.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    //[self.map setVisibleMapRect:zoomRect animated:YES];
    double inset = -zoomRect.size.width * 0.1;
    [self.map setVisibleMapRect:MKMapRectInset(zoomRect, inset, inset) animated:YES];
    //self.map.camera.altitude *= 1.4;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    TagPin*view =  (TagPin *)annotation;
    
    static NSString *identifier = @"MyPin";
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*) [self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"kukisLogoPin"];
        //annotationView.animatesDrop = YES;
    }
    UIImageView *leftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    NSString *imageString = self.services[view.tag][@"thumbnailUrl"];
    NSRange range = [imageString rangeOfString:@"?dimension=thumbs"];
    if (range.location != NSNotFound) {
        imageString = [imageString substringWithRange:NSMakeRange(0, range.location)];
    }
    [leftIconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",imageString]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            leftIconView.image=image;
        }
    }];
    annotationView.leftCalloutAccessoryView = leftIconView;
    
    leftIconView.layer.cornerRadius = leftIconView.frame.size.width/2;
    leftIconView.layer.borderColor = [UIColor clearColor].CGColor;
    leftIconView.layer.borderWidth = 2.0;
    leftIconView.layer.masksToBounds = YES;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = infoButton;
    
    
    return annotationView;
}

-(void)showDetailView:(UIButton *) sender{
    [self performSegueWithIdentifier:@"showService" sender:self];
//    
//    
//    NSString *str;
//    
//    if([point.title isEqualToString:@"Bakery Gran Plaza"]) {
//        str = @"Bakery Gran Plaza";
//    } else if ([point.title isEqualToString:@"Isla Plaza Altabrisa"]) {
//        str = @"Isla Plaza Altabrisa";
//    } else if ([point.title isEqualToString:@"Isla Plaza City Center"]) {
//        str = @"Isla Plaza City Center";
//    } else  {
//        str = @"Bakery Plaza Altabrisa";
//    }
    
    //[self performSegueWithIdentifier:@"goProfile" sender:self];
}

//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    NSLog(@"tap");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TagPin *point =  [self.map selectedAnnotations][0];
    ServiceProfileViewController* destinationController = segue.destinationViewController;
    destinationController.idService = self.services[point.tag][@"id"];
    destinationController.serviceName = self.services[point.tag][@"serviceName"];
    destinationController.serviceCategory = self.services[point.tag][@"category"][@"name"];
    destinationController.servicePhoto = self.services[point.tag][@"thumbnailUrl"];
    destinationController.serviceDescription = self.services[point.tag][@"description"];
    self.tabBarController.tabBar.hidden=NO;
}


@end
