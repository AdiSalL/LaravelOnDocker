# Stop containers
docker-compose down

# Hapus container dan rebuild
docker-compose build --no-cache

# Fix permissions di host system
sudo chown -R $USER:$USER ./storage ./bootstrap/cache
chmod -R 775 ./storage ./bootstrap/cache

# Start ulang
docker-compose up -d

# Atau masuk ke container dan fix permissions
docker-compose exec php chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
docker-compose exec php chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache