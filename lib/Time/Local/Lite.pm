package Time::Local::Lite;
use 5.008005;
use strict;
use warnings;
use utf8;

our $VERSION = "0.01";

use parent qw/Exporter/;
our %EXPORT_TAGS = (
    default => [qw/timelocal timegm/],
    nocheck => [qw/timelocal_nocheck timegm_nocheck/],
);
our @EXPORT_OK = map { @$_ } values %EXPORT_TAGS;
$EXPORT_TAGS{all} = \@EXPORT_OK;

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

use Time::TZOffset ();

# XXX: for optimization.
use constant ARG_SEC   => 0;
use constant ARG_MIN   => 1;
use constant ARG_HOUR  => 2;
use constant ARG_MDAY  => 3;
use constant ARG_MONTH => 4;
use constant ARG_YEAR  => 5;

sub timelocal {
    timegm(@_) - Time::TZOffset::tzoffset_as_seconds(@_[ARG_SEC..ARG_MONTH], $_[ARG_YEAR] - 1900);
}

sub timelocal_nocheck {
    timegm_nocheck(@_) - Time::TZOffset::tzoffset_as_seconds(@_[ARG_SEC..ARG_MONTH], $_[ARG_YEAR] - 1900);
}

1;
__END__

=encoding utf-8

=head1 NAME

Time::Local::Lite - It's new $module

=head1 SYNOPSIS

    use Time::Local::Lite;

=head1 DESCRIPTION

Time::Local::Lite is ...

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut

