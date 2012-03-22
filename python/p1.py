#coding: utf-8
import MySQLdb
import uuid

try:
    from mysql_local_settings import *
except ImportError:
    sys.exit("No MySQL settings found!")

conn = MySQLdb.connect( host=host, \
                        user=user, \
                        passwd=passwd, \
                        db=db, \
                        charset='utf8', \
                        use_unicode=True, \
                        init_command='SET NAMES utf8')
c = conn.cursor()

for i in range(2,16):
    for j in range(4):
            for k in range(0,5-j):
            for l in range(0,5-j):
                t = (i, j, k, l)
                try:
                    c.execute('''   select count(*) 
                                    from id_ec 
                                    where   ver_estudo = %s
                                    and     prefixo = %s
                                    and     subidas = %s
                                    and     descidas = %s''', t)
                except Exception, err:
                    print err

                for row in c:
                    print   "Version: " + str(i) + \
                            " Prefix: " + str(j) + \
                            " Subidas: " + str(k) + \
                            " Descidas: " + str(l) + \
                            " Count: " + str(row[0])

                    try:
                        t1 = (uuid.uuid4(), i, j, k, l, row[0])
                        c.execute('''   insert into nivel1
                                        values (%s, %s, %s, %s, %s, %s)''', t1)
                    except Exception, err:
                        print err

conn.commit()
c.close()