package DBIx::TryAgain::db;
use strict;
use warnings;

our @ISA = 'DBI::db';

our %defaults = (
    private_dbix_try_again_algorithm => 'fibonacci', # or exponential or linear or constant
    private_dbix_try_again_max_retries => 5,
    private_dbix_try_again_on_messages => [ qr/database is locked/i ],
);

sub try_again_algorithm {
    my $self = shift;
    my $attr = 'private_dbix_try_again_algorithm';
    return $self->{$attr} || $defaults{$attr} unless @_;
    $self->{$attr} = shift;
}

sub try_again_max_retries {
    my $self = shift;
    my $attr = 'private_dbix_try_again_max_retries';
    return $self->{$attr} || $defaults{$attr} unless @_;
    $self->{$attr} = shift;
}

sub try_again_on_messages  {
    my $self = shift;
    my $attr = 'private_dbix_try_again_on_messages';
    return $self->{$attr} || $defaults{$attr} unless @_;
    $self->{$attr} = shift;
}

sub prepare {
    my ( $dbh, @args ) = @_;
    my $sth = $dbh->SUPER::prepare(@args)
      or return;
    for (keys %defaults) {
        $sth->{$_} = defined($dbh->{$_}) ? $dbh->{$_} : $defaults{$_};
    }
    return $sth;
}


1;

