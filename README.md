# Push
iOS 推送本地推送和远程推送

####1、注册推送
####2、收集用户信息
####3、手机端收到推送的处理：
#####1）应用处于开启（前台）状态:
	- 弹出弹框，让用户判断是否需要跳转到通知页面
#####2）应用处于后台和关闭状态:
	- 点击App图标，直接进入应用，在通知页面显示红点，不做弹框提示
	- 点击通知条进入，进入应用和处于前台一样的操作