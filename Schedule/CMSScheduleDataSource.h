@class CMSSession;

@protocol CMSScheduleDataSource <NSObject>

- (CMSSession *)nextSessionInListAfter:(CMSSession *)session;
- (CMSSession *)prevSessionInListBefore:(CMSSession *)session;

@end
