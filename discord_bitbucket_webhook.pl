#!/usr/bin/perl

#Original by: https://github.com/simashin
#Updated by: https://github.com/Proxiart
#Update on: 5-3-2023

use strict;
use warnings;
use feature 'say';
use JSON;

use Mojolicious::Lite;
use Mojo::UserAgent;

use utf8;

my $cfg = plugin 'Config' => {file => 'app.conf'};

die 'No discord webhook url in config' unless $cfg->{discord_webhooks};

say "\e[31mWARNING: Development Mode is on\e[0m" if $cfg->{development};

post '/' => sub {
    my $c = shift;
    my $bb_json = $c->req->json;
    my $embeds = create_message($bb_json);
    my $discord_specific_urls = mapping($bb_json);

    unless ($cfg->{development}) {
        say "--------------------------------------";
        say "  discord specific url: $discord_specific_urls";
        say "--------------------------------------";
    }

    Mojo::UserAgent->new->post($discord_specific_urls => json => {embeds => $embeds});

    $c->render(json => {res => 'Ok'});
};

app->start;

sub create_message {
    my $embeds = [];
    my $bb_json = shift;

    if ($bb_json->{push}) {
        my $repo_name = $bb_json->{repository}{name};
        my $branch_name = $bb_json->{push}{changes}[0]{new}{name};

        for my $commit (@{$bb_json->{push}{changes}[0]{commits}}) {
            my $commit_text = $commit->{message};
            my $author_name = $commit->{author}{user}{display_name};
            my $link = $commit->{links}{html}{href};
            push @$embeds,
                {
                    title => "[$repo_name/$branch_name] new commit by $author_name",
                    color => 2263842,
                    description => "$commit_text$link"
                };
        }
    }

    if ($bb_json->{comment}) {
        my $comment_text = $bb_json->{comment}{content}{raw};
        my $author_name = $bb_json->{comment}{user}{display_name};
        my $link = $bb_json->{comment}{links}{html}{href};
        push @$embeds,
                {
                    title => "new comment by $author_name",
                    color => 6908265,
                    description => "$comment_text\n$link"
                };
    }

    return $embeds;
}

sub mapping {
    my $bb_json = shift;
    my $repository_name = $bb_json->{repository}{full_name};

    foreach my $webhook (@{ $cfg->{discord_webhooks} }) {
        my ($name, $url) = each %$webhook;
        return $url if ($name eq $repository_name);
    }

    return undef;
}
