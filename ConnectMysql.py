# -*- coding: utf-8 -*-

import pymysql
import time
import warnings

warnings.filterwarnings("ignore")


class ConnectMysql(object):
    def __init__(self):
        #         这里设置分页查询, 每页查询多少数据
        self.page_size = 5000

    def getTable(self):
        conn = pymysql.connect(
            host="113.16.195.18",
            port=3307,
            user="root",
            passwd="12345678",
            db='cgx_zcgl',
            charset='utf8'
        )
        conn_local = pymysql.connect(
            host="127.0.0.1",
            port=3306,
            user="root",
            passwd="12345678",
            db='cgx_zcgl2',
            charset='utf8'
        )
        cur = conn.cursor()
        cur_local = conn_local.cursor()
        cur.execute('show tables')
        tables = cur.fetchall()
        for table in tables:
            print( str(table[0]).lower())
            # 需要迁移的数据库查询表的列数
            cur.execute("SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='cgx_zcgl' AND table_name='" + table[0] + "'")
            table_col_count = cur.fetchone()
            # print( table_col_count[0]
            # 需要迁移的数据库查询表的结构
            cur.execute('show create table ' + table[0])
            result = cur.fetchall()
            create_sql = result[0][1]
            # 查询需要迁移的数据库表的数据条数
            cur.execute('select count(*) from ' + table[0])
            total = cur.fetchone()
            page = total[0] / self.page_size
            page1 = total[0] % self.page_size
            if page1 != 0:
                page = page + 1

            # 阿里云数据库创建表
            ll = "SELECT table_name FROM information_schema.`TABLES` WHERE table_schema='cgx_zcgl2' AND table_name='" + str(table[0]).lower() + "'"
            cur_local.execute(ll)
            table_name = cur_local.fetchone()
            if table_name is None:
                cur_local.execute(create_sql)
            for p in range(0, int(page)):
                count1 =0
                while True:
                    try:
                        print( '开始', table[0], '的第', p + 1, '页查询')
                        if p == 0:
                            limit_param = ' limit ' + str(p * self.page_size) + ',' + str(self.page_size)
                        else:
                            limit_param = ' limit ' + str(p * self.page_size + 1) + ',' + str(self.page_size)
                        cur.execute('select * from ' + table[0] + limit_param)
                        inserts = cur.fetchall()
                        print( '查询成功')
                        param = ''
                        for i in range(0, table_col_count[0]):
                            param = param + '%s,'
                        print( '开始插入')
                        resql = 'replace into ' + table[0] + ' values (' + param[0:-1] + ')'
                        cur_local.executemany(resql, inserts)
                        print( table[0], '的第', p + 1, '页, 插入完成, 还有', page - p - 1, '页, 任重而道远')
                        conn_local.commit()
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
        cur_local.close()
        conn_local.close()
        cur.close()
        conn.close()


if __name__ == '__main__':
    conn_mysql = ConnectMysql()
    conn_mysql.getTable()

#
# import pymysql
#
# class DB():
#     def __init__(self, host='localhost', port=3306, db='cgx_zcgl', user='root', passwd='12345678', charset='utf8'):
#         # 建立连接
#         self.conn = pymysql.connect(host=host, port=port, db=db, user=user, passwd=passwd, charset=charset)
#         # 创建游标，操作设置为字典类型
#         self.cur = self.conn.cursor(cursor = pymysql.cursors.DictCursor)
#
#     def __enter__(self):
#         # 返回游标
#         return self.cur
#
#     def __exit__(self, exc_type, exc_val, exc_tb):
#         # 提交数据库并执行
#         self.conn.commit()
#         # 关闭游标
#         self.cur.close()
#         # 关闭数据库连接
#         self.conn.close()
#
#
# if __name__ == '__main__':
#     # with DB(host='113.16.195.18',port=3307,user='root',passwd='12345678',db='cgx_zcgl') as db:
#     #     rst =  db.execute('select id,sto_id,ssys_year,ssys_server_num,ssys_server_storage_total,ssys_cpu_num,ssys_memory,remark,process,inspect_time,del_flag from iam_sto_sys where id ="1210134982496890882"').fetchone()
#     #     print(rst)
#         #需要同步的数据库
#         conn = pymysql.connect(
#             host="113.16.195.18",
#             port=3307,
#             user="root",
#             passwd="12345678",
#             db='cgx_zcgl',
#             charset='utf8'
#         )
#         #前置库
#         conn_pre = pymysql.connect(
#             host="113.16.195.18",
#             port=3307,
#             user="root",
#             passwd="12345678",
#             db='cgx_zcgl2',
#             charset='utf8'
#         )
#         cur = conn.cursor()
#         cur_pre = conn_pre.cursor()
#         cur.execute('select id,sto_id,ssys_year,ssys_server_num,ssys_server_storage_total,ssys_cpu_num,ssys_memory,remark,process,inspect_time,del_flag from iam_sto_sys where id ="1210134982496890882"')
#         trigger_result_list = cur.fetchone()
#         print(type(trigger_result_list))
#         print(str(trigger_result_list))
#         sql = 'update'
#
#
#
