# utils.py
from .models import UserProfile
from django.contrib.auth.models import User
import random
import string


def generate_unique_family_id(length=16):
    """生成不重复的16位验证码"""
    characters = string.ascii_letters + string.digits
    while True:
        family_id = ''.join(random.choices(characters, k=length))
        if not UserProfile.objects.filter(family_id=family_id).exists():
            return family_id


def new_family(user):
    try:
        # 尝试获取用户对应的 UserProfile，没有则创建
        profile, created = UserProfile.objects.get_or_create(user=user)

        # 生成唯一的 family_id
        new_id = generate_unique_family_id()

        # 存入 family_id 并保存
        profile.family_id = new_id
        profile.save()

        return {
            'status': 'success',
            'message': '新的家庭码已生成',
            'family_id': new_id
        }

    except Exception as e:
        return {
            'status': 'fail',
            'message': f'创建家庭码失败: {str(e)}'
        }

def find_family(user):
    try:
        # 获取当前用户的 family_id
        profile = UserProfile.objects.get(user=user)
        family_id = profile.family_id

        if not family_id:
            return {'status': 'fail', 'message': '当前用户没有 family_id'}

        # 查找所有拥有相同 family_id 的用户
        profiles_in_family = UserProfile.objects.filter(family_id=family_id)

        # 提取所有相关联的 User 对象的 username
        user_ids = profiles_in_family.values_list('user_id', flat=True)
        usernames = list(User.objects.filter(id__in=user_ids).values_list('username', flat=True))

        return {
            'status': 'success',
            'family_id': family_id,
            'usernames': usernames
        }

    except UserProfile.DoesNotExist:
        return {'status': 'fail', 'message': '用户档案不存在'}

