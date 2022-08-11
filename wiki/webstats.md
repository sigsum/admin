With access logs from listen.so.

```
sudo apt install goaccess
mkdir db
gzip -cdf access.log* | goaccess --log-format VCOMMON --persist --db-path db -o report.html -
```

To add more data to an existing db:

```
cat new-accesslog | goaccess --log-format VCOMMON --restore --persist --db-path db -o report.html -
```
