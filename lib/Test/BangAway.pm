package Test::BangAway;
use strict;
use warnings;
use Data::Dumper;
use Exporter qw(import);
use Test::BangAway::CombinedMLCG;
use Test::More ();
use 5.008_005;
our $VERSION = '0.01';

our @EXPORT = qw(bang_away_ok);

sub bang_away_ok (&$;@) {
    my $code = shift;
    my $generator = shift;
    my %params = @_;
    my $shots = delete $params{shots} // 202;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    for (1 .. $shots) {
        my $rand = Test::BangAway::CombinedMLCG->new;
        my @args = $generator->pick($rand, ($_ - 1) % 101);
        unless ($code->(@args)) {
            Test::More::diag "Faild by following args: " .
                             Data::Dumper->new(\@args)->Terse(1)->Dump;
            return Test::More::ok 0 ;
        }
    }
    Test::More::ok 1;
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::BangAway - Yet another QuickCheck for Perl

=head1 SYNOPSIS

  use Test::BangAway;
  use Test::BangAway::Generator;
  use Test::More;

  sub my_length { ... }

  # Define types of values which is used while testing.
  my $type_of_arguments = concat(string, string);

  bang_away_ok {
      my ($s1, $s2) = @_;
      # Write a property which the my_length has.
      my_length($s1) + my_length($s2) == my_length($s1 . $s2);
  } $type_of_arguments;

  done_testing;

=head1 DESCRIPTION

Test::BangAway is an implementation of QuickCheck in Perl.

You may want to define any kind of test arguments by using conbinators
prepared by L<Test::BangAway::Generator>.

=head1 FUNCTIONS

=over 4

=item C<<bang_away_ok { ... } $generator;>>

Run blocks with arguments generated by $generator. $generator must have
pick() method which returns arguments randomly for the block.

It outputs "OK" if the block returns the true value for all random petterns.

=back

=head1 SEE ALSO

L<http://hackage.haskell.org/package/QuickCheck> is a test library for Haskell
to define properties of functions and to run tests randomly.

L<Test::LectroTest> is another implementation of QuickTest which uses
the source code filter and has haskell like syntax (CamelCase class names).

=head1 AUTHOR

Masahiro Honma E<lt>hiratara@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Masahiro Honma

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
