//
//  UIImagePicker.h
//  FuseGallery
//
//  Created by Mhd Mansour on 4/11/18.
//  Copyright © 2018 Mhd Mansour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Actions.h"
#import "ImageHelper.h"
#import "TZImagePickerController.h"

@interface MissionXImagePicker : NSObject 

@property (nonatomic, strong) StringAction onCompleteHandler;

@property (nonatomic, strong) StringAction onFailureHandler;

@property (nonatomic, strong) TZImagePickerController* picker;

@property (nonatomic, strong) UIViewController* viewController;

- (id)initWithRootViewController:(UIViewController*)viewController;

- (void) launchPicker;

-(NSString*)convertToJson:(NSMutableArray*)paths;

@end
