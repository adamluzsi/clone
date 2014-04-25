module XMPP
  class CONFIG
    JID  =      BLATHER_CONFIG['XMPP']['JID']
    PWD  =      BLATHER_CONFIG['XMPP']['PWD']
    HOST =      BLATHER_CONFIG['XMPP']['HOST']        || '0.0.0.0'
    PORT =      BLATHER_CONFIG['XMPP']['PORT']        || '5222'
    TIMEOUT=    BLATHER_CONFIG['XMPP']['TIMEOUT']     || 30
    SLEEP_TIME= BLATHER_CONFIG['XMPP']['SLEEP_TIME']  || 0.2
    MSG=        BLATHER_CONFIG['XMPP']['MSG']         || {'version'=>'v0','path'=>'/default','method'=>'GET'}
  end
end