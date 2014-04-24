//
//  ViewController.m
//  TangeCamera
//
//  Created by Eri Tange on 2014/04/08.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "JFWeatherData.h"
#import "JFWeatherManager.h"
#import "DataModels.h"
#import "SBJson4.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define API_KEY @"025ede102232126ca5139975832cae92"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //画面の縦横比を変えずに表示
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    _locationManager = [[CLLocationManager alloc] init];
    
    // 位置情報サービスが利用できれば開始
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        
        NSLog(@"OK");
        
    } else {
        NSLog(@"Location services not available.");
    }
    
    //Open Weather MapのAPIを使う
    
    // OpenWeatherMap APIのリクエストURLをセット
    NSString *url = @"http://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139";
    
    // リクエストURLをUTF8でエンコード
    NSString *urlEscapeStr = [[NSString  stringWithString:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 通信するためにNSMutableURLRequest型のrequestを作成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlEscapeStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    // 通信
    // Check whether the data is returned. If failed, print out the err
    NSURLResponse *response = nil;
    NSError *err = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (returnData == nil) {
        NSLog(@"ERROR: %@", err);
    } else {
        NSLog(@"DATA: %@", returnData);
    }
    
    // real code to do what you want
    SBJson4ValueBlock callbackBlock = ^(id v, BOOL *stop) {
        //weather.mainの値を抽出してラベルに表示
        
        NSLog(@"returned Value: %@",v);
        
        NSDictionary *city = [(NSDictionary *)v valueForKey:@"city"];
        NSLog(@"city:%@",city);
    
        
  //      NSArray *main = [(NSDictionary *)v valueForKeyPath:@"weather.main"];
  //      NSString *weather = main[0];
  //      NSLog(@"%@",weather);
    };   //define a block to handle the parsed data
    
    SBJson4ErrorBlock errorBlock = ^(NSError* err) {
        NSLog(@"OOPS: %@", err);
    }; //define a block to handle the error
    
    // parse the above data to verify.
    SBJson4Parser *parser = [SBJson4Parser parserWithBlock:callbackBlock allowMultiRoot:FALSE unwrapRootArray:FALSE errorHandler:errorBlock];
    [parser parse:returnData];  // parse NSData type.
  
    /*
    //A Full sample to use SBJsonParser
    SBJson4ValueBlock block = ^(id v, BOOL *stop) {
        BOOL isArray = [v isKindOfClass:[NSArray class]];
        NSLog(@"Found: %@", isArray ? @"Array" : @"Object");
    };   //define a block to handle the parsed data
    
    SBJson4ErrorBlock eh = ^(NSError* err) {
        NSLog(@"OOPS: %@", err);
    }; //define a block to handle the error
    
    
    NSDictionary *dict = @{
                           @"name": @"elvis",
                           @"age": @"20",
                           @"interest": @"read"
                           };
    NSArray *array = @[dict,dict];
    
    //build a json data from the object
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    writer.humanReadable = TRUE;
    NSString *strFromArray = [writer stringWithObject:array];
    NSData *dataFromArray = [writer dataWithObject:array];
    NSLog(@"json string: %@",strFromArray);
    
    // parse the above data to verify.
    SBJson4Parser *samplerParser = [SBJson4Parser parserWithBlock:block allowMultiRoot:FALSE unwrapRootArray:FALSE errorHandler:eh];
    
    [samplerParser parse:dataFromArray];  // parse NSData type.
    */
    
    //weather.mainの値を抽出してラベルに表示
   // NSArray *main = [result valueForKeyPath:@"weather.main"];
   // NSString *weather = main[0];
   // NSLog(@"%@",weather);
    
    //sliderの設定
//    slider.maximumValue = 1.0f;//最大値
//    slider.minimumValue = 0.0f;//最小値
//    slider.value = 1.0f;//最初の値
    
    //// インジケーターインスタンスを作成する。
    aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // 画面の中央に表示するようにframeを変更する
    float w = aiView.frame.size.width;
    float h = aiView.frame.size.height;
    float x = self.view.frame.size.width/2 - w/2;
    float y = self.view.frame.size.height/2 - h/2;
    aiView.frame = CGRectMake(x, y, w, h);
    
    // 現在のサブビューとして登録する
    [self.view addSubview:aiView];


}

// 位置情報更新時
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
}

// 測位失敗時や、5位置情報の利用をユーザーが「不許可」とした場合などに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)takePhoto{
    
    //画像の取得先をカメラに
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //カメラが使用可能かどうか判定
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        //UPCを初期化、生成
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        //画像の取得先をカメラに設定
        picker.sourceType = sourceType;
        
        //デリゲートを設定
        picker.delegate = self;
        
        //撮影画面をモーダルビューとして表示する
        [self presentViewController:picker animated:YES completion:nil];
    
        
    }
}

