package Webmentions;

use diagnostics;
use strict;
use warnings;

use CGI qw(:standard);
use LWP::Simple;
use Encode;
use API::Build;
use API::Files;

sub webmentions {
    my $tmp_hash = shift;

    my $q = new CGI;

    my $request_method = $q->request_method();

    if ( $request_method ne "POST" ) {
        report_error("400", "Invalid request or action", "Request method = $request_method. Action = $tmp_hash->{1}");
    }

    my $source_url = $q->param("source");
    $source_url = Utils::trim_spaces($source_url);
    if ( !defined($source_url) || length($source_url) < 1 )  { 
        report_error("400", "source_not_found", "The source URI does not exist.");
    } 

    my $target_url = $q->param("target");
    $target_url = Utils::trim_spaces($target_url);
    if ( !defined($target_url) || length($target_url) < 1 )  { 
        report_error("400", "target_not_found", "The target URI does not exist.");
    } 

    my $source_content = get($source_url);    
    if ( !$source_content ) {
        report_error("400", "source_not_found", "The source URI does not exist.");
    }

    my $target_content = get($target_url);    
    if ( !$target_content ) {
        report_error("400", "target_not_found", "The target URI does not exist.");
    }

#    if ( ($source_content !~ m|$target_url[\D]|) ) {
    if ( ($source_content !~ m|$target_url|is) ) {
        report_error("400", "no_link_found", "The source URI does not contain a link to the target URI.");
    } 

    my $webmentions_filename = Config::get_value_for("default_doc_root") . "/" . Config::get_value_for("webmentions_file");

    my $webmentions_text;
 
    if ( -e $webmentions_filename ) {
        open(my $fh, "<", $webmentions_filename ) or report_error("500", "Could not open links JSON file for read.", $!);
        while ( <$fh> ) {
            # chomp;
            $webmentions_text .= $_; 
        }
        close($fh) or report_error("500", "Could not close links JSON file after reading.", $!);
    } else {
        report_error("500", "Could not read webmentinos text file.", "File not found.");
    }

    if ( $webmentions_text =~ m/$source_url/ ) {
        report_error("400", "already_registered", "The specified WebMention has already been registered.");
    }

    my $dt_hash_ref     = Utils::create_datetime_stamp();

    $webmentions_text = $webmentions_text . "\n\n$dt_hash_ref->{date} $dt_hash_ref->{time}\n" . "source=<$source_url>\ntarget=<$target_url>";

    if ( $webmentions_filename =~  m/^([a-zA-Z0-9\/\.\-_]+)$/ ) {
        $webmentions_filename = $1;
    } else {
        report_error("500", "Bad file name.", "Could not write webmentions text file. $!");
    }
    open FILE, ">$webmentions_filename" or report_error("500", "Unable to open webmentions text file for write.", $!);
    print FILE $webmentions_text . "\n";
    close FILE;

    my $markup = Encode::decode_utf8($webmentions_text);

    my $hash = {
        'submit_type' => "Preview",
        'markup'      => $markup,
        'preview_only_key' => 'anything-can-be-used',
    };

    my $return_hash = Build::rebuild_html($hash);    

    my $rc = $return_hash->{status};

    if ( $rc >= 200 and $rc < 300 ) {
        _create_html_file($return_hash, $markup);
    } elsif ( $rc >= 400 and $rc < 500 ) {
         report_error("400", "$return_hash->{description}", "$return_hash->{user_message} $return_hash->{system_message}");
    } else  {
         report_error("500", "Unable to complete request. Invalid response code returned from API.", "$return_hash->{user_message} $return_hash->{system_message}");
    }

    my $json = <<JSONMSG;
{"result": "WebMention was successful"}
JSONMSG

    print header('application/json', '200 OK');
    print $json;
    exit;

# report_error("400", "webmention_filename = $webmentions_filename", "so far so good");

}

sub _create_html_file {
    my $hash_ref = shift;
    my $markup = shift;

    delete($hash_ref->{description});

    if ( !Files::output("rebuild", $hash_ref, $markup) ) {
       report_error("500", "Unable to create files.", "Unknown error.");
    }

    Files::_save_markup_to_storage_directory("update", $markup, $hash_ref);

}

sub report_error {
    my $error_code = shift;
    my $error = shift;
    my $description = shift;

        my $json = <<JSONMSG;
{"error": "$error","error_description": "$description"}
JSONMSG

        print header('application/json', "$error_code Bad Request");
        print $json;
        exit;
}

# http://webmention.org
# WebMention defines several error cases that must be handled.
# All errors below MUST be returned with an HTTP 400 Bad Request response code.
#   source_not_found: The source URI does not exist.
#   target_not_found: The target URI does not exist. This must only be used when an external GET on the target URI would result in an HTTP 404 response.
#   target_not_supported: The specified target URI is not a WebMention-enabled resource. For example, on a blog, individual post pages may be WebMention-enabled but the home page may not.
#   no_link_found: The source URI does not contain a link to the target URI.
#   already_registered: The specified WebMention has already been registered.


1;

