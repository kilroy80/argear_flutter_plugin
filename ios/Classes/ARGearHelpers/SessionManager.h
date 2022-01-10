#import <Foundation/Foundation.h>
#import <ARGear/ARGear.h>
#import "ARGPreferences.h"
#import "Models.h"

NS_ASSUME_NONNULL_BEGIN

@interface SessionManager : NSObject
@property (nonatomic, assign) ARGSession *session;
@property (nonatomic, strong) ARGPreferences *preferences;

+ (SessionManager *)shared;

- (void)setSticker:(ItemModel *)item success:(void (^)(BOOL exist))successBlock fail:(void (^)(void))failBlock;
- (void)clearSticker;

- (void)setFilter:(ItemModel *)item success:(void (^)(void))successBlock fail:(void (^)(void))failBlock;
- (void)clearFilter;
- (void)setFilterLevel:(float)level;

- (void)setBeauty:(ARGContentItemBeauty)type value:(CGFloat)value;
- (void)setBeautyValues:(NSArray*)values;
- (void)setDefaultBeauty;
- (NSArray*)loadBeautyValue;

- (void)setBulge:(int)type;
- (void)clearBulge;
- (ARGContentItemBulge)getBulgeType:(int)type;

@end

NS_ASSUME_NONNULL_END
