# Installing Ruby

Use rbenv and the ruby-build plugin

* [rbenv](https://github.com/sstephenson/rbenv/)
* [ruby-build](https://github.com/sstephenson/ruby-build)

# Quick installation

```shell
$ brew install redis elasticsearch imagemagick postgresql memcached
```

To have ElasticSearch start on login:

```
ln -sfv /usr/local/opt/elasticsearch/*.plist ~/Library/LaunchAgents
```

Then to load ElasticSearch now:

```
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.elasticsearch.plist
```
