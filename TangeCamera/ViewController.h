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
    
    //撮影した写真
    UIImage *inputImage;
    //現在日時を書き込んだUIImage
    UIImage *dateImage;
    //天気と現在日時を書き込んだUIImage
    UIImage *weatherImage;
    //気温を書き込んだUIImage
    UIImage *temperatureImage;
    
    IBOutlet UILabel *label;
    
    //エフェクトの強度を変える
    //IBOutlet UISlider *slider;
    
    //インジケーター
    UIActivityIndicatorView * aiView;
    
}

@property (nonatomic, retain) CLLocationManager *locationManager;

-(IBAction)takePhoto;
-(IBAction)openLibrary;
-(IBAction)effect;
-(IBAction)save;
-(IBAction)filterImage;
-(IBAction)valueChanged;


@end
