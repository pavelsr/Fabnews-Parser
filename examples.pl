use Data::Dumper;
use feature 'say';
use Text::CSV;
use lib './lib';

use Fabnewsru::Parser;
use Fabnewsru::Geo qw(yandex_geocoder);
use DateTime::Format::MySQL;

my $fabnews = Fabnewsru::Parser->new();
use utf8;

# my $filename = 'test.csv';
# my $csv = Text::CSV->new() or die "Cannot use CSV: ".Text::CSV->error_diag ();
# open my $fh, "<:encoding(utf8)", $filename or die "test.csv: $!";


### WAY 1, using get_paginate_numbers

# way1();

sub way1 {

	my $pages_total = $fabnews->get_paginate_numbers("http://fabnews.ru/fablabs/");

	say "total pages: ".$pages_total;
		
	for my $i (1.. $pages_total) { # $i = iterator by page (needed for verbose output only, you can visually check correctness)

		my $url = 'http://fabnews.ru/fablabs/list/:all/page'.$i.'/';
		my $labs_at_page = $fabnews->parse_labs_list($url);   # return an arrayref containing hashes
		say "page ".$i. ": ".$url.", total rows: ".@$labs_at_page;
		
		for my $j (0... scalar @$labs_at_page - 1) {   # $j = iterator by table rows with labs data (needed for verbose output only)

			my $lab_data = $fabnews->get_lab_by_page_and_tr({ page => $i, tr => $j, validate => 0, make_geocoding => 1 });
			say "name:".$lab_data->{name}.",location:".$lab_data->{location}." (".$lab_data->{longlat}.")";

		}

	}

}


### WAY 2, using get_paginated_urls. In theory must be faster cause it doesn't have pages counter

# Also more flexible, cause yandex_geocoder isn't included at $fabnews->parse_lab

warn yandex_geocoder('Москва');


# way2();

sub way2 {

	my $urls = $fabnews->get_paginated_urls("http://fabnews.ru/fablabs/");  # rerurn arrayref

	say "total pages: ".scalar @$urls;

	for (my $i=0; $i < scalar @$urls; $i++) {   # $i = particular url (needed for verbose output only)

		my $url = $urls->[$i];
		my $labs_at_page = $fabnews->parse_labs_list($url); # return an arrayref containing hashes
		say $url.", total rows: ".@$labs_at_page;

		for my $lab (@$labs_at_page) {   # $j = lab item (hash)
			# $lab->{url} url of lab at fabnews.ru
			my $lab_more_details = $fabnews->parse_lab($lab->{url});
			my $lab_data = {};
			%$lab_data = (%$lab, %$lab_more_details);
			$lab_data->{longlat} = yandex_geocoder($lab_more_details->{location});  # you can comment it if you don't need geocoding
			# my @l = sort { $a<=>$b } keys %$lab_data ;
			# warn Dumper \@l;
			say "name:".$lab_data->{name}.",location:".$lab_data->{location}." (".$lab_data->{longlat}.")";
 		}
 	}
}