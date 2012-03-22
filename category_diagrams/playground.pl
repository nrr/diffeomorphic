#! /usr/bin/env perl

use feature qw[ say ];
use strictures;

use Crypt::CBC;
use Crypt::Rijndael;
use Data::Dumper;
use FileHandle;
use JSON;
use Try::Tiny;

exit main(@ARGV);

sub main
{
	my ($action, $filename, @rest) = @_;

	if (0) {
		say read_file($filename);
		return 1;
	}

	if (0) {
		write_file(
			$filename,
			serialize({
				message => 'who was james k polk anyway?'
			}));
		return 1
	}

	if ($action eq 'enc') {
		write_file(
			$filename,
			encrypt('a stack of pancakes',
				serialize({
					message => 'who was james k polk anyway?'
				})));
	}
	elsif ($action eq 'dec') {
		say Dumper(deserialize(
			decrypt('a stack of pancakes',
				read_file(
					$filename))));
	}

	my $foo = [
		{
			'+hidden1' => 'blorf',
			'shown1' => 'asudfa',
		},
		{
			'+hidden2' => 'blorf',
			'+hidden3' => 'blorf',
			'+hidden4' => 'blorf',
			'+hidden5' => 'blorf',
			'shown2' => 'asudfa',
		},
		{
			'+hidden6' => 'blorf',
			'shown3' => 'asudfa',
			'shown4' => 'asudfa',
			'shown5' => 'asudfa',
			'+hidden7' => 'blorf',
			'+hidden8' => 'blorf',
			'+hidden9' => 'blorf',
			'shown6' => 'asudfa',
		},
		{
			'+hidden10' => 'blorf',
			'shown7' => 'asudfa',
			'shown8' => 'asudfa',
			'shown9' => 'asudfa',
			'+hidden11' => 'blorf',
			'+hidden12' => 'blorf',
			'shown10' => 'asudfa',
		},
		{
			'+hidden13' => 'blorf',
			'+hidden14' => 'blorf',
			'shown11' => 'asudfa',
			'shown12' => 'asudfa',
			'shown13' => 'asudfa',
			'shown14' => 'asudfa',
			'shown15' => 'asudfa',
			'+hidden15' => 'blorf',
			'+hidden16' => 'blorf',
			'+hidden17' => 'blorf',
			'+hidden18' => 'blorf',
			'+hidden19' => 'blorf',
			'+hidden20' => 'blorf',
			'+hidden21' => 'blorf',
			'shown16' => 'asudfa',
		},
		{
			'+hidden22' => 'blorf',
			'shown17' => 'asudfa',
			'shown18' => 'asudfa',
			'+hidden23' => 'blorf',
			'+hidden24' => 'blorf',
			'shown19' => 'asudfa',
		},
		{
			'+hidden25' => 'blorf',
			'+hidden26' => 'blorf',
			'shown20' => 'asudfa',
			'+hidden27' => 'blorf',
			'shown21' => 'asudfa',
		},
	];

	say Dumper(scrub_hidden_keys($foo));

	return 1;
}

sub deserialize
{
	my ($json) = @_;

	return decode_json($json);
}

sub serialize
{
	my ($object) = @_;

	return encode_json($object);
}

sub _instantiate_crypt_cbc
{
	my ($secret_key) = @_;

	return Crypt::CBC->new(
		'-key' => $secret_key,
		'-cipher' => 'Rijndael'
	);
}

sub decrypt
{
	my ($secret_key, $ciphertext) = @_;

	return _instantiate_crypt_cbc($secret_key)->decrypt($ciphertext);
}

sub encrypt
{
	my ($secret_key, $plaintext) = @_;

	return _instantiate_crypt_cbc($secret_key)->encrypt($plaintext);
}

sub read_file
{
	my ($filename) = @_;

	my @lines = ();
	with_file_reader($filename => sub {
		my ($line) = @_;

		push @lines, $line;
	});
	return join '', @lines;
}

sub write_file
{
	my ($filename, $lines) = @_;

	with_file_writer($filename => sub {
		my ($fh) = @_;

		$fh->print($lines);
	});
}

sub with_open_filehandle
{
	my ($fh, $callback) = @_;

	try {
		$callback->($fh);
	}
	finally {
		$fh->close;
	};
}

sub with_file_reader
{
	my ($filename, $callback) = @_;

	with_open_filehandle(FileHandle->new($filename, 'r') => sub {
		my ($fh) = @_;

		while (my $line = $fh->getline) {
			$callback->($line);
		}
	});
}

sub with_file_writer
{
	my ($filename, $callback) = @_;

	with_open_filehandle(FileHandle->new($filename, 'w') => sub {
		my ($fh) = @_;

		$callback->($fh);
	});
}

sub scrub_hidden_keys
{
        my ($elements_aref) = @_;

        my @scrubbed_elements = map {
                my $element = $_;

                my %scrubbed_element = map {
			my $key = $_;
                        ($key => $element->{$key})
                }
                grep {
                        my $key = $_;
                        $key !~ /^\+/
                } keys %{$element};

		\%scrubbed_element;
        } @{$elements_aref};

	return \@scrubbed_elements;
}
