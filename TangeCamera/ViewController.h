//
//  ViewController.h
//  TangeCamera
//
//  Created by Eri Tange on 2014/04/08.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>{
    
    //画像を表示するView
    IBOutlet UIImageView *imageView;
    
    CLLocationManager *lm;
    
}

@property (nonatomic, retain) CLLocationManager *locationManager;

-(IBAction)takePhoto;
-(IBAction)openLibrary;
-(IBAction)effect;
-(IBAction)save;

@end
