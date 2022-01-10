#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kARGPreferencesShowLandmark @"kARGPreferencesShowLandmark"
#define kARGPreferencesVideoBitrate @"kARGPreferencesVideoBitrate"

@interface ARGPreferences : NSObject

@property (nonatomic, assign) BOOL showLandmark;
@property (nonatomic, assign) NSInteger videoBitrate;

- (BOOL)loadBoolValue:(NSString *)key;
- (NSInteger)loadIntegerValue:(NSString *)key;

- (void)storeBoolValue:(BOOL)value key:(NSString *)key;
- (void)storeIntegerValue:(NSInteger)value key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
