# Development and contributions

This module is developed and hosted on GitHub, at
https://github.com/Jefferys/<Module-Name>. Development is done using
`Dist::Zilla` on the `master` branch but releases are made to a separate `cpan`
branch that uses only the core perl build system (`ExtUtil::MakeMaker`). The
releases available from github as zip/tar files are the CPAN releases, not the
development project (`master` branch) used to create them. If you are just
*using* the module, you only care about the `cpan` branch, and probably
shouldn't be wasting your time reading this. The README from the `cpan` branch
describes how to install this module directly from the github repository or how
to build and install manually from a downloaded github release.

If you want to contribute to this project, it is much easier for me to accept
pull requests targeting the development "master" branch, although you don't need
to; if you just have a small or isolated change, it doesn't matter. I am
unfamiliar with using CPAN for shared development, and only really want one
place for the *development* project to live. Also, `Dist::Zilla` is the build tool
for a lot of perl modules, so if you are a developer interested in contributing
in general, you should bite the bullet and go ahead and install it. There is a
large learning curve required to setting up your own `Dist::Zilla` build/test
workflow, but this project already has that. You can just fork this project to
play with, set up some configuration on your side that `Dist::Zilla` needs,
and follow the build workflow and conventions described in the following.

Dist::Zilla configuration
-------------------------

   TODO!

Development workflow
--------------------

Distributions are build by running `dzil` in the top development project
directory, which must contain `dist.ini` file. That along with some perl code
files, perl test files, and other file system resources laid out in a standard
way can be used to build and test a CPAN distribution. The `dist.ini` file
provides `dzil` with the instructions and data needed to build that
distribution, it is the "project" file for a perl CPAN module project managed by
`dzil`.

Dzil is a *developer* tool. Users install CPAN distributions without using
dzil, and the `dist.ini` file should not be in CPAN distributions. That said,
the development project for the module is often hosted on github, and it would
be nice to be able to install directly from github (as allowed by `cpanm`).
Either there must be a second branch on github containing just the
distribution, or the development directory must also qualify as a CPAN
directory. The latter is convenient but blurs a "separation of concerns"
issue. I choose to maintain two separate branches. Unfortunately I can't
completely isolate the `cpan` branch from development code due to the (historic)
role for CPAN as simultaneously the repository for user-downloadable modules and
for developer projects, and the way that Dist::Zilla runs tests (from within)
the built distribution. What developer code does wind up in the CPAN
distribution should be relegated to `xt/author` and `xt/release` directories,
which are common in CPAN distributions and are explicitly something a
user is not supposed to run. (Start Rant) So why are we required to download
and keep them on our systems? (End Rant)

Using the associated dist.ini file, this project supports a development cycle
that looks like:

1. Get your own copy of the project

 ```
 # Fork the github repository
 # Clone locally to your system for working
 ```

2. Test your development environment

  ```
  cd <Module-Name>
  dzil build
  dzil test
  # You may need to install developer dependencies.
  ```

3. Create a new branch for the feature or bug fix

  ```
  git checkout -b new_feature_branch
  ```

4. Develop something

  ```
  # Write code & tests
  dzil build
  dzil test
  # OK?
  # Ensure Changes file is up to date
  git commit
  # Repeat from ""# Write code & tests" done
  ```

5. Ensure high quality code, then merge back into master to share

  ```
  dzil build
  dzil test --all                # If anything fails, fix it.
  dzil cover                     # OK else add more tests.
  git status                     # Nothing should be uncommitted.
  git checkout master
  git merge new_feature_branch   # Merge errors? Fix them!
  git commit
  git branch -d new_feature_branch # Don't pollute the public branch namespace
  git push origin master         # Share the master distribution
  ```

6. Repeat 3, 4, and 5 until have all the features or bug fixes needed for
a new release, possibly only want one pass.

  If you want to make your new module version available from your fork, you can do your own release.

7. Release new version

  ```
  # Verify Changes file is correct!
  dzil build      # To be sure
  dzil test --all # To be sure
  dzil cover      # To be sure
  dzil release    # YES, you want to release!
  ```

Names and Variables
-------------------

### Scalar variable names

I use camel case, starting with lower case. I try to use nouns: `$age`, `$firstName`

### Hash and array variable names

I use camel case, starting with lower case. I try to use plural nouns: `%params`,
`@daysOfTheWeek`

### Reference variable names

I use came case, starting with lower case and ending with HR for hash-refs,
AR for array-refs, and SR for scalar ref. I try to use nouns, and in general
use plurals for HR and AR, singular for SR. `$paramsHR`, `$listAR`,
`$bigTextBlockSR`. The terminal tag, reminiscent of "Hungarian notation", helps
me in the same way the `@` and `%` sigils do.

