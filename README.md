# bitbucket_2_discord_webhook

simple web app to translate Bitbucket webhook to Discord.

to start -
1) fill the config with you discord webhook url
2) then start server with -  morbo discord_bitbucket_webhook.pl  
3) by default it will listen on 3000 port
4) then you need to create Bitbucket webhook with this server url, e.g. 12.34.123.43:3000

Bitbucket webhooks doc - https://confluence.atlassian.com/bitbucket/event-payloads-740262817.html
Discord webhooks doc - https://discordapp.com/developers/docs/resources/webhook
