# !!!!!!
我的数据库不对外开放，如果需要数据库功能请用本项目提供的sql文件创建数据库，并且去addons/sourcemod/configs/database.cfg修改为自己的数据库，如果不用的话可以把下面涉及数据库的插件删除，把原版anne的rpg.smx替换即可

## 涉及到数据库的插件
optional/rpg.smx

l4d_stats.smx

hextags.smx

sb_*.smx //sourcebans相关插件

extend/chatlog.smx

还有请更改configs/core.cfg中的"MinidumpAccount" "76561198203126935" 的值，这个为64位steamid，服务器crash后会自动上传crash log到https://crash.limetech.org/ 网页，方便查看造成crash的原因
# anne
l4d2 anne plugins 
# 插件功能记录
## infected_control.smx
特感控制插件，移动特感，控制特感。
## infected_movement.smx
spitter tank smoker能力插件
## text.smx
特感数量和刷新时间控制插件，命令有sm_xx查看当前游戏模式 sm_zs sm_kill自杀
## rpg.smx
Anne特有的商店插件
## Alone.smx
AnneServer InfectedSpawn
