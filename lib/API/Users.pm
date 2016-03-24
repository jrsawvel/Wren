package Users;

use strict;
use warnings;

use API::Login;
use API::Logout;

sub users {

    my $tmp_hash = shift;

    my $q = new CGI;

    my $request_method = $q->request_method();

    if ( $request_method eq "POST" ) {
        if ( exists($tmp_hash->{1}) and $tmp_hash->{1} eq "login" ) {
            Login::create_and_send_no_password_login_link();
        }
    } elsif ( $request_method eq "GET" ) {
        if ( exists($tmp_hash->{1}) and $tmp_hash->{1} eq "login" ) {
            Login::activate_no_password_login();
        } elsif ( exists($tmp_hash->{1}) and $tmp_hash->{1} eq "logout" ) {
            Logout::logout();
        }
    }

    Error::report_error("400", "Invalid request or action", "Request method = $request_method. Action = $tmp_hash->{1}");

}

1;
