from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register),
    path('login/', views.login_view),
    path('change/', views.change),
    path('logout/', views.logout_view),
    path('check/', views.check_family),
    path('new/', views.find_family_view),
    path('join/', views.join_family_view),
    path('find/', views.find_all_family),
    path('healthdata/', views.submit_health_data),
    path('healthgoal/', views.update_goal_view),
    path('healthhistory/', views.health_history),
]
