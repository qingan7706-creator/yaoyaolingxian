"""
Django项目 djangoProject111 的配置文件。

由Django 5.2版本的 'django-admin startproject' 命令生成。

关于此文件的更多信息，请参见：
https://docs.djangoproject.com/en/5.2/topics/settings/

查看所有配置项及其值的完整列表，请参见：
https://docs.djangoproject.com/en/5.2/ref/settings/
"""

from pathlib import Path

# 构建项目内的文件路径：BASE_DIR / 'subdir'
BASE_DIR = Path(__file__).resolve().parent.parent


# 快速启动开发设置 - 不适用于生产环境
# 查看 https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/

# 安全警告：在生产环境中保持密钥的机密性！
SECRET_KEY = "django-insecure-^w@y#08ju-+%(%2v$ziy31^zz)g__i&3zk5l0)kjk3^y!m=zwh"

# 安全警告：生产环境中不要启用调试模式！
DEBUG = True

ALLOWED_HOSTS = ['*']


# 应用程序定义
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    'corsheaders',
    'django_extensions',
    # 自定义应用
    'accounts',
    'rest_framework',   # 建议用DRF方便后续拓展API

]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    #"django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    'corsheaders.middleware.CorsMiddleware',

]

ROOT_URLCONF = "djangoProject111.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / 'templates']
        ,
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "djangoProject111.wsgi.application"


# 数据库配置
# https://docs.djangoproject.com/en/5.2/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'name',
        'USER': 'root',
        'PASSWORD': '123456',
        'HOST': '127.0.0.1',
        'PORT': '3306',
        'OPTIONS': {
            'charset': 'utf8mb4',
        },
    }
}


# 密码验证配置
# https://docs.djangoproject.com/en/5.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


# 国际化配置
# https://docs.djangoproject.com/en/5.2/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# 静态文件配置 (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.2/howto/static-files/

STATIC_URL = "static/"

# 默认主键字段类型
# https://docs.djangoproject.com/en/5.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
CORS_ALLOW_ALL_ORIGINS = True
SESSION_COOKIE_SAMESITE = 'None'  # 允许跨域
SESSION_COOKIE_SECURE = False     # 开发环境可以关闭，生产环境应设为 True
CORS_ALLOW_CREDENTIALS = True
APPEND_SLASH = False