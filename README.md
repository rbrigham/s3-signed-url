s3-signed-url
=============
This script is a simple wrapper around the s3-example-libraries, with some
extracted code from s3-curl to piggyback on the .s3curl credentials file.  It's
sole purpose is to construct signed URLs for getting S3 resources.


SETUP
-----
To start, create an .s3curl file in your home directory.  This file will
contain your AWS Access Key Id and AWS Secret Access Key pairs, indexed by
aliases that you specify.  For example:

    %awsSecretAccessKeys = (
        # personal account
        personal => {
            id => '1234567890ABCDEFGHIJ',
            key => 'abcdefghijABCDEFGHIJ1234567890abcdefghij',
        },

        # corporate account
        company => {
            id => 'ABCDEFGHIJ1234567890',
            key => 'abcdefghij1234567890ABCDEFGHIJabcdefghij',
        },
    );


EXAMPLES
--------
After creating the .s3curl file and specifying your AWS keys, you can try the
following commands.  You need to make the s3-signed-url.pl file executable, or
you can just prefix the commands with `perl`.

To generate a standard url for an object (defaulting to an http url in path
format with a 1 minute expiration), run:

    s3-signed-url.pl --key [secret-key-alias] --bucket [bucket-name] --object [object-key]


If you want the url to be in subdomain format, run:

    s3-signed-url.pl --key [secret-key-alias] --bucket [bucket-name] --object [object-key] --format SUBDOMAIN


If you want an https url, run:

    s3-signed-url.pl --key [secret-key-alias] --bucket [bucket-name] --object [object-key] --secure

If you want the url to expire in 10 minutes, run:

    s3-signed-url.pl --key [secret-key-alias] --bucket [bucket-name] --object [object-key] --expires-in 600

And if you want to specify the time the url expires, pass in the epoch time:

    s3-signed-url.pl --key [secret-key-alias] --bucket [bucket-name] --object [object-key] --expires 1321009871


USAGE
-----
    s3-signed-url.pl --key key-alias --bucket bucket-name --object object-key [options]
     options:
      --expires epoch-time        url expires at specified time
      --expires-in seconds        url expires in specified number of seconds
      --format url-format         desired format of url [PATH|SUBDOMAIN|VANITY]
      --secure                    use https instead of http


REFERENCES
----------
* S3 Query String Authentication  
  <http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?S3_QSAuth.html>

* Amazon S3 Authentication Tool for Curl (s3-curl)  
  <http://aws.amazon.com/code/128>

* Amazon S3 Library for REST in Perl (s3-example-libraries)  
  <http://aws.amazon.com/code/133>


LICENSES
--------
### s3-signed-url.pl
> Copyright (C) 2011 by Rob Brigham
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.

### S3CurlFile.pm
> Copyright 2006-2010 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> 
> Licensed under the Apache License, Version 2.0 (the "License"). You may not use
> this file except in compliance with the License. A copy of the License is
> located at
> 
> http://aws.amazon.com/apache2.0/
> 
> or in the "license" file accompanying this file. This file is distributed on an
> "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
> implied. See the License for the specific language governing permissions and
> limitations under the License.

### S3.pm, QueryStringAuthGenerator.pm
> This software code is made available "AS IS" without warranties of any
> kind.  You may copy, display, modify and redistribute the software
> code either by itself or as incorporated into your code; provided that
> you do not remove any proprietary notices.  Your use of this software
> code is at your own risk and you waive any claim against Amazon
> Digital Services, Inc. or its affiliates with respect to your use of
> this software code. (c) 2006-2007 Amazon Digital Services, Inc. or its
> affiliates.
