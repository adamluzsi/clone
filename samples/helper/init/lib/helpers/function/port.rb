def get_port(mint_port,max_port,host="0.0.0.0")

  require 'socket'
  mint_port= mint_port.to_i
  begin
    server = TCPServer.new(host, mint_port)
    server.close
    return mint_port
  rescue Errno::EADDRINUSE
    pmint_portort = mint_port.to_i + 1  if mint_port < max_port+1
    retry
  end

end