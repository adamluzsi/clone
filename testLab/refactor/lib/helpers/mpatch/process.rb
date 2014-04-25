module Process
  def self.daemonize
    File.create Logger.pid_path,'a+'
    File.create Logger.log_path,'a+'
    File.create Logger.daemon_stderr,'a+'
    DaemonOgre::Daemon.start fork,
                             Logger.pid_path,
                             Logger.log_path,
                             Logger.daemon_stderr
  end
  def self.stop
    Daemon.stop
  end
end