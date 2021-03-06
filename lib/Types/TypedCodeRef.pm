package Types::TypedCodeRef;
use 5.010001;
use strict;
use warnings;
use utf8;

our $VERSION = "0.05";

use Type::Library (
  -base,
  -declare => qw( TypedCodeRef ),
);

use Types::TypedCodeRef::Factory;

{
  my $factory =
    Types::TypedCodeRef::Factory->new(sub_meta_finders => [\&get_sub_meta_from_sub_wrap_in_type]);
  __PACKAGE__->add_type($factory->create());
}

sub get_sub_meta_from_sub_wrap_in_type {
  my $typed_code_ref = shift;
  if ( Scalar::Util::blessed($typed_code_ref) && $typed_code_ref->isa('Sub::WrapInType') ) {
    return Sub::Meta->new(
      args    => $typed_code_ref->params,
      returns => $typed_code_ref->returns,
    );
  }
  return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf-8

=head1 NAME

Types::TypedCodeRef - Type constraint for any typed subroutine.

=head1 SYNOPSIS

    use Test2::V0;
    use Types::TypedCodeRef -types;
    use Types::Standard -types;
    use Sub::WrapInType qw( wrap_sub );
    
    my $type = TypedCodeRef[ [Int, Int] => Int ];
    ok $type->check(wrap_sub [Int, Int] => Int, sub { $_[0] + $_[1] });
    ok !$type->check(0);
    ok !$type->check([]);
    ok !$type->check(sub {});

=head1 DESCRIPTION

Types::TypedCodeRef is type constraint for any typed subroutine (example, generated by Sub::WrapInType).

=head1 TYPES

=head2 TypedCodeRef[`p, `r]

Only accepts typed subroutines.
A typed subroutine is a code reference in which the type of the parameter and the type of the return value are defined.
Types::TypedCodeRef is designed to inspect typed subroutines generated by Sub::WrapInType, but it is extensible enough to inspect typed subroutines created in other ways as well.

The first type parameter is the subroutine parameters type, and the second type parameter is the subroutine return values type.

=head1 LICENSE

Copyright (C) ybrliiu.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ybrliiu E<lt>raian@reeshome.orgE<gt>

=head1 SEE ALSO

L<Sub::WrapInType>

L<Type::Tiny>

=cut

