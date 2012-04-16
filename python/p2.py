#coding: utf-8
import MySQLdb
import uuid
import re

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
c = conn.cursor(MySQLdb.cursors.DictCursor)

for i in range(1216298, 3281207):
    query = (i,)
    try:
        c.execute('''   select * 
                        from id_ec_atributo 
                        where indice = %s''', query)
    except Exception, err:
        print err

    row = c.fetchoneDict()
    re_ec_ant  = re.search(r'(\d+|-)\.(\d+|-)\.(\d+|-)\.(\d+|-)', row['ec_ant'])
    re_ec_novo = re.search(r'(\d+|-)\.(\d+|-)\.(\d+|-)\.(\d+|-)', row['ec_novo'])

    ec_ant_num  = []
    ec_novo_num = []

    for j in range(1, 5):
        try:
            if re_ec_ant.group(j) == '-':
                ec_ant_num.insert((j-1), -1)
            else:
                ec_ant_num.insert((j-1), re_ec_ant.group(j))

            if re_ec_novo.group(j) == '-':
                ec_novo_num.insert((j-1), -1)
            else:
                ec_novo_num.insert((j-1), re_ec_novo.group(j))

        except Exception, err:
            print i
            print err
    

    insert = (  row['indice'], \
                row['iduniprot'], \
                row['data_dep'], \
                row['ver_estudo'], \
                row['tipo_mud'], \
                ec_ant_num[0], \
                ec_ant_num[1], \
                ec_ant_num[2], \
                ec_ant_num[3], \
                ec_novo_num[0], \
                ec_novo_num[1], \
                ec_novo_num[2], \
                ec_novo_num[3], \
                row['prefixo'], \
                row['subidas'], \
                row['descidas'], \
                row['rp_antes'], \
                row['oc_antes'], \
                row['kw_antes'], \
                row['rp_depois'], \
                row['oc_depois'], \
                row['kw_depois'])

    try:
        c.execute('''   insert into id_ec_num
                        values (%s, %s, %s, %s, %s, %s,
                                %s, %s, %s, %s, %s, %s,
                                %s, %s, %s, %s, %s, %s,
                                %s, %s, %s, %s)''', insert)
    except Exception, err:
        print err

    if i%100 == 0:
        conn.commit()
        print i

conn.commit()
c.close()
