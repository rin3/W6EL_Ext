#!perl -w
#
# Extraction and Report script for W6EL Prop
# - Preparation for specific contest dates
# - World opening times table for each band, SP and LP
#
# usage: save W6EL Prop batch prediction output as (something).wpf.
# launch this program and enter that filename.
#
# rin fukuda, jg1vgx@jarl.com, Oct 2004
# version 0.02, for W6EL Prop v2.70 ONLY!!

use strict;

print "*** Extraction and Report Script for W6EL Prop ***\n";
print "Contest version - 5 bands\n\n";
print "Input file name, without the .wpf: ";
chomp(my $base = <STDIN>);

my $WPF = $base.".wpf";
open WPF, $WPF or die "Can't open $WPF.\n";

my($path, $date, $mycall, $bearing, $dest, $solar, $dist);
my(%hour_table, %dest_order);
my($dest_order_count, $sp);

while(<WPF>) {
	# Title line
	if(/^ {28}W6ELProp (\w+)-Path Prediction for ([\d\/]+)/) {
		if( $1 eq 'Short') {
			$path = 'SP';		# path
		} elsif( $1 eq 'Long') {
			$path = 'LP';
		}
		$date = $2;			# date in '2004/10/30'
	}
	# Terminal A line
	if(/^ TERMINAL A.{20}(.{19}).+Bearing to B: (.{9})/) {
		$mycall = $1;			# 'JE1ZWT'
		$bearing = $2;			# '203.9 deg'
	}
	# Terminal B line
	if(/^ TERMINAL B.{20}(.{19})/) {
		$dest = $1;			# 'Los Angeles, CA'
		# set dest_order, pad with zeros
		unless($dest_order{$dest}) { 
			$dest_order{$dest} = ++$dest_order_count;
			$sp = '0'x(3-length($dest_order{$dest}));
			$dest_order{$dest} = $sp.$dest_order{$dest};
		}
	}
	# SSN Flux line
	if(/^ (SSN.{57})\s+Path Length: (.{8})/) {
		$solar = $1;			# 'SSN:  90.0  Flux: ...'
		$dist = $2;			# '20350 km'
	}
	# UTC MUF line
	if(/^ UTC/) {
		&get_hour_table($dest_order{$dest}.$path, $dest.$bearing.'  '.$dist);
	}
}

close WPF;	# finished reading the .wpf file

my $OUT = $base.".txt";
open OUT, ">$OUT" or die "Can't open $OUT for saving data.\n";

foreach my $band ( 80, 40, 20, 15, 10 ) {
	# headers for each band
	printf OUT "$date     $mycall$solar\n\n";
	# SP
	printf OUT "SP |0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 |(UTC)\n";
	printf OUT "   |0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 |\n";
	foreach(sort keys %hour_table) {
		if( substr($_, 5, 2) eq $band && substr($_, 3, 2) eq 'SP' ) {
			printf OUT $band.'m|'.$hour_table{$_}.'|'.substr($_, 7)."\n";
		}
	}
	printf OUT "\n";
	# LP
	printf OUT "LP |0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 |(UTC)\n";
	printf OUT "   |0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 |\n";
	foreach(sort keys %hour_table) {
		if( substr($_, 5, 2) eq $band && substr($_, 3, 2) eq 'LP' ) {
			printf OUT $band.'m|'.$hour_table{$_}.'|'.substr($_, 7)."\n";
		}
	}
	printf OUT "\n\n";
}

close OUT;

### exit

sub get_hour_table {
	my($m80, $m40, $m20, $m15, $m10);
	my($key);

	while(<WPF>) {
		# fill in with ABCD
		if(/^ \d{4}/) {
			if(length $_ > 19) {
				$m80 = substr($_, 19, 1);
			} else {
				$m80 = ' ';
			}
			if(length $_ > 29) {
				$m40 = substr($_, 29, 1);
			} else {
				$m40 = ' ';
			}
			if(length $_ > 39) {
				$m20 = substr($_, 39, 1);
			} else {
				$m20 = ' ';
			}
			if(length $_ > 49) {
				$m15 = substr($_, 49, 1);
			} else {
				$m15 = ' ';
			}
			if(length $_ > 59) {
				$m10 = substr($_, 59, 1);
			} else {
				$m10 = ' ';
			}

			# convert from ABCD to symbols
			$m80 = &ABCD2symbols($m80);
			$m40 = &ABCD2symbols($m40);
			$m20 = &ABCD2symbols($m20);
			$m15 = &ABCD2symbols($m15);
			$m10 = &ABCD2symbols($m10);

			# storing symbols in hour_table hash 
			$key = $_[0]."80".$_[1];
			$hour_table{$key} .= $m80;
			$key = $_[0]."40".$_[1];
			$hour_table{$key} .= $m40;
			$key = $_[0]."20".$_[1];
			$hour_table{$key} .= $m20;
			$key = $_[0]."15".$_[1];
			$hour_table{$key} .= $m15;
			$key = $_[0]."10".$_[1];
			$hour_table{$key} .= $m10;
		}

		# exit, finishing a dest-path combination
		if(/^--------/) {
			last;
		}
	}
}

sub ABCD2symbols {
	# convert from ABCD to symbols
	my $ret = ' ';
	$ret = '#' if($_[0] eq 'A');
	$ret = '+' if($_[0] eq 'B');
	$ret = '-' if($_[0] eq 'C');
#	$ret = ' ' if($_[0] eq 'D');
	$ret;
}