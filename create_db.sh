#!/bin/bash

anynowtime="date +'%Y-%m-%d %H:%M:%S'"
NOW="echo [\`$anynowtime\`][PID:$$]"

##### 可在脚本开始运行时调用，打印当时的时间戳及PID。
function job_start
{
    echo "`eval $NOW` job_start"
}

##### 可在脚本执行成功的逻辑分支处调用，打印当时的时间戳及PID。
function job_success
{
    MSG="$*"
    echo "`eval $NOW` job_success:[$MSG]"
    exit 0
}

##### 可在脚本执行失败的逻辑分支处调用，打印当时的时间戳及PID。
function job_fail
{
    MSG="$*"
    echo "`eval $NOW` job_fail:[$MSG]"
    exit 1
}

job_start

###### 可在此处开始编写您的脚本逻辑代码
###### 作业平台中执行脚本成功和失败的标准只取决于脚本最后一条执行语句的返回值
###### 如果返回值为0，则认为此脚本执行成功，如果非0，则认为脚本执行失败
USERNAME="root"
PASSWORD="gdgdg"
GRANTIP=(1.1.1.1 2.2.2.2 3.3.3.3) # 您需要授权的IP

## 参数为DBNAME
DBNAME="$1"
echo $DBNAME
MYSQL="/data/bkee/service/mysql/bin/mysql"  # 您服务器上mysql的路径

grant_db () {
    local src_ip=$1
    grant_db_sql="grant all privileges on $DBNAME.* to $DBNAME@'$src_ip' identified by '$DBNAME@2018';"
    echo $grant_db_sql

    $MYSQL -u$USERNAME -p$PASSWORD -e "$grant_db_sql"
}

create_db_sql="CREATE DATABASE IF NOT EXISTS $DBNAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"

echo $create_db_sql

$MYSQL -u$USERNAME -p$PASSWORD -e "$create_db_sql"

for ip in ${GRANTIP[@]}; do
    grant_db $ip
done

