#import <Foundation/Foundation.h>

@class CMSDocument;
@class CMSSession;
@class CMSSpeaker;

@interface CMSDataLoader : NSObject

+ (instancetype)sharedLoader;
+ (void)setSharedLoader:(CMSDataLoader *)loader;

- (id)initWithDocument:(CMSDocument *)document;

- (void)fetchAndRefreshData:(void(^)(NSError *error))completion;
- (void)fetchAndRefreshAvatarForSpeaker:(CMSSpeaker *)speaker completion:(void(^)(NSError *error))completion;

@property (nonatomic, strong) CMSDocument *document;

@end
