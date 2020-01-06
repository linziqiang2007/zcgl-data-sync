# -*- coding: utf-8 -*-

import pymysql
import time
import warnings

warnings.filterwarnings("ignore")

##
class ConnectMysql(object):

    def fullSync(self):
        self.page_size = 5000
        ## TODO

    def incremSync(self):
        #需要同步的数据库
        conn = pymysql.connect(
            host="113.16.195.18",
            port=3307,
            user="root",
            passwd="12345678",
            db='cgx_zcgl',
            charset='utf8'
        )
        #前置库
        conn_pre = pymysql.connect(
            host="113.16.195.18",
            port=3307,
            user="root",
            passwd="12345678",
            db='cgx_zcgl2',
            charset='utf8'
        )
        cur = conn.cursor()
        cur_pre = conn_pre.cursor()
        #从数据库的数据更新记录表获取需要更新的数据ID和表名，采用触发器机制记录更新数据
        cur.execute('select DISTINCT(table_id),table_name,update_type from iam_trigger_record  ORDER BY table_name desc,create_time desc')
        trigger_result_list = cur.fetchall()
        print('本次需要更新记录 '+str(len(trigger_result_list)) + ' 条')
        updateTabkesSet = set()
        # updateIdSet = set()
        updateTabkesDict = {}   #字典存放表名:表字段列表

        for triggerResult in trigger_result_list:
            updateTabkesSet.add(triggerResult[1])
        for table_name in updateTabkesSet:
            updateTabkesColumn = ""
            column_name_sql = 'select column_name from information_schema.columns where table_name="'+table_name+'" and table_schema=\'cgx_zcgl2\' '
            cur_pre.execute(column_name_sql)
            column_names = cur_pre.fetchall()
            for column_name in column_names:
                updateTabkesColumn+=str(column_name)
            updateTabkesDict[table_name]=updateTabkesColumn.replace("'","").replace("(","").replace(")","")[:-1] #去除最后一个逗号
        updateCount =0
        for triggerResult in trigger_result_list:
            errorcount =0
            while True:
                try:
                    print('本条记录信息ID: '+str(triggerResult[0])+' 表名 '+str(triggerResult[1])+' 更新类型 '+str(triggerResult[2]))
                    # deleteSql = 'delete from '+ str(triggerResult[1]) + ' where id = %s'
                    # rows = cur_pre.execute(deleteSql,str(triggerResult[0]))
                    # print("删除了"+str(rows)+"行")
                    selectByIdSql = 'select '+(updateTabkesDict[triggerResult[1]]) + ' from '+str(triggerResult[1])+ ' where id = %s'
                    cur.execute(selectByIdSql,str(triggerResult[0]))
                    resuleOne = cur.fetchall()
                    param = ''
                    column_names_len = len(str(updateTabkesDict[triggerResult[1]]).split(","))
                    for i in range(0, column_names_len):
                        param = param + '%s,'
                    # inserSql = 'insert into '+ str(triggerResult[1]) +' set ('+ updateTabkesDict[triggerResult[1]] +') values ('+ param[0:-1]  + ')'
                    # inserParam = '('+str(resuleOne).replace("(","").replace(")","").replace("\\","").replace("None","")[:-1]+')'
                    # cur_pre.execute(inserSql,inserParam)
                    #replace into 跟 insert 功能类似，不同点在于：replace into 首先尝试插入数据到表中
                    #如果发现表中已经有此行数据（根据主键或者唯一索引判断）则先删除此行数据，然后插入新的数据。 2. 否则没有此行数据的话，直接插入新数据。
                    #插入数据的表必须有主键或者是唯一索引！否则的话，replace into 会直接插入数据，这将导致表中出现重复的数据。
                    replaceSql = 'replace into ' + str(triggerResult[1]) + ' values (' + param[0:-1] + ')'
                    # print (replaceSql)
                    cur_pre.executemany(replaceSql, resuleOne)
                    conn_pre.commit()
                    updateCount+=1
                    break
                except Exception as e:
                    print(e)
                    # time.sleep(10)
                    cur = conn.cursor()
                    cur_pre = conn_pre.cursor()
                    errorcount+=1
                    if(5==errorcount):
                        print('表 ',triggerResult[1],triggerResult[0], ' 更新失败')
                        break
            if(5!=errorcount):
                print('表 ',triggerResult[1],triggerResult[0], ' 更新完成')
        print( '本次更新完成'+str(updateCount)+'条')
        cur_pre.close()
        conn_pre.close()
        cur.close()
        conn.close()

if __name__ == '__main__':
    conn_mysql = ConnectMysql()
    conn_mysql.incremSync()
