#! /usr/bin/env perl
use 5.010;
use strict;
use warnings;

#============================================================================
#pod =for :stopwords subtest PARAM
#pod
#pod =cut

# PODNAME: t/Some-Thing.t

# ABSTRACT: Unit tests for the main module Some::Thing

our $VERSION = '0.0.2'; # VERSION

#pod =head1 SYNOPSIS
#pod
#pod     # Run just this test
#pod     # cd <some built distribution version directory>
#pod     prove -lr  t/Some-Thing.t
#pod
#pod     # Run all tests
#pod     # cd <developer distribution directory>
#pod     dzil test.
#pod
#pod =head1 DESCRIPTION
#pod
#pod Tests the main Some::Thing module in the dist Some-Thing. These are user-facing
#pod tests, so should only fail when things are broken.
#pod
#pod Unit tests are organized with one test file matching each code file
#pod in the main distribution.
#pod
#pod =head1 TESTS
#pod
#pod Testing is structured to test each module interface function (unit testing).
#pod Module internal functions are not tested. If there is any question that internal
#pod functions work, this should be addressed either by coverage analysis or by
#pod factoring out internal functions into other modules.
#pod
#pod Testing is grouped into two sub-tests, one testing normal behavior and one
#pod testing exception handling. Every module interface function will have a separate
#pod subtest in each group; the normal subtest for aFunc() will be called aFuncOkT()
#pod and the exception handling subtest for aFunc() will be called aFuncBadT(). If
#pod there is no exception handling performed within a module interface function, its
#pod specific exception handling test will still exist, but will always pass. The
#pod description accompanying the passing test in such cases will report an
#pod appropriate message describing why there is no need for exception handling in
#pod the function.
#pod
#pod =cut
#============================================================================

# Declare constants useful in strings.
use Readonly;

# Better than eval for error handling
use Try::Tiny;

# Main testing module, use_ok + 2 subtests
use Test::More 'tests' => 1 + 2;

BEGIN {
   use_ok('Some::Thing');
}

Readonly::Scalar my $CLASS => 'Some::Thing';

subtest( 'Some-Thing.t Testing normal behavior'    => \&testOk );
subtest( 'Some-Thing.t Testing exception handling' => \&testBad );

# These are the main tests for the module, tests that the user-facing functions
# behave correctly. One for each interface function.
sub testOk {
   plan( tests => 1 );

   subtest( 'newOk()' => \&newOkT );
   return 1;
}

# These test exception handling in each interface function. One for each
# interface function even if it has no exception handling - such tests will
# always pass.
sub testBad {
   plan( tests => 1 );

   subtest( 'newBad()' => \&newBadT );
   return 1;
}

#==============
# $CLASS->new()
#==============

#----------------------------------------------------------------------------
#pod =head2 newOkT()
#pod
#pod     subtest( 'newOk()' => \&newOkT );
#pod
#pod Tests the following on the default object (C<new()> invoked with no parameters).
#pod
#pod for= :list * Returns something.
#pod for= :list * Returns an object of the correct class.
#pod
#pod PARAM: N/A
#pod
#pod RETURN: TRUE - All subtests returns true on completion.
#pod
#pod =cut
#----------------------------------------------------------------------------
sub newOkT {
   plan( tests => 2 );

   {
      my $defaultObj = $CLASS->new();
      ok( $defaultObj, 'Object constructor smoke test.' );
   }
   {
      my $defaultObj = provideDefaultObj();
      ok( $defaultObj->isa($CLASS),
         "Default testable $CLASS object is correct class" );
   }
   return 1;
}

#----------------------------------------------------------------------------
#pod =head2 newBadT()
#pod
#pod     subtest( 'newBad()' => \&newBadT );
#pod
#pod Tests the following errors:
#pod
#pod     ^Some::Thing::new was called incorrectly. It is a class method.
#pod
#pod Fatal on an invocation that passes no 1st parameter, i.e. (<CSome::Thing::new()>)
#pod
#pod
#pod PARAM: N/A
#pod
#pod RETURN: TRUE - All subtests returns true on completion.
#pod
#pod =cut
#----------------------------------------------------------------------------
sub newBadT {
   plan( tests => 1 );

   my $newCalledWrongRE =
     qr/^Some::Thing::new was called incorrectly. It is a class method./;

   my $noErrorError = 'This should fail with error.';
   {
      try {
         Some::Thing::new();
         fail($noErrorError);
      }
      catch {
         my $got  = $_;
         my $want = $newCalledWrongRE;
         like( $got, $want, 'Error if not called as object' );
      };
   }
   return 1;
}

