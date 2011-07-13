#!/usr/bin/perl

# code extracted from Amazon S3 Authentication Tool for Curl
# modified to be a callable module
# Copyright 2006-2010 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this 
# file except in compliance with the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License 
# for the specific language governing permissions and limitations under the License.

package S3::S3CurlFile;

use strict;
use warnings;

use FindBin;

use constant STAT_MODE => 2;
use constant STAT_UID => 4;

my $DOTFILENAME=".s3curl";
my $EXECFILE=$FindBin::Bin;
my $LOCALDOTFILE = $EXECFILE . "/" . $DOTFILENAME;
my $HOMEDOTFILE = $ENV{HOME} . "/" . $DOTFILENAME;
my $DOTFILE = -f $LOCALDOTFILE? $LOCALDOTFILE : $HOMEDOTFILE;

sub get_key {
	my ($alias) = @_;
	
	my %awsSecretAccessKeys = ();

	if (-f $DOTFILE) {
	    open(CONFIG, $DOTFILE) || die "can't open $DOTFILE: $!"; 

	    my @stats = stat(*CONFIG);

	    if (($stats[STAT_UID] != $<) || $stats[STAT_MODE] & 066) {
	        die "I refuse to read your credentials from $DOTFILE as this file is " .
	            "readable by, writable by or owned by someone else. Try " .
	            "chmod 600 $DOTFILE";
	    }

	    my @lines = <CONFIG>;
	    close CONFIG;
	    eval("@lines");
	    die "Failed to eval() file $DOTFILE:\n$@\n" if ($@);
	} 

	my $keyinfo = $awsSecretAccessKeys{$alias};
	die "I don't know about key with friendly name $alias. " .
	    "Do you need to set it up in $DOTFILE?"
	    unless defined $keyinfo;
	
	return $keyinfo;
}

1;
