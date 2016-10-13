//
//  Model.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-6.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "Model.h"

@implementation Model
-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.des forKey:@"des"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.idPic forKey:@"idPic"];
    [aCoder encodeObject:self.count forKey:@"count"];
    [aCoder encodeObject:self.idInfo forKey:@"idInfo"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.adddate forKey:@"adddate"];
    [aCoder encodeObject:self.comment_totals forKey:@"comment_totals"];
    [aCoder encodeObject:self.magazineId forKey:@"magazineId"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.chapterId forKey:@"chapterId"];
    [aCoder encodeObject:self.list forKey:@"list"];
    [aCoder encodeObject:self.start_time forKey:@"start_time"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.gid forKey:@"gid"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.keyword forKey:@"keyword"];
    [aCoder encodeObject:self.update forKey:@"update"];
    [aCoder encodeObject:self.order forKey:@"order"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.content forKey:@"content"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.des = [aDecoder decodeObjectForKey:@"des"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.idPic = [aDecoder decodeObjectForKey:@"idPic"];
        self.count = [aDecoder decodeObjectForKey:@"count"];
        self.idInfo = [aDecoder decodeObjectForKey:@"idInfo"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.adddate = [aDecoder decodeObjectForKey:@"adddate"];
        self.comment_totals = [aDecoder decodeObjectForKey:@"comment_totals"];
        self.magazineId = [aDecoder decodeObjectForKey:@"magazineId"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.chapterId = [aDecoder decodeObjectForKey:@"chapterId"];
        self.list = [aDecoder decodeObjectForKey:@"list"];
        self.start_time = [aDecoder decodeObjectForKey:@"start_time"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.gid = [aDecoder decodeObjectForKey:@"gid"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.keyword = [aDecoder decodeObjectForKey:@"keyword"];
        self.update = [aDecoder decodeObjectForKey:@"update"];
        self.order = [aDecoder decodeObjectForKey:@"order"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
    }
    
    return self;
}
@end
