package Test::RandomCheck::Generator::Types::Function;
use strict;
use warnings;
use parent "Test::RandomCheck::Generator::Types";
use Class::Accessor::Lite (ro => [qw(dom cod)]);
use Test::RandomCheck::Generator::Object;

sub arbitrary {
    my $self = shift;
    my $generator = $self->cod->arbitrary;
    gen {
        my ($rand, $size) = @_;

        my %results;
        sub {
            my $key = $self->dom->memoize_key(@_);
            $results{$key} //= $generator->pick($rand, $size);
        };
    };
}

sub memoize_key {
    my ($self, $f) = @_;
    int $f;
}

1;