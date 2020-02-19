# HDFS Data Cleanup

To automatically delete the data stored in HDFS we need to set up a cronjob running as a service account. The period can be defined as a parameter.

## Login as service account

```
sudo -i -u <service-account>
```

## Copy the script
Copy the script cleanup_hdfs.sh to the home directory of the service account. For example in in this folder:
```
mkdir scripts
mkdir logs
cd scripts
vi cleanup_hdfs.sh
# copy the content to the file
chmod 755 cleanup_hdfs.sh
```

## Cronjob

Then set up a cronjob:
```
crontab -e
```

Content (the first parameter is the retention time in days):
```
# clean up HDFS every day at midnight
0 0 * * * ~/scripts/cleanup_hdfs.sh 30 /data/path/ >> ~/logs/cleanup.log
```