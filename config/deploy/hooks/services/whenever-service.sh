whenever_bin="${current_app_path}/bin/whenever"

wheneverize(){
  [[ -f ${whenever_bin} ]] && cd ${current_app_path} && ${whenever_bin} --write-crontab --set "environment=${FRAMEWORK_ENV}"
}

wheneverize_worker(){
  [[ "${SERVER_ROLE}" == "worker" ]] && wheneverize
}
