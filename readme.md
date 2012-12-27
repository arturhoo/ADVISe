# ADVISe

We introduce an interactive visualization called ADVISe, which tackles the
problem of visualizing evolutions in enzyme annotations across several releases
of the UniProt/SwissProt database. More specifically, we visualize the dynamics
of Enzyme Commission numbers (EC numbers), which are a numerical and
hierarchical classification scheme for enzymes based on the chemical reactions
they catalyze.

## Configuration

### Database

ADVISe uses data stored in a MySQL database. Please set up your environment
according to instructions of the [MySQL website][mysql].

You must then download the [database dump of our project][dump], untar the file
and apply it to your database:

    $ tar xvfj ADVISe.tar.bz2
    $ mysql -u <your_username> -p <database_to_be_used> < ADVISe.sql


### Processing

The Processing code is located on the `Processing/ADVISe` folder, and should run
on major operating systems. To download the Processing Sandbox go to
[the website][processing].

You need to download the SQLibrary by Florian Jenett at [this link][sqlibrary]
and follow the instructions on the same link.

The template file `mysql_settings.txt.template` should be used to tell the
program how to access your database:

    $ cp mysql_settings.txt.template mysql_settings.txt

After that, simply edit it to match your database configuration


## License

Released under the [MIT License][license].


[sqlibrary]:http://bezier.de/processing/libs/sql/
[processing]:http://www.processing.org/
[license]:https://github.com/arturhoo/ADVISe/blob/master/LICENSE.md
[mysql]:http://dev.mysql.com/downloads/mysql/
[dump]:https://s3.amazonaws.com/artur/ADVISe.tar.bz2
