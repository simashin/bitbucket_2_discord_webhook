#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use Mojolicious::Lite;
use Mojo::UserAgent; 

my $cfg = plugin 'Config' => {file => 'app.conf'};
die 'No discord webhook url in config' unless $cfg->{discord_webhook_url};

post '/' => sub {
		my $c = shift;
		my $bb_json = $c->req->json;

		my $embeds = create_message($bb_json);
		Mojo::UserAgent->new()->post($cfg->{discord_webhook_url} => json => {embeds => $embeds});

		$c->render(json => {res => 'Ok'});
};

app->start;


sub create_message {
	my $bb_json = shift;

	my $embeds = [];
	if ($bb_json->{push}) {
		for my $commit (@{$bb_json->{push}{changes}[0]{commits}}) {
			my $commit_text = $commit->{message};
			my $author_name = $commit->{author}{user}{display_name};
			my $link = $commit->{links}{html}{href};
			push @$embeds,
				{
					title => "new commit by $author_name",
					color => 2263842,
					description => $commit_text . $link
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
					description => $comment_text. "\n" . $link
				};
	}

	return $embeds;
}