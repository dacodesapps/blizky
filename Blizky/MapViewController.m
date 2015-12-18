//
//  MapViewController.m
//  Blizky
//
//  Created by Dacodes on 19/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "MapViewController.h"
#import "ProfileViewController.h"

@import MapKit;

@interface MapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Network";
    
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
    CLLocationCoordinate2D bakeryPlazaABCoordinate = CLLocationCoordinate2DMake(21.016870, -89.584487);
    CLLocationCoordinate2D islaPlazaABCoordinate = CLLocationCoordinate2DMake(21.018512, -89.584948);
    CLLocationCoordinate2D bakeryGranPlazaCoordinate = CLLocationCoordinate2DMake(21.030267, -89.624193);
    CLLocationCoordinate2D islaCityCenterCoordinate = CLLocationCoordinate2DMake(21.037522, -89.604464);
    
    
    MKPointAnnotation *bakeryPlazaABAnnotation = [[MKPointAnnotation alloc] init];
    bakeryPlazaABAnnotation.title = @"Bakery Plaza Altabrisa";
    bakeryPlazaABAnnotation.coordinate = bakeryPlazaABCoordinate;
    
    
    MKPointAnnotation *islaPlazaABAnnotation = [[MKPointAnnotation alloc] init];
    islaPlazaABAnnotation.title = @"Isla Plaza Altabrisa";
    islaPlazaABAnnotation.coordinate = islaPlazaABCoordinate;
    
    MKPointAnnotation *bakeryGranPlazaAnnotation = [[MKPointAnnotation alloc] init];
    bakeryGranPlazaAnnotation.title = @"Bakery Gran Plaza";
    bakeryGranPlazaAnnotation.coordinate = bakeryGranPlazaCoordinate;
    
    MKPointAnnotation *islaPlazaCityCenterAnnotation = [[MKPointAnnotation alloc] init];
    islaPlazaCityCenterAnnotation.title = @"Isla Plaza City Center";
    islaPlazaCityCenterAnnotation.coordinate = islaCityCenterCoordinate;
    
    [self.map showAnnotations:@[bakeryGranPlazaAnnotation, bakeryPlazaABAnnotation, islaPlazaABAnnotation, islaPlazaCityCenterAnnotation] animated:YES];
    
    //annotationsStores = @[bakeryPlazaABAnnotation, islaPlazaABAnnotation, bakeryGranPlazaAnnotation, islaPlazaCityCenterAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
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
    [leftIconView setImage:[UIImage imageNamed:@"kukisLogoPin"]];
    annotationView.leftCalloutAccessoryView = leftIconView;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = infoButton;
    
    
    return annotationView;
}

-(void)showDetailView:(UIButton *) sender{
    
//    MKPointAnnotation *point =  [self.map selectedAnnotations][0];
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
    
    [self performSegueWithIdentifier:@"goProfile" sender:self];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"tap");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(IBAction)back:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.tabBarController.tabBar.hidden=NO;
}


@end
