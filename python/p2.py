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
                	
            	except Exception, err:
                print err

conn.commit()
c.close()