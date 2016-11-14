{% from "restify/map.jinja" import map with context %}

restify-carton:
  cmd.run:
    - name: carton install --deployment --cached
    - cwd: {{ map.folder }}
    - runas: {{ map.user }}

restify-migrate:
  cmd.run:
    - name: carton exec perl script/scrabblicious migrate --latest
    - cwd: {{ map.folder }}
    - runas: {{ map.user }}
