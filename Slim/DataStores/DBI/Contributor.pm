package Slim::DataStores::DBI::Contributor;

# $Id: Contributor.pm,v 1.1 2004/12/17 20:33:03 dsully Exp $

use strict;
use base 'Slim::DataStores::DBI::DataModel';

{
	my $class = __PACKAGE__;

	$class->table('contributors');
	$class->columns(Essential => qw/id name namesort/);
	$class->columns(Stringify => qw/name/);
}

my @fields = qw(contributor artist composer conductor band);

tie my %_cache, 'Tie::Cache::LRU', 5000;

sub contributorFields {
	return \@fields;
}

sub searchName {
	my $class   = shift;
	my $pattern = shift;

	s/\*/%/g for @$pattern;

	my %where = ( name => $pattern, );

	$_cache{$pattern} ||= [ $class->searchPattern('contributors', \%where, ['namesort']) ];

	return wantarray ? @{$_cache{$pattern}} : $_cache{$pattern}->[0];
}

1;

__END__


# Local Variables:
# tab-width:4
# indent-tabs-mode:t
# End:
