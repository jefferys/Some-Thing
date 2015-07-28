#! /usr/bin/env perl

use strict;
use warnings;
use 5.010;

# PODNAME: t/pod-syntax.t

# ABSTRACT: Checks that pod is correctly formed.

our $VERSION = '0.0.2'; # VERSION

#pod =head1 SYNOPSIS
#pod
#pod     # Run just this test
#pod     # cd <some built distribution version directory>
#pod     prove -lr t/pod-syntax.t
#pod
#pod     # Run all tests
#pod     # cd <developer distribution directory>
#pod     dzil test
#pod
#pod =head1 DESCRIPTION
#pod
#pod Pod represents part of a module's interface, its communication to the user about
#pod how to use it. The minimum we can require of a module author is not to produce
#pod invalid pod.
#pod
#pod Based on the test auto-generated by
#pod L<Dist::Zilla::Plugin::PodSyntaxTests|Dist::Zilla::Plugin::PodSyntaxTests>, this
#pod is essentially just a wrapper around
#pod L<Test::Pod::all_pod_files_ok()|Test::Pod/all_pod_files_ok( [@entries] )>. It
#pod finds files by looking at all the files in the F<bin/>, F<lib/>, F<t/>, and
#pod F<xt/> directories of the distribution and selecting appropriate files to check
#pod pod in. That will be
#pod
#pod =for :list * Skipping any files in F<CVS/>, F<.svn/>, F<.git/> and similar directories.
#pod
#pod =for :list * Any file that ends in F<*.PL>, F<*.pl>, F<*.PL>, F<*.pm>, F<*.pod>, or F<*.t>.
#pod
#pod =for :list * Any file that has a first line with a shebang and "perl" on it.
#pod
#pod =for :list * Any file that ends in F<*.bat> and has a first line with "--*-Perl-*--" on it.
#pod
#pod There is no comparable L<Perl::Critic|Perl::Critic> policy that I am aware of.
#pod
#pod Often pod checking is relegated to author-only tests, but if pod generation
#pod fails on the user's system, they don't have this important component of the
#pod module's interface available. Unfortunately this adds a user dependency of
#pod L<Test::Pod|Test::Pod>.
#pod
#pod =cut

# For version calcualtions
use version 0.77;

# For interpolated constants
use Readonly;

# Test harness interface, we are only running the one test.
use Test::More 0.96 tests => 1;

# Need to know if have Test::Pod 1.41 or greater. Will skip this test if don't.
# Requiring modules with set versions is harder than with 'use'.
Readonly my $WANT_TEST_POD_VERSION => 1.41;

my $isFound = eval {

   # Implements the actual pod syntax testing.
   require Test::Pod;
   1;
};
if ($isFound) {
   $isFound = ( version->new( Test::Pod->VERSION ) >=
        version->new($WANT_TEST_POD_VERSION) );
}

#pod =head1 TESTS
#pod
#pod =head2 Calling Test::Pod::all_vars_ok()
#pod
#pod Checks the syntax of all pod-containing files in the distributions F<lib/>,
#pod F<t/>, F<xt/>, and F<bin/> directories, if they exist. Skips testing anything
#pod if didn't find the required version of L<Test::Pod|Test::Pod>.
#pod
#pod =cut

SKIP: {
   if ( ! $isFound ) {
      my $context = 'Skipping 1 of 1.';
      my $message = "Test::Pod $WANT_TEST_POD_VERSION+ required.";
      diag("$context $message");
      skip( $message, 1 );
   }

   Test::Pod->import();

   subtest(
      'All files have valid pod syntax?' => sub {
         my @dirs;
         if ( -d 'lib' ) { push( @dirs, 'lib' ); }
         if ( -d 't' )   { push( @dirs, 't' ); }
         if ( -d 'xt' )  { push( @dirs, 'xt' ); }
         if ( -d 'bin' ) { push( @dirs, 'bin' ); }

         all_pod_files_ok(@dirs);
      }
   );
}

__END__

=pod

=encoding UTF-8

=for :stopwords Stuart R. Jefferys

=head1 NAME

t/pod-syntax.t - Checks that pod is correctly formed.

=head1 VERSION

version 0.0.2

=head1 SYNOPSIS

    # Run just this test
    # cd <some built distribution version directory>
    prove -lr t/pod-syntax.t

    # Run all tests
    # cd <developer distribution directory>
    dzil test

=head1 DESCRIPTION

Pod represents part of a module's interface, its communication to the user about
how to use it. The minimum we can require of a module author is not to produce
invalid pod.

Based on the test auto-generated by
L<Dist::Zilla::Plugin::PodSyntaxTests|Dist::Zilla::Plugin::PodSyntaxTests>, this
is essentially just a wrapper around
L<Test::Pod::all_pod_files_ok()|Test::Pod/all_pod_files_ok( [@entries] )>. It
finds files by looking at all the files in the F<bin/>, F<lib/>, F<t/>, and
F<xt/> directories of the distribution and selecting appropriate files to check
pod in. That will be

=for :list * Skipping any files in F<CVS/>, F<.svn/>, F<.git/> and similar directories.

=for :list * Any file that ends in F<*.PL>, F<*.pl>, F<*.PL>, F<*.pm>, F<*.pod>, or F<*.t>.

=for :list * Any file that has a first line with a shebang and "perl" on it.

=for :list * Any file that ends in F<*.bat> and has a first line with "--*-Perl-*--" on it.

There is no comparable L<Perl::Critic|Perl::Critic> policy that I am aware of.

Often pod checking is relegated to author-only tests, but if pod generation
fails on the user's system, they don't have this important component of the
module's interface available. Unfortunately this adds a user dependency of
L<Test::Pod|Test::Pod>.

=head1 TESTS

=head2 Calling Test::Pod::all_vars_ok()

Checks the syntax of all pod-containing files in the distributions F<lib/>,
F<t/>, F<xt/>, and F<bin/> directories, if they exist. Skips testing anything
if didn't find the required version of L<Test::Pod|Test::Pod>.

=cut
