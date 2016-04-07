use strict;
use warnings;
use Test::More;
use Captcha::reCAPTCHA;

my $pubkey = '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI';


my $captcha = undef;
ok $captcha = T::Captcha::reCAPTCHA->new(), "new Cpatcha::reCAPTCHA Created OK";
isa_ok $captcha, 'Captcha::reCAPTCHA';

BEGIN {
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
      # This test is to make sure that the provided arguments are still passed in
      name => 'Error in hash',
      line => __LINE__,
      args =>
       [ $pubkey, { is_valid => 0, error => '<<some random error>>' } ],
      expect =>
       qq{<script src="https://www.google.com/recaptcha/api.js" async defer></script>}
       . qq{<div class="g-recaptcha" data-sitekey="$pubkey" }
       .qq{error="&lt;&lt;some random error&gt;&gt;" is_valid="0"></div>\n}
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
       . qq{<div class="g-recaptcha" data-sitekey="$pubkey" }
       . qq{data-tabindex="3" data-theme="dark"></div>\n}
    }
  );
}

package main;
  for my $test ( @schedule ) {
    my $name = $test->{name};
    my $captcha = undef;
    ok $captcha = T::Captcha::reCAPTCHA->new(), "$name: Created OK at line " . $test->{line};
    isa_ok $captcha, 'Captcha::reCAPTCHA';
    my $args = $test->{args};
    my $html = $captcha->get_html_v2( @$args );
    is $html, $test->{expect}, "$name: Generate HTML OK at line "  . $test->{line};
  }

  note "Check out options setter div works";
  $captcha = undef;
  ok $captcha = T::Captcha::reCAPTCHA->new(), "$captcha: Created OK";
  eval {
    $captcha->get_options_setter_div($pubkey, 'non hash args');
  };

1;


done_testing();
