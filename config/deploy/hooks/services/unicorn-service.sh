unicorn_init_script=/usr/local/bin/unicorn-ctl

service_unicorn(){
  if [ -f "${unicorn_init_script}" ] ; then
    echo "Executing ${unicorn_init_script} $1"
    $unicorn_init_script $1
  fi
}

stop_unicorn(){
  service_unicorn stop
}

start_unicorn(){
  service_unicorn start
}

restart_unicorn(){
  service_unicorn restart
}
