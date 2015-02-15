//
//  ViewController.m
//  PhotoPicker
//
//  Created by muxi on 15/2/13.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "ViewController.h"
#import "CorePhotoPickerVCManager.h"


@interface ViewController ()

@property (nonatomic,strong) CorePhotoPickerVCManager *manager;
@property (strong, nonatomic) IBOutlet UIImageView *imageV;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)btnClick:(id)sender {
    
    CorePhotoPickerVCManager *manager=[CorePhotoPickerVCManager pickerVCWithPikerType:CorePhotoPickerTypeMultiPhoto];
    
    _manager=manager;
    
    //最多可选3张
    manager.maxSelectedPhotoNumber=4;
    
    //错误处理
    if(manager.unavailableType!=CorePhotoPickerUnavailableTypeNone){
        NSLog(@"设备不可用");
        return;
    }
    
    UIViewController *pickerVC=manager.pickerVC;
    
    //选取结束
    manager.finishPickingMedia=^(NSArray *medias){
        
        [medias enumerateObjectsUsingBlock:^(CorePhoto *photo, NSUInteger idx, BOOL *stop) {
            NSLog(@"%@",photo.editedImage);
        }];
    };

    

    [self presentViewController:pickerVC animated:YES completion:nil];
    
}






@end
