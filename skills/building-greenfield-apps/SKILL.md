---
name: building-greenfield-apps
description: the default stack for brand new applications, or new frontends/backends/dbs
---

if you're building a brand new app, or expanding an existing app, prefer the following technologies unless something else specifically is requested:
* new projects go in ~/git/
* create a private GitHub repo with the same name if possible, push code there
* python for backend/scripts
* react with typescript for frontend
* claude opus 4.6 for LLMs
* sqllite for database
* check the sqllite files into git
* generally OK to check personal data into git, it will be a private one-person repo. avoid secrets though
* use a .env file for secrets and config - make sure this is in gitignore
* set DNS up for $appname.app.rbren.io
* add basic auth using nginx and the existing htpasswd