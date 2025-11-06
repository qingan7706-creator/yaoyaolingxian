# 导入序列化器模块，用于转换数据格式
from rest_framework import serializers
# 导入自定义的用户模型
from .models import User
# 导入Django的密码加密工具
from django.contrib.auth.hashers import make_password

class RegisterSerializer(serializers.Serializer):
    """
    用户注册的序列化器
    用于验证和转换用户注册时提交的数据
    """
    # 用户名字段，最大长度150个字符
    username = serializers.CharField(max_length=150)
    # 密码字段，最大长度128个字符，write_only=True表示该字段只能写入，不能读取
    password = serializers.CharField(max_length=128, write_only=True)

    def validate_username(self, value):
        """
        验证用户名的方法
        :param value: 用户提交的用户名
        :return: 验证通过返回用户名，否则抛出验证错误
        """
        # 检查用户名是否已存在
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("账号已存在")
        # 检查用户名长度是否符合要求
        
        return value

    def validate_password(self, value):
        """
        验证密码的方法
        :param value: 用户提交的密码
        :return: 验证通过返回密码，否则抛出验证错误
        """
        # 检查密码长度是否符合要求
        if len(value) < 8:
            raise serializers.ValidationError("密码长度不能小于8个字符")
        return value

    def create(self, validated_data):
        """
        创建新用户的方法
        :param validated_data: 验证通过的数据
        :return: 创建的用户对象
        """
        # 对密码进行加密处理
        validated_data['password'] = make_password(validated_data['password'])
        # 创建并返回新用户
        user = User.objects.create(**validated_data)
        return user
