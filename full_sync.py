# -*- coding: utf-8 -*-

import pymysql
import time
import warnings

warnings.filterwarnings("ignore")

##全量同步（process=4）
class full_sync(object):
    def __init__(self):
        #         这里设置分页查询, 每页查询多少数据
        self.page_size = 5000

    def getTable(self):
        conn = pymysql.connect(
            host="10.4.1.41",
            # host="59.211.216.20",
            port=3306,
            user="root",
            passwd="Cloud@iam.com2019",
            db='cgx_zcgl',
            charset='utf8'
        )
        conn_local = pymysql.connect(
            host="10.4.1.41",
            # host="59.211.216.21",
            port=3306,
            user="root",
            passwd="Cloud@iam.com2019",
            db='cgx_zcgl',
            charset='utf8'
        )
        cur = conn.cursor()
        cur_local = conn_local.cursor()
        # 需要迁移的数据库查询表的列数从前置库取需要同步的表
        cur_local.execute('show tables')
        tables = cur_local.fetchall()
        count_all=0
        print("全量同步列表名")
        for table in tables:
            print( str(table[0]).lower())
        for table in tables:
            if "sys_depart"==table[0]:
                print("表sys_depart 不做全量同步")
                break
            count_finish=0
            cur.execute("SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='cgx_zcgl' AND table_name='" + table[0] + "'")
            table_col_count = cur.fetchone()
            # print( table_col_count[0]
            # 需要迁移的数据库查询表的结构
            # cur.execute('show create table ' + table[0])
            # result = cur.fetchall()
            # create_sql = result[0][1]
            # 查询需要迁移的数据库表的数据条数
            cur.execute('select count(*) from ' + table[0])
            total = cur.fetchone()
            page = total[0] / self.page_size
            page1 = total[0] % self.page_size
            if page1 != 0:
                page = page + 1

            # 阿里云数据库创建表
            # ll = "SELECT table_name FROM information_schema.`TABLES` WHERE table_schema='cgx_zcgl' AND table_name='" + str(table[0]).lower() + "'"
            # cur_local.execute(ll)
            # table_name = cur_local.fetchone()
            # if table_name is None:
            #     cur_local.execute(create_sql)
            for p in range(0, int(page)):
                count1 =0
                while True:
                    try:
                        print( '开始', table[0], '的第', p + 1, '页查询')
                        if p == 0:
                            limit_param = ' limit ' + str(p * self.page_size) + ',' + str(self.page_size)
                        else:
                            limit_param = ' limit ' + str(p * self.page_size + 1) + ',' + str(self.page_size)
                        selectByIdSql = 'select * from '+table[0]
                        if -1!=str(table[0]).find('iam'):
                            selectByIdSql+=' where process=4 '
                        print(selectByIdSql)
                        cur.execute(selectByIdSql + limit_param)
                        inserts = cur.fetchall()
                        print( '查询成功')
                        cur_local.execute("delete from "+table[0])
                        param = ''
                        for i in range(0, table_col_count[0]):
                            param = param + '%s,'
                        print( '开始插入')
                        resql = 'replace into ' + table[0] + ' values (' + param[0:-1] + ')'
                        cur_local.executemany(resql, inserts)
                        # print( table[0], '的第', p + 1, '页, 插入完成, 还有', page - p - 1, '页, 任重而道远')
                        conn_local.commit()
                        count_finish+=len(inserts)
                        break
                    except Exception as e:
                        print( e)
                        # time.sleep(60)
                        cur = conn.cursor()
                        cur_local = conn_local.cursor()
                        count1 +=1
                        if(5==count1):
                            print( table[0], ' 插入失败')
                            break
                print( table[0], ' 插入完成')
                print( '\n \n ======================================================================== \n\n')
            print( "表",str(table[0]).lower(),"同步数据量：",str(count_finish))
            count_all+=count_finish
        print( "本次共同步数据量：",str(count_all))
        cur_local.close()
        conn_local.close()
        cur.close()
        conn.close()


if __name__ == '__main__':
    conn_mysql = full_sync()
    conn_mysql.getTable()
