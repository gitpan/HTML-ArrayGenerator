package ArrayGenerator;

=head1 NAME

HTML::ArrayGenerator - Easy generation of a HTML array

=head1 SYNOPSIS

Here's some examples :

      use HTML::ArrayGenerator;
      
      my $gen = ArrayGenerator->new;

      # first we build the array...
      $gen->set(0, 0, title => "First");
      $gen->set(0, 1, title => "Second");
      $gen->set(1, 1, text => "first sentence", align => "center");
      # two things in same case ? then the second is on a newline 
      $gen->set(1, 1, text => "second sentence", link => "www.perldoc.com");
      $gen->set(0, 2, img => "perl.png", alt => "My favorite camel");
      $gen->set(0, 3, img => "perl.png", alt => "Always my favorite camel", link => "www.cpan.org");		
      # some complex code
      $gen->set(0, 10, code => "<td> <ul><p>first<p>second</ul> </td"); 
      
      # then we generate it...
      $gen->generate_page (\*STDOUT, title => "Title of the page", array_title => "A title...", border => 10);
      $gen->generate_array(\*STDOUT,  border => 10);

=head1 DESCRIPTION

There are three functions for generating an HTML array.

=over 4

=item ArrayGenerator::set($x, $y, %hash)

Use the set method to build your array. The first and second argument are the coordinates of a case in the array.
The third argument is a hash. Possible keys are : title, text, link, img, alt, and align.

=item ArrayGenerator::generate_array($REF_FILE_DESCRIPTOR, %hash)

Output the HTML code for your array.
The second argument is a hash. The only key is border, which set the size of the border of the HTML array.

=item ArrayGenerator::generate_page($REF_FILE_DESCRIPTOR, %hash)

Output an HTML page which contains the HTML array. The second argument is a hash. Possible keys are : title, array_title and border. Title is the title of the HTML page and array_title the title of the array.

=back

=head1 AUTHOR

Kototama <codeur(at)altern.org>

=head1 Copyright

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 


=cut

use strict;
use warnings;

use HTML::Stream;

our $VERSION = '1.0.2';



sub new {
	my $invoquant = shift;
	my $classe = ref($invoquant) || $invoquant;
	
	return bless ([], $classe);
	
}

sub set {
	my $self = shift;
	my $x = shift;
	my $y = shift;
	my %_hash;	

	%_hash = @_ ; 

	push(@{$self->[$x][$y]}, { %_hash } );	
		
}

sub generate_array {
  my $self = shift;
  my $file = shift;
  my $border = shift;

  my $array_ref;
  my $second_array_ref;
  my $hash_ref;

  if(not $border) { $border = "0"; }

  my $HTML = new HTML::Stream($file);

  $HTML->tag("table border=$border");

  for my $line (@$self) {

    $HTML->tag('tr'); 
    for my $col (@$line) {
    if(! ${$col->[0]}{'code'}) {
      # if the first element of the case a title ?
      if(   ${$col->[0]}{'title'} ) { 
      $HTML ->tag('th');
    } else {
      # align ?
      if( ${$col->[0]}{'align'} ) { $HTML->tag("td align=${$col->[0]}{'align'}"); }
    else { $HTML->tag('td'); }
  }   
}
    
    my $is_next = 0;
      for my $hash_ref (@$col) {

	# is there another text ?
	if($is_next) { $HTML->tag('br'); }

	# do we have a link ?
	if($$hash_ref{'link'}) {
	  $HTML->tag('A', 'HREF' => $$hash_ref{'link'});
	}
	
	if($$hash_ref{'title'}) { $HTML->text($$hash_ref{'title'}); }
	if($$hash_ref{'text'}) { $HTML->text($$hash_ref{'text'}); }
	if($$hash_ref{'img'}) { $HTML->tag('IMG', 'SRC' => $$hash_ref{'img'}, 'ALT' => $$hash_ref{'alt'}); }
	if($$hash_ref{'code'}) { print $file $$hash_ref{'code'}; }
	# link ?
	if($$hash_ref{'link'}) {
	  $HTML->tag('_A');
	}

	$is_next = 1;
      }
    # do we had a title ?
      if( ${$col->[0]}{'title'} )
	{ $HTML->tag('_th'); }
    else { $HTML->tag('_td'); }

  $HTML->nl;
    }
  $HTML->tag('_tr');
  }

  $HTML->tag('_table');
  
}

sub generate_page {
  my $self = shift;
  my $file = shift;

  my $HTML = new HTML::Stream($file);
  
  my %_hash = ( @_ ) ;


  $HTML->tag('html'); $HTML->nl(2);
  $HTML->tag('head'); $HTML->nl;
  $HTML->tag('center');
  $HTML->tag('title');
  $HTML->text( $_hash{'title'} );
  $HTML->tag('_title');
  $HTML->tag('_center'); $HTML->nl;
  $HTML->tag('_head'); $HTML->nl(2);

  $HTML->tag('body'); $HTML->nl(2);
  $HTML->tag('center'); $HTML->nl;
  $HTML->tag('h1');
  $HTML->text($_hash{'array_title'});
  $HTML->tag('_h1'); $HTML->nl;
  $self->generate_array($file, $_hash{'border'}); $HTML->nl;
  $HTML->tag('_center'); $HTML->nl(2);
  $HTML->tag('_body'); $HTML->nl;
  $HTML->tag('_html'); $HTML->nl;

}

1;

