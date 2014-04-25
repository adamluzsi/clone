class Exception
  def logger
    logger.create Logger.exceptions,'a+'
    Logger.update_logg(self.backtrace,self,Logger.exceptions)
  end
end