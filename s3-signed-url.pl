#!/usr/bin/perl

# Copyright (C) 2011 by Rob Brigham
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

use strict;
use warnings;

use Getopt::Long;
use FindBin qw($Bin);
use lib "$Bin";
use S3::S3CurlFile;
use S3::QueryStringAuthGenerator;

my $keyAlias;
my $keyId;
my $bucketName;
my $objectKey;
my $expires = 0;
my $expiresIn = 0;
my $callingFormat = 'PATH';
my $secureTransport = 0;
my $help;
my $secretKey;

GetOptions(
    'key=s' => \$keyAlias,
	'bucket=s' => \$bucketName,
	'object=s' => \$objectKey,
	'expires=i' => \$expires,
	'expires-in=i' => \$expiresIn,
	'format=s' => \$callingFormat,
    'secure' => \$secureTransport
);

my $usage = <<USAGE;
Usage $0 --key key-alias --bucket bucket-name --object object-key [options]
 options:
  --expires epoch-time        url expires at specified time
  --expires-in seconds        url expires in specified number of seconds
  --format url-format         desired format of url [PATH|SUBDOMAIN|VANITY]
  --secure                    use https instead of http
USAGE
die $usage if $help || !defined $keyAlias || !defined $bucketName || !defined $objectKey;

my $keyInfo = S3::S3CurlFile::get_key($keyAlias);
$keyId = $keyInfo->{id};
$secretKey = $keyInfo->{key};

my $generator = S3::QueryStringAuthGenerator->new($keyId, $secretKey, $secureTransport);
$generator->set_calling_format($callingFormat);
if ($expiresIn > 0) {
    $generator->expires_in($expiresIn);
}
if ($expires > 0) {
    $generator->expires($expires);
}
print $generator->get($bucketName, $objectKey);
