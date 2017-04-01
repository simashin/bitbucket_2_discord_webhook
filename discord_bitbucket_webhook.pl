#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use Mojolicious::Lite;
use Mojo::UserAgent; 
                                                                                                                                                              my $cfg = plugin 'Config' => {file => 'app.conf'};                                                                                                            die 'No discord webhook url in config' unless $cfg->{discord_webhook_url};                                                                                    post '/' => sub {
        my $c = shift;
        my $bb_json = $c->req->json;

        my $commit_text = $bb_json->{push}{changes}[0]{commits}[0]{message};
        my $author_name = $bb_json->{push}{changes}[0]{commits}[0]{author}{user}{display_name};
        my $link = $bb_json->{push}{changes}[0]{commits}[0]{links}{html}{href};
        my $msg = "new commit\nby $author_name\n$commit_text\n$link";

        Mojo::UserAgent->new()->post($cfg->{discord_webhook_url} => json => {content => $msg});

        $c->render(json => {res => 'Ok'});
};

app->start;
