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

@interface ViewController ()

@end

@implementation ViewController
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //画面の縦横比を変えずに表示
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    locationManager = [[CLLocationManager alloc] init];
    
    // 位置情報サービスが利用できるかどうかをチェック
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = self; // ……【1】
        // 測位開始
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available.");
    }
    
    //Open Weather MapのAPIを使う
    
    // OpenWeatherMap APIのリクエストURLをセット
    NSString *url = @"api.openweathermap.org/data/2.5/weather?lat=35&lon=139";
    
    // リクエストURLをUTF8でエンコード
    NSString *urlEscapeStr = [[NSString  stringWithString:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 通信するためにNSMutableURLRequest型のrequestを作成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlEscapeStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    // 通信
    NSURLResponse * response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    SBJson4ValueBlock block = ^(id v, BOOL *stop) {
        BOOL isArray = [v isKindOfClass:[NSArray class]];
        NSLog(@"Found: %@", isArray ? @"Array" : @"Object");
    };
    
    SBJson4ErrorBlock eh = ^(NSError* err) {
        NSLog(@"OOPS: %@", err);
    };
    
    id parser = [SBJson4Parser multiRootParserWithBlock:block
                                           errorHandler:eh];
    
    
  //  [parser parse:responseData];
    
/*
    
    // SBJsonを初期化
    SBJson4Parser*parser = [SBJson4Parser parserWithBlock:^(id item, BOOL *stop) {
        NSLog(@"%@",item);
    } allowMultiRoot:TRUE unwrapRootArray:TRUE errorHandler:nil];
    
    // JSON形式で来たデータをNSDictionary型に格納
    SBJson4ParserStatus result = [parser parse:responseData];
    NSLog(@"result: %d",result);
//    
//    //weather.mainの値を抽出してラベルに表示
   // NSArray *main = [result valueForKeyPath:@"weather.main"];
   // NSString *weather = main[0];
   // NSLog(@"%@",weather);
 */

}

// 位置情報更新時
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    //緯度・経度を出力
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude);
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
    
    
    //UIImageViewに撮った画像を表示
    imageView.image=image;
    
    //ModalimageViewControllerのViewを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    //カメラモードの場合
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        
        //画像をフォトアルバムに保存する
        UIImageWriteToSavedPhotosAlbum(
                                       image,//保存する画像
                                       self,//呼び出されるメソッドを持っているクラス
                                       @selector(targetImage:didFinishSavingWithError:contentInfo:)
                                       //呼び出されるメソッド
                                       ,NULL);//メソッドに渡すもの
    }
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
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
    
    char* cText = (char *)[text cStringUsingEncoding:NSASCIIStringEncoding];
    
    CGContextSelectFont(context, [fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    
    //rotate text
    //CGContextSetTextMatrix(context, CGAffineTransformMakeRotation(-M_PI / 4));
    
    if (locationIndex == 0) {
        
    CGContextShowTextAtPoint(context, 4, 150, cText, strlen(cText));
        
        NSLog(@"aaa");
        
    }else{
        
       CGContextShowTextAtPoint(context, 4, 34, cText, strlen(cText));
        
         NSLog(@"iii");
    }
    
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
}




-(IBAction)effect{
    
    //現在時刻を取得
    NSDate *date = [NSDate date];
    
    //NSDateをNSString型に変換
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSLog(@"%@",dateStr);
    
    
    //お天気を取得
    //OpenWeatherMapのAPI_KEYを作成
    static NSString *API_KEY=@"YOUR_API_KEY_HERE";
    JFWeatherManager *weatherManager = [[JFWeatherManager alloc]init];
    
    
//    [weatherManager fetchWeatherDataForLatitude:toAdd.coordinate.latitude andLongitude:toAdd.coordinate.longitude withAPIKeyOrNil:API_KEY :^(JFWeatherData *returnedWeatherData){
//        
//        NSLog(@"Latitude %.3f",[returnedWeatherData latitudeCoordinateOfRequest]);
//        NSLog(@"Longitude %.3f",[returnedWeatherData longitudeCoordinateOfRequest]);
//        NSLog(@"Conditions are %@",[returnedWeatherData currentConditionsTextualDescription]);
//        NSLog(@"Temperature is %f",[returnedWeatherData temperatureInUnitFormat:kTemperatureCelcius]);
//        NSLog(@"Sunrise is %@",[returnedWeatherData sunriseTime]);
//        NSLog(@"Sunset is %@",[returnedWeatherData sunsetTime]);
//        NSLog(@"Hours of Day Light are %@",[returnedWeatherData dayLightHours]);
//        NSLog(@"Humidity is %@",[returnedWeatherData humidityPercentage]);
//        NSLog(@"Pressure is %0.1f",[returnedWeatherData pressureInUnitFormat:kPressureHectopascal]);
//        NSLog(@"Wind Speed is %0.1f",[returnedWeatherData windSpeedInUnitFormat:kWindSpeedMPH]);
//        NSLog(@"Wind Direction is %@",[returnedWeatherData windDirectionInGeographicalDirection]);
//        NSLog(@"Cloud Coverage %@",[returnedWeatherData cloudCovergePercentage]);
//        NSLog(@"Rainfall Over Next 3h is %0.1fmm",[returnedWeatherData rainFallVolumeOver3HoursInMillimeters]);
//        NSLog(@"SnowFall Over Next 3h is %0.1fmm",[returnedWeatherData snowFallVolumeOver3HoursInMillimeters]);
//    }];
    
    
    //UIImageを生成(image)
    UIImage *image =[UIImage imageNamed:@"ふなっしー.jpg"];
    
    //imageにdateStrを書き込んだUIImageを生成
    UIImage *dst = [self addText:dateStr withFontName:@"Helvetica" fontSize:32 forImage:image locetionIndex:0];
    
    //tempにお天気を入れる(未)
    NSString *temp = @"aaaa";
    
    //お天気を書き込んだUIImageを生成
    UIImage *tempurature = [self addText:temp withFontName:@"Helvetica" fontSize:40 forImage:dst locetionIndex:1];
    
    //imageViewにimageをはめる
    imageView.image = tempurature;
}




@end
