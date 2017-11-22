//
//  Student+CoreDataProperties.h
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nonatomic) int16_t schoolYear;
@property (nullable, nonatomic, copy) NSString *studentId;
@property (nullable, nonatomic, retain) ClassAndGrade *classAndGrade;
@property (nullable, nonatomic, retain) School *school;
@property (nullable, nonatomic, retain) Teacher *teacher;

@end

NS_ASSUME_NONNULL_END
