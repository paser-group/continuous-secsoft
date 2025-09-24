# == Class cdh::hive::metastore::mysql
# Configures and sets up a MySQL metastore for Hive.
#
# Note that this class does not support running
# the Metastore database on a different host than where your
# hive-metastore service will run.  Permissions will only be granted
# for localhost MySQL users, so hive-metastore must run on this node.
#
# Also, root must be able to run /usr/bin/mysql with no password and have permissions
# to create databases and users and grant permissions.
#
# See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH5-Installation-Guide/cdh5ig_hive_metastore_configure.html
#
class cdh::hive::metastore::mysql {
    Class['cdh::hive'] -> Class['cdh::hive::metastore::mysql']

    if (!defined(Package['libmysql-java'])) {
        package { 'libmysql-java':
            ensure => 'installed',
        }
    }
    # symlink the mysql.jar into /var/lib/hive/lib
    file { '/usr/lib/hive/lib/libmysql-java.jar':
        ensure  => 'link',
        target  => '/usr/share/java/mysql.jar',
        require => Package['libmysql-java'],
    }

    $db_name = $cdh::hive::jdbc_database
    $db_user = $cdh::hive::jdbc_username
    $db_pass = $cdh::hive::jdbc_password

    # Only use -u or -p flag to mysql commands if
    # root username or root password are set.
    $username_option = $cdh::hive::db_root_username ? {
        undef   => '',
        default => "-u'${cdh::hive::db_root_username}'",
    }
    $password_option = $cdh::hive::db_root_password ? {
        undef   => '',
        default => "-p'${cdh::hive::db_root_password}'",
    }

    # Hive metastore MySQL database need a hive database and user.
    exec { 'hive_mysql_create_database':
        command => "/usr/bin/mysql ${username_option} ${password_option} -e 'CREATE DATABASE ${db_name}; USE ${db_name};'",
        unless  => "/usr/bin/mysql ${username_option} ${password_option} -e 'SHOW DATABASES' | /bin/grep -q ${db_name}",
        user    => 'root',
    }
    exec { 'hive_mysql_create_user':
        command => "/usr/bin/mysql ${username_option} ${password_option} -e \"
CREATE USER '${db_user}'@'localhost' IDENTIFIED BY '${db_pass}';
CREATE USER '${db_user}'@'127.0.0.1' IDENTIFIED BY '${db_pass}';
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;\"",
        unless  => "/usr/bin/mysql ${username_option} ${password_option} -e \"SHOW GRANTS FOR '${db_user}'@'127.0.0.1'\" | grep -q \"TO '${db_user}'\"",
        user    => 'root',
    }

    # Run hive schematool to initialize the Hive metastore schema.
    exec { 'hive_schematool_initialize_schema':
        command => '/usr/lib/hive/bin/schematool -dbType mysql -initSchema',
        unless  => "/usr/bin/mysql ${username_option} ${password_option} -D ${db_name} -e \"SHOW TABLES;\" | grep -q 'VERSION'",
        user    => 'root',
        require => [
            File['/usr/lib/hive/lib/libmysql-java.jar'],
            Exec['hive_mysql_create_user'],
            Exec['hive_mysql_create_database'],
        ],
    }
}