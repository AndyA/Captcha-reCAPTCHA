use strict;
use warnings;
use Test::More;
use HTTP::Response;
use Captcha::reCAPTCHA;
use Data::Dumper;

use constant PRIKEY => "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe";

my @schedule;

BEGIN {
  @schedule = ({
    node => "Simple Response",
    args => [PRIKEY, ]
  });
}

is 1, 1, "done testing";

done_testing();
