use Getopt::Long;
use Data::Dumper;
use Text::CSV;
use Devel::Peek;

# File for development of new features
# Now is working on fixing https://github.com/makamaka/Text-CSV/issues/34

my %opts;

GetOptions ("length=i" => \$opts{l},    # numeric
            "f=s"   => \$opts{d},    # string
            "verbose"  => \$opts{v})   # flag
or die("Error in command line arguments\n");



warn Dumper \%opts;


my $file = "test.csv";

my $csv = Text::CSV->new({ eol => "\n" }) or die "Cannot use CSV: ".Text::CSV->error_diag ();
open my $fh, ">", $file or die "$file.csv: $!";

# my $a = [ 'a', 'b' ];


my $b = [ 'a', 'б' ];

for (@$b) {
	utf8::decode($_);
}

# my $b = [ 'a', 'b' ];



	# my $b = [
 #          Фаблаб Ангар',
 #          'Россия, Красноярск, ул. Затонская 44',
 #          '92.936537 55.979228',
 #          'http//fablab24.ru/',
 #          '3d печать, лазерная резка, гравировка',
 #          '+7 913 595 89 88',
 #          'fablab24@gmail.com',
 #          '27 Октябрь 2013',
 #          '1',
 #          '1',
 #          'Визит Ивана Бортника в фаблаб "Ангар"'
 #        ];

        # utf8::decode($a);

# Dump $b;
# Dump $b;

# warn Dumper $a;

# $csv->print($fh, $a);
$csv->print($fh, $b);

close $fh or die "$!";