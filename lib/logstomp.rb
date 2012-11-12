require "uri"
require "tai64"
require "stomp"
require "builder"
require "logstomp/version"

module Logstomp
  class Command
    attr_accessor :argv
    private :argv=, :argv

    attr_accessor :start_at
    private :start_at=, :start_at

    def initialize argv
      self.argv = argv
      self.start_at = Time.now
    end

    def connection_string
      return "stomp://127.0.0.1:61613/topic/logs.#{tag}" unless argv[1]
      argv[1]
    end

    def uri
      URI.parse connection_string
    end

    def destination
      uri.path
    end

    def tag
      argv[0] || "default"
    end

    def hostname
      @hostname ||= %x[hostname].strip.split(/\./)[0]
    end

    def client
      @client ||= Stomp::Client.new connection_string
    end

    def broadcast event
      puts [ uri.to_s, event.to_s ].join("\n") if $DEBUG
      client.publish destination, event
    end

    def disconnect
      client.close
    end

    def batch_id
      @batch_id ||= [
        "h#{hostname}",
        "p#{Process.pid.to_s(36)}",
        "t#{Time.now.to_i.to_s(36)}",
        "r#{rand(1_000_000_000_000).to_s(36)}"
      ].join('.')
    end

    def execute
      m = %Q(<?xml version="1.0" encoding="UTF-8"?>
<event>
  <meta>
    <tag>%s</tag>
    <hostname>%s</hostname>
    <batch_id>%s</batch_id>
  </meta>
  <entry>
    <time tai64n="%s"/>
    <text><![CDATA[%s]]></text>
  </entry>
</event>)

      STDIN.each_line do |l|
        label, line = l.split(/ /, 2)
        line.strip!
        broadcast m % [ label, tag, hostname, batch_id, line ]
      end
      disconnect
    end
  end
end
