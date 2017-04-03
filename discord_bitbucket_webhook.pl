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

		my $msg = create_message($bb_json);
		Mojo::UserAgent->new()->post($cfg->{discord_webhook_url} => json => {content => $msg});

		$c->render(json => {res => 'Ok'});
};

app->start;


sub create_message {
	my $bb_json = shift;

	my $msg = '';
	if ($bb_json->{push}) {
		my $commit_text = $bb_json->{push}{changes}[0]{commits}[0]{message};
		my $author_name = $bb_json->{push}{changes}[0]{commits}[0]{author}{user}{display_name};
		my $link = $bb_json->{push}{changes}[0]{commits}[0]{links}{html}{href};
		$msg = "new commit by $author_name \" $commit_text \"\n$link\n";
	}
	if ($bb_json->{comment}) {
		my $comment_text = $bb_json->{comment}{content}{raw};
		my $author_name = $bb_json->{comment}{user}{display_name};
		my $link = $bb_json->{comment}{links}{html}{href};
		$msg .= "new comment by $author_name \" $comment_text \"\n$link\n";
	}

	return $msg;
}