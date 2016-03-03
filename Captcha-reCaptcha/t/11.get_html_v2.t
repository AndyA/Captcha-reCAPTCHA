use strict;
use warnings;
use Test::More;
use Captcha::reCAPTCHA;

my $pubkey = '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI';

note "create captcha object";
ok my $captcha = Captcha::reCAPTCHA->new(), "new Cpatcha::reCAPTCHA Created OK";
isa_ok $captcha, 'Captcha::reCAPTCHA';

my @schedule = (
{
  name => 'Simple',
  line => __LINE__,
  args => [$pubkey],
  expect =>
  qq{<script src="https://www.google.com/recaptcha/api.js" async defer></script>} .
    qq{<div class="g-recaptcha" data-sitekey="$pubkey"></div>\n}
},
{
    name => 'Error',
    line => __LINE__,
    args => [ $pubkey, '<<some random error>>' ],
    expect => qq{<script src="https://www.google.com/recaptcha/api.js" async defer></script>}
        . qq{<div class="g-recaptcha" data-sitekey="$pubkey"></div>\n}
  },
  {
    # This test is to make sure that the provided arguments are still passed in
    name => 'Error in hash',
    line => __LINE__,
    args =>
     [ $pubkey, { is_valid => 0, error => '<<some random error>>' } ],
    expect =>
     qq{<script src="https://www.google.com/recaptcha/api.js" async defer></script>}
     . qq{<div class="g-recaptcha" data-sitekey="$pubkey"></div>\n}
  },
  {
    name => 'Secure',
    line => __LINE__,
    args => [ $pubkey, undef ],
    expect =>
     qq{<script src="https://www.google.com/recaptcha/api.js" async defer></script>}
     . qq{<div class="g-recaptcha" data-sitekey="$pubkey"></div>\n}
  },
  {
    name => 'Options',
    line => __LINE__,
    args =>
     [ $pubkey, { 'data-theme' => 'dark', 'data-tabindex' => 3 } ],
    expect =>
     qq{<script src="https://www.google.com/recaptcha/api.js" async defer></script>}
     . qq{<div class="g-recaptcha" data-sitekey="$pubkey"></div>\n}
  }
);


for my $test ( @schedule ) {
  my $name = $test->{name};
  ok my $captcha = Captcha::reCAPTCHA->new(), "$name: Created OK at line " . $test->{line};
  isa_ok $captcha, 'Captcha::reCAPTCHA';
  my $args = $test->{args};
  my $html = $captcha->get_html_v2( @$args );
  is $html, $test->{expect}, "$name: Generate HTML OK at line "  . $test->{line};
}

done_testing();
