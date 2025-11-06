from django.db import models
from django.contrib.auth.models import User

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    family_id = models.CharField(max_length=100, blank=True, null=True)

    # 当前健康数据（实时/周期性统计）
    sleep = models.FloatField(default=0.0)        # 当前睡眠时长（单位：小时）
    stand = models.IntegerField(default=0)        # 当前站立时长（单位：分钟）
    calorie = models.FloatField(default=0.0)      # 当前摄入卡路里（单位：千卡）
    steps = models.IntegerField(default=0)        # 当前步数（单位：步）

    # 健康目标数据（由用户手动设定）
    target_sleep = models.IntegerField(default=0)     # 目标睡眠时长（小时）
    target_stand = models.IntegerField(default=0)     # 目标站立时长（分钟）
    target_calorie = models.IntegerField(default=0)   # 目标摄入卡路里（千卡）
    target_steps = models.IntegerField(default=0)     # 目标步数（步）
    # 总进度百分比
    total_progress = models.IntegerField(default=0)
    def __str__(self):
        return f"{self.user.username} 的资料"
