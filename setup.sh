cd docker

cp local.env.sample.development local.env

sudo ./build.sh postgres

sudo ./build.sh solr

sudo ./compose.local.sh up -d postgres

sudo ./compose.local.sh run solr make-primero-core.sh primero-test

sudo ./compose.local.sh up -d solr

cd ..

sudo dnf install -y libpq5 imagemagick libsodium-dev p7zip

bundle install

cp config/database.yml.development config/database.yml

cp config/locales.yml.development config/locales.yml

cp config/mailers.yml.development config/mailers.yml

cp config/sunspot.yml.development config/sunspot.yml

echo "export PRIMERO_SECRET_KEY_BASE=PRIMERO_SECRET_KEY_BASE" >> ~/.bashrc

echo "export DEVISE_SECRET_KEY=DEVISE_SECRET_KEY" >> ~/.bashrc

echo "export DEVISE_JWT_SECRET_KEY=DEVISE_JWT_SECRET_KEY" >> ~/.bashrc

rails secret

echo "export PRIMERO_MESSAGE_SECRET=PRIMERO_MESSAGE_SECRET" >> ~/.bashrc

source ~/.bashrc

bin/rails primero:i18n_js

foreman start -f Procfile.dev
