library(cronR)
f ='autoRun.R'

cmd <- cron_rscript(f)

cron_add(cmd, frequency = '*/15 * * * *', id = 'LC-BOM后台运算', description = '每隔15分钟自动') 


# cron_add(cmd, frequency = '*/15 * * * *', id = 'job10', description = 'Every 15 min') 

cron_ls()


cron_njobs()
#删除定时任务使用下面的语句
# cron_clear(ask=FALSE)