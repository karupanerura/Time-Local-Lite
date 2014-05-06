requires 'Time::TZOffset';
requires 'parent';
requires 'perl', '5.008005';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'Test::More';
};

on develop => sub {
    requires 'Test::Builder';
    requires 'Time::Duration';
    requires 'Time::Local';
};
