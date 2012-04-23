Biovis
======

Configuration
-------------

You must have two tables in your MySQL schema, `id_ec` and `id_ec_atributo`.

To start off, setup your basic dev system environment. Make sure you follow the on-screen instructions

    $ sudo apt-get install mysql-server python-setuptools subversion python-svn mercurial git-core python-git bzr python-dev libmysqlclient-dev python-mysqldb

Instal virtualenv and setup a clean environment

    $ sudo easy_intall virtualenv
    $ virtualenv --no-site-packages biovis

Install the necessary python packages

    $ . biovis/bin/activate
    $ pip install mysql-python uuid

Create a new database on MySQL

    $ mysql -uroot -p
    mysql> create database <name_of_the_db>;


Time to create the necessary tables for the visualization.

    $ mysql -uroot -p <name_of_the_db_you_created> < sqlscripts/id_ec_num.sql
    $ mysql -uroot -p <name_of_the_db_you_created> < sqlscripts/id_ec_atributo_num.sql
    $ mysql -uroot -p <name_of_the_db_you_created> < sqlscripts/nivel1.sql

Go to the `python` folder and edit your `mysql_local_settings.py` to your configuration

    $ cp mysql_local_settings.py.template mysql_local_settings.py

You will have to fix the ECs for five proteins in both the `id_ec` and `id_ec_atributo` tables. Their
`indice` fields are `809633`, `879653`, `1005944`, `1080973` and `1216344`. The EC fields with the values
`'1.1..-' must be changed to `1.1.-.-`3. Here is one example:

    mysql> update biovis.id_ec_atributo set ec_novo = '1.1.-.-' where indice = 1005944;

Time to run the scripts

    $ python p1.py
    $ python p2.py
    $ python p3.py

After running the scripts above, the database will have three new tables,
`nivel1`, `id_ec_num` and `id_ec_atributo_num`. Finally, indices must be created for the two
latter tables:

    $ mysql -uroot -p
    mysql> create index i1 on id_ec_num(ver_estudo, prefixo);
    mysql> create index i1 on id_ec_atributo_num(ver_estudo, prefixo);
    mysql> create index i2 on id_ec_atributo_num(ver_estudo, prefixo, subidas, descidas, ec_ant0, ec_novo0);

The Processing code is located on the `prot2` folder, and should run on major operating systems. To
download the Processing Sandbox go to http://www.processing.org .

You need to download the SQLibrary by Florian Jenett at [this link][sqlibrary] and follow the
instructions on the same website.

You need to configure the file `mysql_settings.txt.template` to match
your database's configuration. Then simply rename the file:

    $ cp mysql_settings.txt.template mysql_settings.txt

[sqlibrary]:http://bezier.de/processing/libs/sql/

