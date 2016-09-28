package Test::RandomCheck::Generator::Types::Enum;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Class::Accessor::Lite (ro => [qw(items)]);
use List::MoreUtils ();
use Test::RandomCheck::Generator::Object;

sub arbitrary {
    my $self = shift;
    elements @{$self->items};
}

sub memoize_key {
    my ($self, $item) = @_;
    my $n = List::MoreUtils::first_index { $_ eq $item } @{$self->items};
    $n;
}

1;