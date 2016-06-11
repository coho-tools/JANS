function java_useThread(ind)
  assert(ind>0 && ind<=jans_cfg('get','javaThreads'))
  jans_cfg('set','currThread',ind);
end
