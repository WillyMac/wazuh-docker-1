#!/bin/bash

kibana_config_file="/usr/share/kibana/config/kibana.yml"
if grep -Fq  "#xpack features" "$kibana_config_file";
then 
  declare -A CONFIG_MAP=(
    [xpack.apm.ui.enabled]=$XPACK_APM
    [xpack.grokdebugger.enabled]=$XPACK_DEVTOOLS
    [xpack.searchprofiler.enabled]=$XPACK_DEVTOOLS
    [xpack.ml.enabled]=$XPACK_ML
    [xpack.canvas.enabled]=$XPACK_CANVAS
    [xpack.logstash.enabled]=$XPACK_LOGS
    [xpack.infra.enabled]=$XPACK_INFRA
    [xpack.monitoring.enabled]=$XPACK_MONITORING
    [xpack.maps.enabled]=$XPACK_MAPS
    [xpack.uptime.enabled]=$XPACK_UPTIME
    [console.enabled]=$XPACK_DEVTOOLS
  )
  for i in "${!CONFIG_MAP[@]}"
  do
    if [ "${CONFIG_MAP[$i]}" != "" ]; then
      sed -i 's/.'"$i"'.*/'"$i"': '"${CONFIG_MAP[$i]}"'/' $kibana_config_file
    fi
  done
else
  echo "
#xpack features
xpack.apm.ui.enabled: $XPACK_APM 
xpack.grokdebugger.enabled: $XPACK_DEVTOOLS
xpack.searchprofiler.enabled: $XPACK_DEVTOOLS
xpack.ml.enabled: $XPACK_ML
xpack.canvas.enabled: $XPACK_CANVAS
xpack.logstash.enabled: $XPACK_LOGS
xpack.infra.enabled: $XPACK_INFRA
xpack.monitoring.enabled: $XPACK_MONITORING
xpack.maps.enabled: $XPACK_MAPS
xpack.uptime.enabled: $XPACK_UPTIME
console.enabled: $XPACK_DEVTOOLS
xpack.security.sessionTimeout: 900000
server.ssl.cipherSuites: [\"HIGH\", \"!LOW\", \"!MEDIUM\", \"!SSLv2\", \"!ADH\", \"!EXP\", \"!MD5\", \"!RC4\", \"!3DES\", \"!CAMELLIA\", \"!aNULL\", \"!eNULL\", \"!DES\", \"!PSK\", \"!SRP\", \"!TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384\", \"!TLS_RSA_WITH_AES_256_GCM_SHA384\", \"!TLS_RSA_WITH_AES_256_CBC_SHA256\", \"@STRENGTH\"]

" >> $kibana_config_file
fi
