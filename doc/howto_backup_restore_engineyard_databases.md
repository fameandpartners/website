## HOWTO Backup and Restore an EngineYard Database to Another Environment

## Source Documentation


 - [EY - View-and-Download-Database-Backups](https://support.cloud.engineyard.com/hc/en-us/articles/205408078-View-and-Download-Database-Backups)
 - [EY - Back-Up-the-Database](https://support.cloud.engineyard.com/hc/en-us/articles/205408068-Back-Up-the-Database)
 - [EY - Restore-or-Load-a-Database](https://support.cloud.engineyard.com/hc/en-us/articles/205408058-Restore-or-Load-a-Database)

## Steps
#### 1. SSH into Source Environment

Here you can either download most recent backup, or take a new backup, then download

##### (Optional) Take a new backup

```shell
sudo -i eybackup -e postgresql --new-backup
```

##### Download most recent backup

```shell
sudo -i eybackup -e postgresql --list-backup fame_and_partners
```

Given we are currently configured to keep 30 backups, you can always just get the most recent downloaded onto the box you are on by running this command. (note backup file list is `0` indexed, hence the `29`)

```shell
sudo -i eybackup -e postgresql --download 29:fame_and_partners
```

You will see something like this;

```
Downloading production_new.fame_and_partners/fame_and_partners.2015-07-16T23-51-03.dump to /mnt/tmp
```

You should now have a file in `/mnt/tmp`, which you can SCP from the prod database server to other servers, let's do that now.

#### SCP backup file to `$env`

```shell
scp /mnt/tmp/fame_and_partners.DATETIME.dump  DESTINATION_HOST.amazonaws.com:~
```

##### e.g.

```shell
scp /mnt/tmp/fame_and_partners.2015-07-16T23-51-03.dump  ec2-54-242-44-126.compute-1.amazonaws.com:~
```

#### SSH into destination EY Env & Restore the dump you uploaded

```shell
ssh DESTINATION_HOST.amazonaws.com:
pg_restore -d fame_and_partners ./fame_and_partners.DATETIME.dump  --clean -U postgres
```

##### e.g.

```shell
ssh ec2-54-242-44-126.compute-1.amazonaws.com
pg_restore -d fame_and_partners ./fame_and_partners.2015-07-16T23-51-03.dump  --clean -U postgres
```


