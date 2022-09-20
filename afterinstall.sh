#!/bin/bash
# deploy/afterinstall

exec &>> /home/ec2-user/akaunting_deployment.log

set -o allexport; source .env; set +o allexport

echo "`date` After Install Actions by $USER on $APP_SERVER_DESIGNATION server for Akaunting"

echo "`date` Change storage folder permissions"

sudo chmod 777 /usr/share/nginx/akaunting/storage -R

echo "`date` Change root folder ownership"

sudo chown ec2-user:root /usr/share/nginx/akaunting -R

echo "`date` Create Log File"

touch /usr/share/nginx/akaunting/storage/logs/laravel.log

echo "`date` Change Log folder permissions"

sudo chmod 777 /usr/share/nginx/akaunting/storage/logs -R

cd /usr/share/nginx/akaunting

if ! command -v npm &> /dev/null
then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    echo "Exporting NPM $NPM_DIR"
fi

npm install

# composer update
echo "`date` Install/Update Composer Modules"

composer install

npm run production

echo "`date` Clear Laravel Cache"

php artisan config:cache

sudo php artisan cache:clear

exit 0