### Hash keys

I use camelCase, starting with lower case. I enclose keys in single quotes, but
don't use any keys that are not valid variable names. I make exceptions when the
keys are clearly something else (objects, the strings in a text segment, a
duplicate check mechanism, checksums, uuids, etc).

### Constants

If a variable is used as constant, I use all capital SNAKE_CASE: `$PI`,
`$COLOR_RGB_HR`

### Packages and distributions

I use capitalized CamelCase for package names, like: GetOpt::Long.

I name distributions identically to packages, except in spinal-case, like:
`GetOpt-Long`.

### Subroutines

I name subroutines like scalar variables, in camelCase starting with
lower case. I try to use verbs: doSomething. I never use the & sigil, except
when using a reference to a subroutine: `\&someSubName`.

Rarely, I may need to pass a subroutine reference in a scalar variable (e.g.
when supply a subroutine to use for sorting, for example.). I still name the
variable like a subroutine, but end it in `SUB: $sortSUB, $errorTraceFormatSUB`.

### Get/set methods

I use the name of the field being changed as the method name. Without a param,
returns the current value of the field. With a value sets that as the new value
of the field, and returns the old value.

The advantage over separate get* and set* methods is the field name is exactly
used, without capitalization issues, and all the code is in one function instead
of two. The only drawback is the inability to set a field to an undefined
value. When needed, I create a separate setter called 'fieldNameClear' which
sets the field to undefined, or its original value, and returns the old value.
This is rarely needed, and its presence in the class API draws attention to the
fact that undefined field values are meaningful.


Subroutine parameters
---------------------

### Positional parameters

I use positional parameters if a parameter has 0 or 1 parameter, and often if
it has 2 parameters. With 3 or more parameters, or if have 2 or more parameters
and one or more is optional, I use named parameters.

### Named parameters

I use named parameters if a subroutine has 3 or more parameters, or if it
has 2 or more parameters and any are optional. An exception is made if there
is a clear convention for ordering the parameters, like x,y,z points. If it is
not clear which order the parameters for a 2 parameter function should go in,
I might use named parameters even here, but not usually. Although I always have
to look up the parameter names when writing code, but reading cade after the
fact is MUCH easier with named parameters.

I allow and retain extra (unused) parameters to support backwards-compatible
(additive) changes.

I use case-sensitive parameter names to support use of camel case keys.

### Parameter validation

I validate parameters only for externally called subroutines.

I use `Params::Check` for validation with named parameters. This is in the
core and does not require xs as does `Params::Validate`. With very complex
interdependent parameters, I might use GetOpt::Long as a possible alternative to
Params::Validate. I will use `Params::Validate` only if I both have a complex
parameter set and a need for speed. That hasn't happened yet.

For positional parameters, I use manual parameter validation. If there is just
one positional parameter, a hash-ref, that is essentially the same as using
named parameters and can be validated with `Params::Check`.

### Variable parameters / pass by reference parameters.

Generally, when parameters are passed to a function, their top-level values are
copied, using something like $someVar = shift; for a single param,
`($someVar, $anotherVar) = @_`; for positional params, and `%params = @_` for named
params. This prevents a subroutine from accidentally modifying these values.
However, copying large values is costly, so if my data is large, I
will pass it as a reference so it doesn't get copied. Like all references, the
*reference* is copied, but not its contents. This has the drawback of leaving
the contents open to change, but this is the same as with all structures and
object, so being careful not to modify internals (should) be second-nature.

A reference to `@_` directly, like `$_[0]`, will actually modify the parameters in
the context of the caller. This is opaque and uncommon, so I almost always use
an extra layer and modify the content of a passed in referenced object or
structure, with comments describing the intent. Note: I don't comments about
modifying internals in mutator methods as that is their whole intent.


Testing
-------

### filenames

I name all test files ".t". Test files run by users at installation are put in
the t/ directory of the distribution. Test files to be run only by
authors or developers go in the xt/ directory of the distribution in the
development repository. These are not needed by users and are *not* copied into
the distro.

(Rant follows...)

This is a more rigorous separation of concerns than is usually maintained with
perl distributions. With the prevalence of github and similar source
repositories taking up the load of supporting scm histories, it no longer makes
sense for CPAN to be used as a "development repository without history". It
still has a critical role as a centralized module source, and still needs
extensive meta-data provided to describe a distro and where to find the
development repository. The presence of xt directories in install tarballs is
an un-needed historic artifact. It is unfortunate that build tools such as dzil
appear unable to do this easily.
