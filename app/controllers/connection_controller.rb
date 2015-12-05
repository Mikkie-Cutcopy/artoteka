require 'redis'
require 'json'
require 'imaginarium/message_adapter'


class ConnectionController < ApplicationController
  def socket_listen
    Imaginarium::MessageAdapter.start_socket_listen(env)
    render text: nil, status: -1
  end
end
