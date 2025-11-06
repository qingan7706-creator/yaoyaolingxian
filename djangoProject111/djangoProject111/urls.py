"""
djangoProject111 项目的URL配置。

`urlpatterns` 列表将URL路由到视图。更多信息请参见：
    https://docs.djangoproject.com/en/5.2/topics/http/urls/

示例：
函数视图
    1. 添加导入：  from my_app import views
    2. 添加URL模式：  path('', views.home, name='home')
类视图
    1. 添加导入：  from other_app.views import Home
    2. 添加URL模式：  path('', Home.as_view(), name='home')
包含其他URL配置
    1. 导入include函数：  from django.urls import include, path
    2. 添加URL模式：  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),  # Django管理后台URL
    path('api/', include('accounts.urls')),  # 账户应用的API URL
]
