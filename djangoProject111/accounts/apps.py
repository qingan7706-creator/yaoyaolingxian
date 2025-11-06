from django.apps import AppConfig


class AccountsConfig(AppConfig):
    """
    账户应用的配置类
    用于配置应用的基本信息
    """
    default_auto_field = "django.db.models.BigAutoField"  # 默认主键字段类型
    name = "accounts"  # 应用名称


