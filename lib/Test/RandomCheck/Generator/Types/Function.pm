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
        my $freezed = $rand->split;

        my %results;
        sub {
            my $id = join '\0', @_;
            # TODO: We need not to use coarbitrarity no longer
            my $fixed_generator = $self->dom->coarbitrary($generator, @_);
            $results{$id} //= $fixed_generator->pick($freezed->clone, $size);
        };
    };
}

sub coarbitrary {
    my ($self, $generator, $f) = @_;
    $self->dom->arbitrary->flat_map(sub {
        my @x = @_;
        $self->cod->coarbitrary($generator, $f->(@x));
    });
}

1;
