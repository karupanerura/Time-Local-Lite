use strict;
BEGIN {
    # Windows can't change timezone inside Perl script
    if (($ENV{TZ}||'') ne 'GMT') {
        $ENV{TZ} = 'GMT';
        exec $^X, (map { "-I\"$_\"" } @INC), $0;
    };
}

use Test::More;
use Time::Local::Lite qw/:all/;

is timelocal(45, 23, 1, 1, 0, 114), 1388539425, 'timelocal';
is timegm(45, 23, 1, 1, 0, 114),    1388539425, 'timegm';

done_testing;

