#import "Models.h"
#import "SessionManager.h"
#import "NetworkManager.h"

@implementation SessionManager

+ (SessionManager *)shared {
    static dispatch_once_t pred;
    static SessionManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[SessionManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setSticker:(ItemModel *)item success:(void (^)(BOOL exist))successBlock fail:(void (^)(void))failBlock {
    
    if (!_preferences) {
        _preferences = [[ARGPreferences alloc] init];
    }

    if ([_preferences loadIntegerValue:item.uuid] > 0 && item.updated_at == [_preferences loadIntegerValue:item.uuid]) {

        [_session.contents setItemWithType:ARGContentItemTypeSticker
                          withItemFilePath:nil
                                withItemID:[item uuid]
                                completion:^(BOOL success, NSString * _Nullable msg) {
            if (success) {
                successBlock(YES);
            } else {
                failBlock();
            }
        }];
    } else {
        [[NetworkManager shared] downloadItem:item success:^(NSString * _Nonnull uuid, NSURL * _Nonnull targetPath) {

            [self->_preferences storeIntegerValue:item.updated_at key:item.uuid];
            
            [self->_session.contents setItemWithType:ARGContentItemTypeSticker
                                    withItemFilePath:[targetPath absoluteString]
                                          withItemID:[item uuid]
                                          completion:^(BOOL success, NSString * _Nullable msg) {
                if (success) {
                    successBlock(NO);
                } else {
                    failBlock();
                }
            }];
        } fail:^{
            failBlock();
        }];
    }
}

- (void)clearSticker {
    [_session.contents setItemWithType:ARGContentItemTypeSticker
                      withItemFilePath:nil
                            withItemID:nil
                            completion:nil];
}

- (void)setFilter:(ItemModel *)item success:(void (^)(void))successBlock fail:(void (^)(void))failBlock {
    
    if (!_preferences) {
        _preferences = [[ARGPreferences alloc] init];
    }
    
    if ([_preferences loadIntegerValue:item.uuid] > 0 && item.updated_at == [_preferences loadIntegerValue:item.uuid]) {
        
        [_session.contents setItemWithType:ARGContentItemTypeFilter
                          withItemFilePath:nil
                                withItemID:[item uuid]
                                completion:^(BOOL success, NSString * _Nullable msg) {
            if (success) {
                successBlock();
            } else {
                failBlock();
            }
        }];
    } else {
        [[NetworkManager shared] downloadItem:item success:^(NSString * _Nonnull uuid, NSURL * _Nonnull targetPath) {

            [self->_preferences storeIntegerValue:item.updated_at key:item.uuid];

            [self->_session.contents setItemWithType:ARGContentItemTypeFilter
                                    withItemFilePath:[targetPath absoluteString]
                                          withItemID:[item uuid]
                                          completion:^(BOOL success, NSString * _Nullable msg) {
                if (success) {
                    successBlock();
                } else {
                    failBlock();
                }
            }];
        } fail:^{
            failBlock();
        }];
    }
}

- (void)clearFilter {
    [_session.contents setItemWithType:ARGContentItemTypeFilter
                      withItemFilePath:nil
                            withItemID:nil
                            completion:nil];
}

- (void)setFilterLevel:(float)level {
    [_session.contents setFilterLevel: level];
}

- (void)setBeauty:(ARGContentItemBeauty)type value:(CGFloat)value {
//    value = [self convertSliderValueToBeautyValue:type value:value];
    
    [[_session contents] setBeauty:type value:value];
}

- (void)setBeautyValues:(NSArray*)values {
    
    float floatValues[ARGContentItemBeautyNum];
    for (NSInteger i = 0; i < ARGContentItemBeautyNum; i++) {
        floatValues[i] = [[values objectAtIndex:i] floatValue];
    }
    
    [[_session contents] setBeautyValues:floatValues];
}

- (void)setDefaultBeauty {
    [[_session contents] setDefaultBeauty];
}

- (NSArray*)loadBeautyValue {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:ARGContentItemBeautyNum];
    for (NSInteger i = 0; i < ARGContentItemBeautyNum; i++) {
        [mutableArray addObject:[NSNumber numberWithFloat:[[_session contents] getBeautyValue:i]]];
    }
    
    NSArray *array = [NSArray arrayWithArray:mutableArray];
    return array;
}

- (void)setBulge:(int)type {
    
    ARGContentItemBulge mode = [self getBulgeType: type];
    [[_session contents] setBulge:mode];
}

- (void)clearBulge {
    [[_session contents] setBulge:ARGContentItemBulgeNONE];
}

- (ARGContentItemBulge)getBulgeType:(int)type {
    ARGContentItemBulge mode;
    switch (type) {
        case 0:
            mode = ARGContentItemBulgeFUN1;
            break;
        case 1:
            mode = ARGContentItemBulgeFUN2;
            break;
        case 2:
            mode = ARGContentItemBulgeFUN3;
            break;
        case 3:
            mode = ARGContentItemBulgeFUN4;
            break;
        case 4:
            mode = ARGContentItemBulgeFUN5;
            break;
        case 5:
            mode = ARGContentItemBulgeFUN6;
            break;
        default:
            mode = ARGContentItemBulgeNONE;
            break;
    }
    return mode;
}

@end
