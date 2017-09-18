# Wren Using S3

Wren supports copying created and updated posts to an Amazon Web Services S3 bucket.  It's also possible to work with an S3 bucket from the command line of a remote computer, using a program called `s3cmd`.


### s3cmd

<http://s3tools.org/s3cmd>

linuxconfig.org - [Getting started with AWS s3cmd command by examples](https://linuxconfig.org/getting-started-with-aws-s3cmd-command-by-examples)

Download, install, and config, providing the AWS access id and secret pass id.



#### Syncing

Copy all files and directories to a bucket.

First, change directory into the Wren root directory, and then do:

    s3cmd sync . s3://mybucketname/




#### Copy file to bucket 

This example copies a file that's located in a folder.

Change directory into web root.

    s3cmd put 2016/11/03/this-is-a-test.html s3://mybucketname/2016/11/03/this-is-a-test.html

Need to include the folder structure for the destination location (in the bucket), otherwise, `this-is-a-test.html` will land in the root of the bucket like this: `s3://mybucketname/this-is-a-test.html`




#### List all contents for an S3 account

This will list all available data ( objects ) under an AWS S3 account, including buckets, directories, and files:

    s3cmd la




#### List all contents for a bucket 

This will list files and directories.

    s3cmd ls -r  s3://mybucketname/




#### Delete files and directories under a folder

    s3cmd del s3://mybucketname/versions/ --recursive




#### Delete an empty directory

    s3cmd del s3://mybucketname/versions



#### Empty Entire Bucket

This will remove all files and directories within a bucket.

    s3cmd del -r --force s3://mybucketname/



#### Redo the bucket's contents

I don't need the `versions` folder and all of its contents located on the bucket. `versions` exists on the EC2 server. It's used by the Wren app.

    s3cmd del -r --force s3://mybucketname/
    s3cmd sync . s3://mybucketname/  
    s3cmd del s3://mybucketname/versions/ --recursive




### Perl

Perl Installs for S3 Usage.

stackoverflow.com - [XML::Parser refusing to isntall](http://stackoverflow.com/questions/13986282/xmlparser-refusing-to-install)


    apt-cache search expat

(look for package that states "XML parsing C library - development kit")

    sudo apt-get install libexpat1-dev

that should resolve the missing `expat.h` file, and now the install of this module should work:

    sudo perl -MCPAN -e 'install XML::Parser'

then do:

    sudo perl -MCPAN -e 'install XML::Simple'
    sudo perl -MCPAN -e 'install Amazon::S3'


How to use this module:

<http://docs.ceph.com/docs/giant/radosgw/s3/perl>

<https://metacpan.org/pod/Amazon%3a%3aS3>



### Wren S3.pm

    package S3;
    
    use strict;
    use warnings;
    use diagnostics;
    
    use Amazon::S3;
    
    use vars qw/$OWNER_ID $OWNER_DISPLAYNAME/;
    
    sub copy_to_s3 {
        my $filename = shift;
        my $content  = shift;
        my $type     = shift;
         
        my $aws_access_key_id     = Config::get_value_for("aws_access_key_id");
        my $aws_secret_access_key = Config::get_value_for("aws_secret_access_key");
    
        my $conn = Amazon::S3->new(
            {   aws_access_key_id     => $aws_access_key_id,
                aws_secret_access_key => $aws_secret_access_key,
                retry                 => 1
            }
        );
    
        my @buckets = @{$conn->buckets->{buckets} || []};
    
        my $bucket = $buckets[0];
    
        $bucket->add_key(
                $filename, $content,
                { content_type =>  $type },
        );
    
    }
    
    1;
    
    # at the moment, assuming only one bucket exists, and it's used to host files from wren.
    # if more than one bucket, then a loop would be needed to find which bucket to use.
    #foreach my $bucket (@buckets) {
    #        print $bucket->bucket . "\t" . $bucket->creation_date . "\n";
    #        my @keys = @{$bucket->list_all->{keys} || []};
    #            foreach my $key (@keys) {
    #            print "$key->{key}\t$key->{size}\t$key->{last_modified}\n";
    #        }
    #}


*updated Sep 18, 2017*


