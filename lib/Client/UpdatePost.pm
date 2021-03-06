package UpdatePost;

use strict;

use REST::Client;
use JSON::PP;
use HTML::Entities;
use Encode;
use Client::User;

sub show_post_to_edit {
    my $tmp_hash = shift; 

    my $author_name  = User::get_logged_in_author_name(); 
    my $session_id   = User::get_logged_in_session_id(); 
    my $rev          = User::get_logged_in_rev(); 

    if ( !$author_name or !$session_id or !$rev ) {
        Page->report_error("user", "Cannot peform action.", "You are not logged in.");
    }

    my $post_id;

    my $hash_length = scalar keys $tmp_hash;
    if ( $hash_length > 2 ) {
        for ( my $i=1; $i<$hash_length; $i++ ) {
            $post_id .= $tmp_hash->{$i} . "/";
        } 
        chop($post_id);
    } else {
        $post_id = $tmp_hash->{1};
    }

    my $original_slug = $tmp_hash->{$hash_length-1};

    my $api_url = Config::get_value_for("api_url") . "/posts/" . $post_id;

    my $query_string = "/?author=$author_name&session_id=$session_id&rev=$rev&text=markup";

    $api_url .= $query_string;

    my $rest = REST::Client->new();
    $rest->GET($api_url);

    my $rc = $rest->responseCode();

    my $json = decode_json $rest->responseContent();

    if ( $rc >= 200 and $rc < 300 ) {
        my $t = Page->new("updatepostform");
        $t->set_template_variable("html_file", "$post_id.html");
        $t->set_template_variable("original_slug", $original_slug);
        $t->set_template_variable("post_id", $post_id);
        # $t->set_template_variable("markup", $json->{markup});
        $t->set_template_variable("markup",     decode_entities($json->{markup}, '<>&'));
        $t->display_page("Updating Post $json->{title}");
        exit;
    } elsif ( $rc >= 400 and $rc < 500 ) {
         Page->report_error("user", $json->{description}, "$json->{user_message} $json->{system_message}");
    } else  {
        Page->report_error("user", "Unable to complete request. Invalid response code returned from API.", "$json->{user_message} $json->{system_message}");
    }
}

sub show_editor_update {
    my $tmp_hash = shift;  

    my $author_name  = User::get_logged_in_author_name(); 
    my $session_id   = User::get_logged_in_session_id(); 
    my $rev          = User::get_logged_in_rev(); 

    if ( !$author_name or !$session_id or !$rev ) {
        Page->report_error("user", "Cannot peform action.", "You are not logged in.");
    }

    my $post_id;

    my $hash_length = scalar keys $tmp_hash;
    if ( $hash_length > 2 ) {
        for ( my $i=1; $i<$hash_length; $i++ ) {
            $post_id .= $tmp_hash->{$i} . "/";
        } 
        chop($post_id);
    } else {
        $post_id = $tmp_hash->{1};
    }

    my $original_slug = $tmp_hash->{$hash_length-1};

    my $api_url = Config::get_value_for("api_url") . "/posts/" . $post_id;

    my $query_string = "/?author=$author_name&session_id=$session_id&rev=$rev&text=markup";

    $api_url .= $query_string;

    my $rest = REST::Client->new();
    $rest->GET($api_url);

    my $rc = $rest->responseCode();

    my $json = decode_json $rest->responseContent();

    if ( $rc >= 200 and $rc < 300 ) {
        my $t = Page->new("tanager");
        $t->set_template_variable("action", "updateblog");
        $t->set_template_variable("api_url", Config::get_value_for("api_url"));
        $t->set_template_variable("markup",     decode_entities($json->{markup}, '<>&'));
#        $t->set_template_variable("post_id",         $post_id);
        $t->set_template_variable("post_id",         $original_slug);
        $t->display_page_min("Editing - Editor " . $json->{title});
    } elsif ( $rc >= 400 and $rc < 500 ) {
            Page->report_error("user", "$json->{user_message}", $json->{system_message});
    } else  {
        Page->report_error("user", "Unable to complete request. Invalid response code returned from API.", "$json->{user_message} $json->{system_message}");
    }
}


sub update_post {

    my $author_name  = User::get_logged_in_author_name(); 
    my $session_id   = User::get_logged_in_session_id(); 
    my $rev          = User::get_logged_in_rev(); 

    my $q = new CGI;
    my $submit_type     = $q->param("sb"); # Preview or Post 
    my $post_location   = $q->param("post_location"); # notes_stream or ?
    my $original_markup = $q->param("markup");
    my $original_slug   = $q->param("original_slug");

    my $markup = Encode::decode_utf8($original_markup);

# jrs commented this out on 31Aug2016 for testing. 
    $markup = HTML::Entities::encode($markup,'^\n^\r\x20-\x25\x27-\x7e');

    my $api_url = Config::get_value_for("api_url");

    my $json_input;

    my $hash = {
        'author'         => $author_name,
        'session_id'     => $session_id,
        'rev'            => $rev,
        'submit_type'    => $submit_type,
        'markup'         => $markup,
        'original_slug'  => $original_slug,
    };

    my $json_input = encode_json $hash;

    my $headers = {
        'Content-type' => 'application/json'
    };

    my $rest = REST::Client->new( {
        host => $api_url,
    } );

    $rest->PUT( "/posts" , $json_input , $headers );

    my $rc = $rest->responseCode();

    my $json = decode_json $rest->responseContent();

    if ( $rc >= 200 and $rc < 300 ) {
        my $t;

        if ( $submit_type eq "Preview" ) {
            $t = Page->new("updatepostform");
            $t->set_template_variable("previewingpost", 1);
            $t->set_template_variable("markup", $original_markup);
       
            my $html = $json->{html};
            $t->set_template_variable("html", $html);
            $t->set_template_variable("html_file", "$json->{post_id}.html");
            $t->set_template_variable("original_slug", $original_slug);
            $t->set_template_variable("post_id", $json->{post_id});
            $t->set_template_variable("title", $json->{title});
  
            if ( $json->{toc} ) {
                $t->set_template_variable("usingtoc", "1");
                $t->set_template_loop_data("toc_loop", $json->{'toc_loop'});
            } else {
                $t->set_template_variable("usingtoc", "0");
            }

            if ( exists($json->{custom_css}) ) {
                $t->set_template_variable("using_custom_css", "1");
                $t->set_template_variable("custom_css", $json->{custom_css});
            } 

            $t->display_page("Previewing new post");
            exit;
        } elsif ( $submit_type eq "Update" ) {
#            my $url;
#            if ( exists($json->{dir}) ) {
#                $url = Config::get_value_for("home_page") . "/" . $json->{dir} . "/" . $json->{slug} . ".html";
#            } else {
#                $url = Config::get_value_for("home_page") . "/" . $json->{slug} . ".html";
#            }
#            print $q->redirect( -url => $url);
            print $q->redirect( -url => $json->{location});
            exit;
        }
    } elsif ( $rc >= 400 and $rc < 500 ) {
         Page->report_error("user", $json->{description}, "$json->{user_message} $json->{system_message}");
    } else  {
        Page->report_error("user", "Unable to complete request. Invalid response code returned from API.", "$json->{user_message} $json->{system_message}");
    }
}

1;