-(IBAction)openLibrary{
    
 //画像の取得先をライブラリに設定
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //フォトライブラリが使用可能かどうかを判定
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        //UPCを初期化、生成
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        //画像の取得先をフォトライブラリに設定
        picker.sourceType = sourceType;
        
        //デリゲートを設定
        picker.delegate = self;
        
        //撮影画面をモーダルビューとして表示する
        [self presentViewController:picker animated:YES completion:nil];

    }
}

//画像が選択されたときに呼ばれるメソッド
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    
    //ModalimageViewControllerのViewを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    //カメラモードの場合
//    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
//        
//        //画像をフォトアルバムに保存する
//        UIImageWriteToSavedPhotosAlbum(
//                                       image,//保存する画像
//                                       self,//呼び出されるメソッドを持っているクラス
//                                       @selector(targetImage:didFinishSavingWithError:contentInfo:)
//                                       //呼び出されるメソッド
//                                       ,NULL);//メソッドに渡すもの
//    }
    
    inputImage = image ;
    
    //imageViewにimageをはめる
    imageView.image = image;
    
}

//画像保存時に呼ばれるメソッド
-(void)targetImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contentInfo:(void *)content{
    
    //保存失敗時
    if (error) {
        
        //アラートの初期化
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"保存できませんでした"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
       //アラートを表示
        [alert show];
    }
    
    //保存成功時
    else{
        
        //アラートの初期化
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"保存しました"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        //アラートを表示
        [alert show];
        
    }
}

//イメージピッカーのキャンセルが押されたとき
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    //ModalimageViewControllerのViewを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//UIImageにテキストを書き込む
//メソッド名 addText
//引数 text:渡すNSString
- (UIImage *)addText:(NSString *)text withFontName:(NSString *)fontName fontSize:(NSUInteger)fontSize forImage:(UIImage *)image locetionIndex:(int)locationIndex {
    
    int w = image.size.width;
    int h = image.size.height;
    
    //imageのサイズにあわせた新しいコンテクストを作る
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
        CGPoint pt;
    //縦と横で位置を変える
    if (w>h) {
        
    
        if (locationIndex == 0) {
            pt = CGPointMake(20, h - h/2);
        }else if(locationIndex == 1){
            pt = CGPointMake(30, h - h/6);
        }else{
            pt = CGPointMake(30, h - h/3);
        }
        
    }else{
        
        if (locationIndex == 0) {
            pt = CGPointMake(20, h - h/3);
        }else if(locationIndex == 1){
            pt = CGPointMake(30, h - h*2/9);
        }else{
            pt = CGPointMake(30, h - h/9);
        }
        
    }
    
    //イメージを書き込む
    [image drawAtPoint:CGPointMake(0.0, 0.0)];
    //テキストを書き込む
    [text drawAtPoint:pt
            withAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName
                                                                 size:fontSize],
                             NSForegroundColorAttributeName: [UIColor orangeColor]}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
//    if (w > h) {
//      
//        w = image.size.height;
//        h = image.size.width;
//    }
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
//    
//    UIGraphicsPushContext(context);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
//    
////    char* cText = (char *)[text cStringUsingEncoding:NSASCIIStringEncoding];
////    CGContextSelectFont(context, [fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
////
////    CGContextSetTextDrawingMode(context, kCGTextFill);
////    CGContextSetRGBFillColor(context, 255, 255, 255, 255);
//    
//
//    
//    //rotate text
//    //CGContextSetTextMatrix(context, CGAffineTransformMakeRotation(-M_PI / 4));
//    
////    if (locationIndex == 0) {
////        
////    CGContextShowTextAtPoint(context, 20, h/4, cText, strlen(cText));
////        
////        NSLog(@"aaa");
////        
////    }else{
////        
////       CGContextShowTextAtPoint(context, 20, h/8, cText, strlen(cText));
////        
////         NSLog(@"iii");
////    }
//
//    
//
//    
//    CGPoint pt;
//    if (locationIndex == 0) {
//        pt = CGPointMake(20, h - h/4);
//    }else{
//        pt = CGPointMake(20, h - h/8);
//    }
//    
//    CGContextSetTextDrawingMode(context, kCGTextFill); // This is the default
//    
//    CGContextTranslateCTM(context, 0.0, image.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    [text drawAtPoint:pt
//       withAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName
//                                                            size:fontSize],
//                        NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    
//    UIGraphicsPopContext();
//    
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
//
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    return newImage;
}




