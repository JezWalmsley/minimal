#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBBulletin : NSObject
@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *sectionID;
@property(nonatomic, copy)NSString* recordID;
@property(nonatomic, copy)NSString* publisherBulletinID;
@property(nonatomic, copy)NSString* message;
@property(nonatomic, retain)NSDate* date;
@property(assign, nonatomic)BOOL clearable;
@property(nonatomic)BOOL showsMessagePreview;
@property(nonatomic, copy)NSString* bulletinID;
@property(nonatomic, retain)NSDate* lastInterruptDate;
@property(nonatomic, retain)NSDate* publicationDate;
@end

@interface NCNotificationContent : NSObject
@property (readonly, nonatomic, nullable) UIImage *icon;
@end

@interface NCNotificationRequest : NSObject
@property (readonly, copy, nonatomic) NSString *notificationIdentifier;
@property(nonatomic,readonly) BBBulletin *bulletin;
@property (readonly, nonatomic) NSDate *timestamp;
@property (readonly, nonatomic) NCNotificationContent *content;
@end

@interface NCNotificationDispatcher : NSObject
-(void)postNotificationWithRequest:(NCNotificationRequest *)arg1;
-(void)withdrawNotificationWithRequest:(id)arg1 ;
@end

NS_ASSUME_NONNULL_END
