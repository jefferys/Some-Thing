package Some::Thing;

=for :stopwords DESC PARAM github zilla perl

=cut

# ABSTRACT: Just a skeleton

=head1 SYNOPSIS

    use Some::Thing;

    # Construct a Some::Thing object instance
    my $obj = Some::Thing->new();

=cut

=head1 DESCRIPTION

Why do I exist? Who might use me? To do what?

=cut

use 5.010;
use strict;
use warnings;

# VERSION

# Errors from caller context.
use Carp;

# Declare constants.
use Readonly;

# Subroutine param checking.
use Params::Check qw[check last_error];
$Params::Check::ALLOW_UNKNOWN         = 1;
$Params::Check::PRESERVE_CASE         = 1;
$Params::Check::VERBOSE               = 0;
$Params::Check::SANITY_CHECK_TEMPLATE = 0;

Readonly::Scalar my $CLASS => 'Some::Thing';

=classMethod new()

    my $obj = Some::Thing->new();

Creates and returns a Some::Thing object.

 PARAM:   N/A

 RETURNS: $obj
The newly constructed object.

 ERRORS:
Dies if not called as a class method.

=cut

sub new {

   if ( scalar @_ != 1 ) {
      croak( "$CLASS"
           . '::new was called incorrectly.'
           . ' It is a class method.' );
   }

   my $class = shift;
   my $self  = {};
   bless $self, $class;

   return $self;
}

1;

=head1 INSTALLATION

You can install the latest release of this module directly from GitHub using

   $ cpanm git://github.com/Jefferys/Some-Thing.git@release

=head2 Older Versions

Older versions can be downloaded from the archive like:

     $ cpanm git://github.com/Jefferys/Some-Thing.git@v0.0.1

but replacing the version string after the @ with the release's tag name.
Hopefully there will never be a reason to need to do that. Old releases may not
all be available forever.

=head2 Manual installation

You can also install manually by selecting and downloading the F<*.tar.gz>
package for any release on GitHub, i.e. for

=over 4

L<https://github.com/Jefferys/Some-Thing/release>

=back

Installing is then a matter of unzipping this, changing into the unzipped
directory, and then executing the normal
(L<ExtUtils::MakeMaker|ExtUtils::MakeMaker>) incantation:

     perl Build.PL
     make
     make test
     make install

after which you are free to delete both the folder and the zipped file.

=cut

=head1 BUGS AND SUPPORT

No known bugs are present in this release. Unknown bugs are a virtual
certainty. Please report bugs (and feature requests) though the
GitHub issue tracker associated with the development repository, at:

L<https://github.com/Jefferys/Some-Thing/issues>

Note: you must have a GitHub account to submit issues, but they are free.

=cut

=head1 DEVELOPMENT & CONTRIBUTION

This module is developed and hosted on GitHub, at
L<https://github.com/Jefferys/Some-Thing>. Development is done using Dist
Zilla, but releases to GitHub are made to both a `master` and a `release`
branch, with the `master` branch requiring `dzil`, while the release branch uses
only the Core perl build system (L<ExtUtils::MakeMaker|ExtUtil::MakeMaker>). All
contributions are welcome.

See F<development.md> on the development branch for more details.

=cut