-(IBAction)effect{

    //インジケーター開始
    [aiView startAnimating];
    
    //現在時刻を取得
    NSDate *date = [NSDate date];
    
    //NSDateをNSString型に変換
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSLog(@"%@",dateStr);
    
    
    //お天気を取得
    //OpenWeatherMapのAPI_KEYを生成→
    JFWeatherManager *weatherManager = [[JFWeatherManager alloc]init];
    
    float latitude = _locationManager.location.coordinate.latitude;
    float longitude = _locationManager.location.coordinate.longitude;
    
    
    [weatherManager fetchWeatherDataForLatitude:latitude andLongitude:longitude withAPIKeyOrNil:API_KEY :^(JFWeatherData *returnedWeatherData){
        
        NSLog(@"Latitude %.3f",[returnedWeatherData latitudeCoordinateOfRequest]);
        NSLog(@"Longitude %.3f",[returnedWeatherData longitudeCoordinateOfRequest]);
        NSLog(@"Conditions are %@",[returnedWeatherData currentConditionsTextualDescription]);
        NSLog(@"Temperature is %f",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]);
        NSLog(@"Sunrise is %@",[returnedWeatherData sunriseTime]);
        NSLog(@"Sunset is %@",[returnedWeatherData sunsetTime]);
        NSLog(@"Hours of Day Light are %@",[returnedWeatherData dayLightHours]);
        NSLog(@"Humidity is %@",[returnedWeatherData humidityPercentage]);
        NSLog(@"Pressure is %0.1f",[returnedWeatherData pressureInUnitFormat:kPressureHectopascal]);
        NSLog(@"Wind Speed is %0.1f",[returnedWeatherData windSpeedInUnitFormat:kWindSpeedMPH]);
        NSLog(@"Wind Direction is %@",[returnedWeatherData windDirectionInGeographicalDirection]);
        NSLog(@"Cloud Coverage %@",[returnedWeatherData cloudCovergePercentage]);
        NSLog(@"Rainfall Over Next 3h is %0.1fmm",[returnedWeatherData rainFallVolumeOver3HoursInMillimeters]);
        NSLog(@"SnowFall Over Next 3h is %0.1fmm",[returnedWeatherData snowFallVolumeOver3HoursInMillimeters]);
        
        //UIImageを生成(image)
        //image =[UIImage imageNamed:@"ふなっしー.jpg"];
        
        //inputImageのサイズを取得
        int w = inputImage.size.width;
        int h = inputImage.size.height;
        
        //imageにdateStrを書き込んだUIImageを生成
        dateImage = [self addText:dateStr withFontName:@"KFhimajiFACE" fontSize:w/10 forImage:inputImage locetionIndex:0];

        //weatherstrにお天気の文字列を入れる
        NSString *weatherstr =[returnedWeatherData currentConditionsTextualDescription];
        //weatherstrにお天気の文字列を入れる
        NSString *temperaturestr = [NSString stringWithFormat:@"%.0f℃",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]];
        
        NSLog(@"%@",temperaturestr);
        
        //お天気を書き込んだUIImageを生成
        weatherImage = [self addText:weatherstr withFontName:@"KFhimajiFACE" fontSize:w/10 forImage:dateImage locetionIndex:1];
        
        //気温を書き込んだUIImageを生成
        temperatureImage = [self addText:temperaturestr withFontName:@"KFhimajiFACE" fontSize:w/10
                                forImage:weatherImage locetionIndex:2];
        
        // インジケーター停止
        [aiView stopAnimating];
        
        //imageViewにimageをはめる
        imageView.image = temperatureImage;

    }];
    
   }

-(IBAction)save{
    
    //画像をフォトアルバムに保存する
    UIImageWriteToSavedPhotosAlbum(
                                   temperatureImage,//保存する画像
                                   self,//呼び出されるメソッドを持っているクラス
                                   @selector(targetImage:didFinishSavingWithError:contentInfo:)
                                   //呼び出されるメソッド
                                   ,NULL);//メソッドに渡すもの
}

-(IBAction)filterImage{
    
    UIImage *inputImage = imageView.image;
    
// GPUImageのフォーマットにする
GPUImagePicture *imagePicture = [[GPUImagePicture alloc] initWithImage:inputImage];

// モノクロフィルター
GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];
    
// モノクロフィルターのカラー設定
[(GPUImageMonochromeFilter *)monoFilter setColor:(GPUVector4){0.3f, 0.3f, 0.3f, 0.2f}];
    
//sliderからフィルターの強度を取ってくる
//[monoFilter setValue:[NSNumber numberWithFloat:slider.value] forKey:@"inputtensity"];
    
// イメージにモノクロフィルターを加える
[imagePicture addTarget:monoFilter];

// フィルター実行
[imagePicture processImage];
    
// フィルターから画像を取得
UIImage *outputImage = [monoFilter imageByFilteringImage:inputImage];

// 画像を表示
self->imageView.image = outputImage;
    


}

//-(IBAction)valueChanged{
//    //filterメソッドを呼び出す
//    [self performSelector:@selector(filterImage) withObject:nil];
//}








@end