#============================================================================
#pod =head1 FUNCTIONS - TEST INTERNALS
#pod
#pod These are the methods that are used to, for instance, provide data to other
#pod tests. They are documented only for developer interest.
#pod
#pod Note: These functions should be bog-simple. More complex helpers should be
#pod factored out into separate test utilities
#pod
#pod =cut
#============================================================================

#----------------------------------------------------------------------------
#pod =head2 provideDefaultObj()
#pod
#pod     my $defaultObj = provideDefaultObj();
#pod
#pod Returns a default Some::Thing object, created without passing any parameters.
#pod This is not really necessary, as it is just wraps C<Some::Thing->new()>, but that
#pod allows for symmetric test syntax when using other providers. Basically this makes
#pod it easier to write tests with clean, perfectly parallel structures.
#pod
#pod PARAM: N/A
#pod
#pod RETURN: $defaultObj - An object of this class created without any parameters.
#pod
#pod =cut
#----------------------------------------------------------------------------
sub provideDefaultObj {
   my $defaultObj = $CLASS->new();
   return $defaultObj;
}

__END__

=pod

=encoding UTF-8

=for :stopwords Stuart R. Jefferys subtest PARAM

=head1 NAME

t/Some-Thing.t - Unit tests for the main module Some::Thing

=head1 VERSION

version 0.0.2

=head1 SYNOPSIS

    # Run just this test
    # cd <some built distribution version directory>
    prove -lr  t/Some-Thing.t

    # Run all tests
    # cd <developer distribution directory>
    dzil test.

=head1 DESCRIPTION

Tests the main Some::Thing module in the dist Some-Thing. These are user-facing
tests, so should only fail when things are broken.

Unit tests are organized with one test file matching each code file
in the main distribution.

=head1 TESTS

Testing is structured to test each module interface function (unit testing).
Module internal functions are not tested. If there is any question that internal
functions work, this should be addressed either by coverage analysis or by
factoring out internal functions into other modules.

Testing is grouped into two sub-tests, one testing normal behavior and one
testing exception handling. Every module interface function will have a separate
subtest in each group; the normal subtest for aFunc() will be called aFuncOkT()
and the exception handling subtest for aFunc() will be called aFuncBadT(). If
there is no exception handling performed within a module interface function, its
specific exception handling test will still exist, but will always pass. The
description accompanying the passing test in such cases will report an
appropriate message describing why there is no need for exception handling in
the function.

=head2 newOkT()

    subtest( 'newOk()' => \&newOkT );

Tests the following on the default object (C<new()> invoked with no parameters).

for= :list * Returns something.
for= :list * Returns an object of the correct class.

PARAM: N/A

RETURN: TRUE - All subtests returns true on completion.

=head2 newBadT()

    subtest( 'newBad()' => \&newBadT );

Tests the following errors:

    ^Some::Thing::new was called incorrectly. It is a class method.

Fatal on an invocation that passes no 1st parameter, i.e. (<CSome::Thing::new()>)

PARAM: N/A

RETURN: TRUE - All subtests returns true on completion.

=head1 FUNCTIONS - TEST INTERNALS

These are the methods that are used to, for instance, provide data to other
tests. They are documented only for developer interest.

Note: These functions should be bog-simple. More complex helpers should be
factored out into separate test utilities

=head2 provideDefaultObj()

    my $defaultObj = provideDefaultObj();

Returns a default Some::Thing object, created without passing any parameters.
This is not really necessary, as it is just wraps C<Some::Thing->new()>, but that
allows for symmetric test syntax when using other providers. Basically this makes
it easier to write tests with clean, perfectly parallel structures.

PARAM: N/A

RETURN: $defaultObj - An object of this class created without any parameters.

=cut
