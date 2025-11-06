import json
import random
import string
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from .models import UserProfile
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import logout
from django.contrib.auth import authenticate, login
from django.contrib.sessions.models import Session
from .utils import find_family, new_family
from django.contrib.auth import get_user



def generate_unique_family_id(length=4):
    """生成不重复的4位验证码"""
    characters = string.ascii_letters + string.digits
    while True:
        family_id = ''.join(random.choices(characters, k=length))
        if not UserProfile.objects.filter(family_id=family_id).exists():
            return family_id
# ✅ 注册接口
@csrf_exempt
def register(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            password = data.get('password')

            if not username or not password:
                return JsonResponse({'status': 'fail', 'message': '用户名或密码不能为空'})

            if User.objects.filter(username=username).exists():
                return JsonResponse({'status': 'fail', 'message': '用户名已存在'})

            # 创建用户并加密密码
            user = User.objects.create_user(username=username, password=password)
            user.save()

            # 登录用户并设置 sessionid
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                response = JsonResponse({'status': 'success', 'message': '注册成功'})
                # 设置 sessionid 到 cookie，HttpOnly 提高安全性
                response.set_cookie(
                    key='sessionid',
                    value=request.session.session_key,
                    httponly=True,
                    samesite='Lax'  # 可根据需要改为 'Strict' 或 'None'
                )
                return response
            else:
                return JsonResponse({'status': 'fail', 'message': '用户验证失败'})

        except Exception as e:
            return JsonResponse({'status': 'fail', 'message': f'请求格式错误：{str(e)}'})

    return JsonResponse({'status': 'fail', 'message': '只支持POST请求'})

# ✅ 登录接口




@csrf_exempt
def login_view(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            password = data.get('password')
        except Exception:
            return JsonResponse({'status': 'fail', 'message': '请求数据格式错误'}, status=400)

        user = authenticate(username=username, password=password)
        if user is not None:
            login(request, user)  # Django 会自动写入 sessionid Cookie
            sessionid = request.session.session_key.split(';')
            print(sessionid)
            response = JsonResponse({'status': 'success', 'message': '登录成功','sessionid':sessionid[0]}, status=200)
            # 如果需要，可以设置Cookie的其他属性，比如：
            #response.set_cookie('sessionid', request.session.session_key, httponly=False, samesite='Lax')

            return response
        else:
            return JsonResponse({'status': 'fail', 'message': '用户名或密码错误'}, status=401)

    return JsonResponse({'status': 'fail', 'message': '只支持POST请求'}, status=405)


# ✅ 修改密码接口
@csrf_exempt
def change(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            new_password = data.get('password')

            if not username or not new_password:
                return JsonResponse({'status': 'fail', 'message': '用户名或密码不能为空'})

            if len(new_password) < 6:
                return JsonResponse({'status': 'fail', 'message': '密码长度不能少于6位'})

            try:
                user = User.objects.get(username=username)
                user.set_password(new_password)  # 自动加密密码
                user.save()
                return JsonResponse({'status': 'success', 'message': '密码修改成功'})
            except User.DoesNotExist:
                return JsonResponse({'status': 'fail', 'message': '用户不存在'})

        except json.JSONDecodeError:
            return JsonResponse({'status': 'fail', 'message': 'JSON格式错误'})
        except Exception as e:
            return JsonResponse({'status': 'fail', 'message': f'服务器异常: {str(e)}'})

    return JsonResponse({'status': 'fail', 'message': '仅支持POST请求'})

# views.py



@login_required
@csrf_exempt
def check_family(request):
    if request.method == 'POST':
        user = request.user

        try:
            # 安全地获取 UserProfile（避免直接 user.profile）
            profile = UserProfile.objects.get(user=user)
        except UserProfile.DoesNotExist:
            return JsonResponse({'has_family': False})

        # 如果 family_id 有值
        if profile.family_id:
            return JsonResponse({'has_family': True})
        else:
            return JsonResponse({'has_family': False})
    else:
        return JsonResponse({"error": "只支持 POST 请求"}, status=405)

@login_required
@csrf_exempt
def find_family(request):
    user = request.user
    try:
        # 获取当前用户的 family_id
        profile = UserProfile.objects.get(user=user)
        family_id = profile.family_id

        if not family_id:
            return JsonResponse({'status': 'fail', 'message': '当前用户没有 family_id'})

        # 查找所有拥有相同 family_id 的用户
        profiles_in_family = UserProfile.objects.filter(family_id=family_id)

        # 提取所有相关联的 User 对象的 username
        user_ids = profiles_in_family.values_list('user_id', flat=True)
        usernames = list(User.objects.filter(id__in=user_ids).values_list('username', flat=True))

        return JsonResponse({
            'status': 'success',
            'family_id': family_id,
            'usernames': usernames
        })

    except UserProfile.DoesNotExist:
        return JsonResponse({'status': 'fail', 'message': '用户档案不存在'})

@login_required
@csrf_exempt
def find_family_view(request):
    user = request.user  # 获取当前登录用户

    # 尝试获取 UserProfile，如不存在则创建
    profile, created = UserProfile.objects.get_or_create(user=user)

    # 如果该用户还没有 family_id，先为其创建一个新的
    if not profile.family_id:
        profile.family_id = generate_unique_family_id()
        profile.save()

    family_id = profile.family_id

    # 查找所有属于同一个家庭的用户
    # profiles_in_family = UserProfile.objects.filter(family_id=family_id)
    #
    # # 提取用户名
    # user_ids = profiles_in_family.values_list('user_id', flat=True)
    # usernames = list(User.objects.filter(id__in=user_ids).values_list('username', flat=True))

    return JsonResponse({
        'status': 'success',
        'family_id': family_id,
        # 'usernames': usernames
    })

@login_required
@csrf_exempt

def logout_view(request):
    if request.method == 'POST':
        session_key = request.COOKIES.get('sessionid')
        if session_key:
            # 获取对应 session
            try:
                session = Session.objects.get(session_key=session_key)
                session.delete()  # 清除 session 数据
                return JsonResponse({'status': 'success', 'message': '注销成功'})
            except Session.DoesNotExist:
                return JsonResponse({'status': 'fail', 'message': '无效的 session，可能已过期'})
        else:
            return JsonResponse({'status': 'fail', 'message': '未提供 sessionid'})
    else:
        return JsonResponse({'status': 'fail', 'message': '只支持 POST 请求'})




@login_required
@csrf_exempt
def join_family_view(request):
    try:
        user = request.user
        data = json.loads(request.body.decode('utf-8'))
        family_code = data.get('family_code')

        if not family_code:
            return JsonResponse({'status': 'fail', 'message': '缺少家庭码'}, status=400)

        # 检查该家庭码是否存在于任何用户的 profile 中
        print(family_code)
        print(UserProfile.objects.filter(family_id=family_code).exists())
        all_profiles = UserProfile.objects.all()
        family_ids = UserProfile.objects.values_list('family_id', flat=True)
        print(list(family_ids))  # 打印所有 family_id 列表
        if not UserProfile.objects.filter(family_id=family_code).exists():
            return JsonResponse({'status': 'fail', 'message': '查无此家庭码'}, status=444)

        # 获取当前用户的 UserProfile，如无则创建
        profile, _ = UserProfile.objects.get_or_create(user=user)

        # 更新家庭码
        profile.family_id = family_code
        profile.save()

        return JsonResponse({'status': 'success', 'message': '加入家庭成功', 'family_id': family_code})

    except json.JSONDecodeError:
        return JsonResponse({'status': 'fail', 'message': '请求数据格式错误'}, status=400)

    except Exception as e:
        print(e)
        return JsonResponse({'status': 'fail', 'message': f'服务器错误: {str(e)}'}, status=500)

@login_required
@csrf_exempt
def find_all_family(request):
    try:
        # 获取当前用户的 family_id
        user=request.user
        profile = UserProfile.objects.get(user=user)
        family_id = profile.family_id

        if not family_id:
            return JsonResponse({'status': 'fail', 'message': '当前用户没有 family_id'})

        # 查找所有拥有相同 family_id 的用户
        profiles_in_family = UserProfile.objects.filter(family_id=family_id)

        # 提取所有相关联的 User 对象的 username
        user_ids = profiles_in_family.values_list('user_id', flat=True)
        usernames = list(User.objects.filter(id__in=user_ids).values_list('username', flat=True))
        usernames.remove(user.username)

        return JsonResponse({
            'status': 'success',
            'usernames': usernames
        })

    except UserProfile.DoesNotExist:
        return JsonResponse({'status': 'fail', 'message': '用户档案不存在'})
@csrf_exempt
@login_required
def submit_health_data(request):
    if request.method != 'POST':
        return JsonResponse({'status': 'fail', 'message': '只接受 POST 请求'}, status=405)

    try:
        data = json.loads(request.body)
        data_type = data.get('type')     # 前端传来的类型：sleep/stand/calorie/steps
        value = data.get('value')        # 前端传来的数值

        # 类型和数值校验
        if data_type not in ['sleep', 'stand', 'calorie', 'steps']:
            return JsonResponse({'status': 'fail', 'message': '无效的数据类型'}, status=400)
        if not isinstance(value, (int, float)):
            return JsonResponse({'status': 'fail', 'message': '值必须是数字'}, status=400)

        # 获取当前用户的 UserProfile
        profile = UserProfile.objects.get(user=request.user)

        # 根据 type 更新对应字段
        setattr(profile, data_type, value)  # 动态设置字段值
        profile.save()  # 保存更改

        return JsonResponse({'status': 'success', 'message': f'{data_type} 数据已更新为 {value}'})

    except UserProfile.DoesNotExist:
        return JsonResponse({'status': 'fail', 'message': '用户资料不存在'}, status=444)
    except json.JSONDecodeError:
        return JsonResponse({'status': 'fail', 'message': '请求格式错误，必须为 JSON'}, status=400)
    except Exception as e:
        return JsonResponse({'status': 'fail', 'message': f'服务器错误: {str(e)}'}, status=500)
@csrf_exempt
@login_required
def update_goal_view(request):
    if request.method != 'POST':
        return JsonResponse({'status': 'fail', 'message': '仅支持POST请求'}, status=405)

    try:
        data = json.loads(request.body)
        data_type = data.get('type')       # 如 'steps'
        value = data.get('value')          # 字符串形式的数值
        value = float(value)               # 转 float（int 也能转）
    except (ValueError, TypeError, json.JSONDecodeError):
        return JsonResponse({'status': 'fail', 'message': '参数错误'}, status=400)

    # 获取当前用户的UserProfile
    user = request.user
    try:
        profile = UserProfile.objects.get(user=user)
    except UserProfile.DoesNotExist:
        return JsonResponse({'status': 'fail', 'message': '用户信息不存在'}, status=404)

    # 字段映射
    target_fields = {
        'steps': 'target_steps',
        'sleep': 'target_sleep',
        'calorie': 'target_calorie',
        'stand': 'target_stand'
    }

    if data_type not in target_fields:
        return JsonResponse({'status': 'fail', 'message': '无效的数据类型'}, status=400)

    # 动态设置对应目标字段
    setattr(profile, target_fields[data_type], value)
    profile.save()

    return JsonResponse({'status': 'success', 'message': f'{data_type}目标已更新为{value}'})
@login_required
@csrf_exempt
def health_history(request):
    user = request.user
    profile = UserProfile.objects.filter(user=user).first()
    if profile is None:
        return JsonResponse({
            "data": [0, 0, 0, 0, 0],
            "others": [],
            "sessionid": request.session.session_key,
        })

    family_id = profile.family_id
    def calc_rate(current, target):
        if target > 0:
            return round((current / target) * 100)
        return 0

    sleep_rate = calc_rate(profile.sleep, profile.target_sleep)
    stand_rate = calc_rate(profile.stand, profile.target_stand)
    calorie_rate = calc_rate(profile.calorie, profile.target_calorie)
    steps_rate = calc_rate(profile.steps, profile.target_steps)

    sleep_rate = min(sleep_rate, 100)
    stand_rate = min(stand_rate, 100)
    calorie_rate = min(calorie_rate, 100)
    steps_rate = min(steps_rate, 100)

    total_progress = round((sleep_rate + stand_rate + calorie_rate + steps_rate) / 4)
    profile.total_progress = total_progress
    profile.save(update_fields=['total_progress'])

    print([sleep_rate, stand_rate, calorie_rate, steps_rate, total_progress])

    other_profiles = UserProfile.objects.filter(family_id=family_id).exclude(user=user)
    other_users_progress = [
        {
            "username": p.user.username,
            "total_progress": p.total_progress
        }
        for p in other_profiles
    ]

    return JsonResponse({
        "data": [sleep_rate, stand_rate, calorie_rate, steps_rate, total_progress],
        "others": other_users_progress,
        "sessionid": request.session.session_key,
    })

