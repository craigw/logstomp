# Logstomp

Broadcast logs via Stomp.

## Installation

    $ gem install logstomp

## Usage

I had this in mind to be used as a log processor for `svlogd` logs where you've
told `svlogd` to use tai64n labels in the logs.

In `/service/$foo/log/config` add a line like this:

    !/usr/bin/logstomp log_tag stomp://yourmq.com:61613/topic/logs.service_name

Whenever `svlogd` rotates the logs you'll now get an event in the following
format on `/topic/logs.service_name`:

    <?xml version="1.0" encoding="UTF-8"?>
    <event>
      <time tai64n="@4000000050a17673000001f4" iso8601="2012-11-12T22:21:29Z"/>
      <meta>
	<tag>
	  <![CDATA[log_tag]]>
	</tag>
	<hostname>
	  <![CDATA[zuu.local]]>
	</hostname>
	<batch_id>zuu.local-l8s-mdec37-55y3hhr9</batch_id>
      </meta>
      <entry>
	<text>
	  <![CDATA[The logged line will appear here]]>
	</text>
      </entry>
    </event>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
