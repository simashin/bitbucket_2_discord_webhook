# bitbucket_2_discord_webhook

simple web app to translate Bitbucket webhook to Discord.

Setup locally - 
1) Download a way to run PERL locally such as http://strawberryperl.com/
2) Install into a random folder, C drive or other, does not matter
3) Fill the config with your discord webhook URLs
2) Choose whether you want development mode on or off by using 1 or 0
3) Navigate in PowerShell, CMD or VSCode terminal to the folder that contains discord_bitbucket_webhook.dl and app.conf
4) Start server with - 'perl discord_bitbucket_webhook.pl daemon'
    4a) if you want to include a specific port use '-l http://*:PORTNUMBER'
5) By default it will run on port 3000 (e.g. 127.0.0.1:3000)

Bitbucket webhooks doc - https://confluence.atlassian.com/bitbucket/event-payloads-740262817.html
Discord webhooks doc - https://discordapp.com/developers/docs/resources/webhook

Extra help to test locally -
1) In Bitbucket go to reposistory settings -> webhooks -> add webhook URL. (e.g. https://bitbucket.org/[Workspace ID]/[Repository Name]/admin/webhooks)
2) Name or url does not matter right now, but be sure to add something that is accepted.
3) After adding click on 'view requests' next to your newly added webhook and turn on Request History
4) Perform any action on your pull request / branch / whatever you set as trigger
5) Go back to the View Requests page
6) You will now be able to see actions performed by the Bitbucket webhook. Click on View Details.
7) Scroll down all the way and open Body
8) Copy and paste the body into a program such as Postman
9) Send this Body as POST to your locally chosen address (normally 127.0.0.1:3000)

Original was by: https://github.com/simashin
Modified by: https://github.com/Proxiart

Update reason:
I wanted to be able to send different messages / updates from different repositories into seperate discord channels.