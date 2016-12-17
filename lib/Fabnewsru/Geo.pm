package Fabnewsru::Geo;

# ABSTRACT: Functions for make geocoding

=head1 SYNOPSIS

    use Fabnewsru::Geo qw(yandex_geocoder);
    my $longlat = yandex_geocoder('Россия, Заречный (Пензенская обл.), ул. Конституции СССР, д.39А'); # '45.16511 53.199109'

=cut

use warnings;
# use Devel::Peek;

use Exporter qw(import);
our @EXPORT_OK = qw(yandex_geocoder);


=method yandex_geocoder

Make geocoding via Yandex Maps API (get longitude, latitude by specified address)

For documentation take a look at  https://tech.yandex.ru/maps/geocoder/

Free limit is 25000 queries per day, if limit was reached there will be HTTP 429 code

Will return string like '45.16511 53.199109', order is longlat (longitude, latitude)

=cut


sub yandex_geocoder {
	my $address = shift;
	utf8::decode($address);   # set UTF8 flag if address string is cyrillic (need for correct Mojo::Dom working)
	# Dump $address;
	my $base_url='https://geocode-maps.yandex.ru/1.x/?format=json&geocode=';
	my $ua = Mojo::UserAgent->new;
	my $longlat = $ua->get($base_url . $address)->res->json->{response}->{GeoObjectCollection}->{featureMember}->[0]->{GeoObject}->{Point}->{pos};
	return $longlat;  # longitude, latitude
}
