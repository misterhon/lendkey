# Init script for VVV LendKey Dev

echo "Commencing LendKey Dev Setup"

# Make a database, if we don't already have one
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS lendkey_dev"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON lendkey_dev.* TO wp@localhost IDENTIFIED BY 'wp';"

# Run Composer
composer install --prefer-dist

# Download WordPress
if [ ! -f htdocs/wp-config.php ]
then
	echo "Creating wp-config.php and installing WordPress"
	wp core config --dbname="lendkey_dev" --dbuser=wp --dbpass=wp --dbhost="localhost" --extra-php <<PHP
define( 'WP_CONTENT_DIR', dirname(__FILE__) . '/wp-content/' );
define( 'WP_SITEURL',     'http://lendkey.dev/wordpress/');
PHP
	mv htdocs/wordpress/wp-config.php htdocs/
	wp core install --url=lendkey.dev --title="LendKey Dev" --admin_user=lendkey --admin_password=ironpaper --admin_email=alex@ironpaper.com
	wp option update permalink_structure "/%postname%/"
fi

# The Vagrant site setup script will restart Nginx for us

echo "LendKey Dev Site now installed";

