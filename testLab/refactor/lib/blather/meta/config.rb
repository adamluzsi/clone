module XMPP
  class CONFIG
    JID  =      Application.config['blather']['xmpp']['XMPP']['JID']
    PWD  =      Application.config['blather']['xmpp']['XMPP']['PWD']
    HOST =      Application.config['blather']['xmpp']['XMPP']['HOST']        || '0.0.0.0'
    PORT =      Application.config['blather']['xmpp']['XMPP']['PORT']        || '5222'
    TIMEOUT=    Application.config['blather']['xmpp']['XMPP']['TIMEOUT']     || 30
    SLEEP_TIME= Application.config['blather']['xmpp']['XMPP']['SLEEP_TIME']  || 0.2
    MSG=        Application.config['blather']['xmpp']['XMPP']['MSG']         || {'version'=>'v0','path'=>'/default','method'=>'GET'}
  end
end