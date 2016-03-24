#!/usr/bin/perl -wT

use HTML::TokeParser;
use LWP::Simple;

use Data::Dumper;
use Time::Local;

my $source_url = "http://wren.soupmode.com/mft.html";

my $source_content = get($source_url);
 
my $p = HTML::TokeParser->new(\$source_content);

# print Dumper $p;

my $img_url;

my $token;

while ( $token = $p->get_tag('li') ) {
    if ( exists($token->[1]{class}) and $token->[1]{class} eq "h-entry" ) {
            if ( my $token3 = $p->get_tag("a") ) {
                my $url = $token3->[1]{href} || "-";
                my $text = $p->get_trimmed_text("/a");
                print "$url\t$text\n";
            }

            if ( my $token3 = $p->get_tag("div") ) {
                if ( exists($token3->[1]{class}) and $token3->[1]{class} eq "p-author" ) {
                    my $author = $p->get_trimmed_text("/div");
                    print "author = $author\n";
                }
            }

            if ( my $token3 = $p->get_tag('time') ) {
                if ( exists($token3->[1]{class}) and $token3->[1]{class} eq "dt-published" ) {
                    if ( exists($token3->[1]{datetime}) ) {
                        # print "datetime = $token3->[1]{datetime}" . " epoch = " . convert_date_to_epoch($token3->[1]{datetime}) .  "\n";
                        print "datetime = $token3->[1]{datetime}" .  "\n";
                    }
                }     
           }
    }
}


# receives date string as: YYYY-MM-DD HH-MM-SS
# date format used in database date field
# code from: http://stackoverflow.com/users/4234/dreeves
# in post: http://stackoverflow.com/questions/95492/how-do-i-convert-a-date-time-to-epoch-time-aka-unix-time-seconds-since-1970
# I changed timelocal to timegm
sub convert_date_to_epoch {
  my($s) = @_;
  my($year, $month, $day, $hour, $minute, $second);

  if($s =~ m{^\s*(\d{1,4})\W*0*(\d{1,2})\W*0*(\d{1,2})\W*0*
                 (\d{0,2})\W*0*(\d{0,2})\W*0*(\d{0,2})}x) {
    $year = $1;  $month = $2;   $day = $3;
    $hour = $4;  $minute = $5;  $second = $6;
    $hour |= 0;  $minute |= 0;  $second |= 0;  # defaults.

# print " --- $hour $minute $second ---\n";

    $year = ($year<100 ? ($year<70 ? 2000+$year : 1900+$year) : $year);
    return timegm($second,$minute,$hour,$day,$month-1,$year);  
  }
  return -1;

}




__END__

<ul>
  <li class="h-entry">
    <a class="u-url" href="/warm-weather-will-continue-through-midmarch.html">Warm weather will continue through mid-March</a>
    <div class="p-author" style="display:none;">JR</div>
    <time class="dt-published" datetime="2016-03-10 12:00:00">Mar 10, 2016</time>
  </li>
</ul>
