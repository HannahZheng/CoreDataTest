//
//  StudentCell.m
//  CoreDataTest
//
//  Created by MXTH on 2017/11/13.
//  Copyright © 2017年 Hannah. All rights reserved.
//

#import "StudentCell.h"
#import "ClassAndGrade+CoreDataClass.h"
#import "School+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"


@implementation StudentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.name == nil) {
            NSArray *tempArr = [[NSBundle mainBundle] loadNibNamed:@"StudentCell" owner:self options:nil];
            StudentCell *tempCell = [tempArr firstObject];
            self = tempCell;
        }
       
        
    }
    return self;
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    NSArray *tempArr = [[NSBundle mainBundle] loadNibNamed:@"StudentCell" owner:self options:nil];
//    StudentCell *tempCell = [tempArr firstObject];
//    [self addSubview:tempCell.contentView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStudentModel:(Student *)studentModel{
    _studentModel = studentModel;
    
    self.name.text = studentModel.name;
    self.age.text = [NSString stringWithFormat:@"%d",studentModel.age];
    self.sex.text = studentModel.sex?@"女":@"男";
    self.studentId.text = studentModel.studentId;
    self.schoolYear.text = [NSString stringWithFormat:@"%d",studentModel.schoolYear];
    self.gradeAndClass.text= [NSString stringWithFormat:@"%@%@",studentModel.classAndGrade.grade,studentModel.classAndGrade.name];
    self.school.text = studentModel.school.name;
    self.teacher.text = studentModel.teacher.name;
}

@end
