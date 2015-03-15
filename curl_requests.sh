curl -s -X POST http://6bc875e0.ngrok.com -H 'Content-Type: application/json' -d '{"MediaUrl0": "https://api.twilio.com/2010-04-01/Accounts/AC3f1514f866d470cfd68ab42d9743752b/Messages/MM8f39eb3ae6940ee53f02be1ab783c29e/Media/MEe51b13c8f2d5d9baadd58798fcb664b8", "From": "+15169671237", "To":"+15164505983"}'

curl -s -X POST http://6bc875e0.ngrok.com -H 'Content-Type: application/json' -d '{"Body": "Steak:20.00\na:7.50\nb:Ice Cream\nc:Hamburger:7.50\nd:delete", "From": "+15169671237", "To":"+15164505983"}'

curl -s -X POST http://6bc875e0.ngrok.com -H 'Content-Type: application/json' -d '{"Body": "Bloody Mary:4.00\nh:4.00\nc:delete", "From": "+15169671237", "To":"+15164505983"}'

curl -s -X POST http://6bc875e0.ngrok.com -H 'Content-Type: application/json' -d '{"Body": "More stuff:19.00\nOtherstuff:100.00", "From": "+15169671237", "To":"+15164505983"}'
curl -s -X POST http://6bc875e0.ngrok.com -H 'Content-Type: application/json' -d '{"Body": "ok", "From": "+15169671237", "To":"+15164505983"}'
