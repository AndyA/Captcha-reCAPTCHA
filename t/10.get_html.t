use strict;
use warnings;
use Test::More;
use Captcha::reCAPTCHA;

# Looks real. Isn't.
use constant PUBKEY => '6LdAAAkAwAAAFJj6ACG3Wlix_GuQJMNGjMQnw5UY';

my @schedule;

BEGIN {
    my $pubkey = PUBKEY;

    @schedule = (
        {
            name => 'Simple',
            args => [$pubkey],
            expect =>
              qq{<script src="http://api.recaptcha.net/challenge?k=$pubkey" }
              . qq{type="text/javascript"></script>\n}
              . qq{<noscript><iframe frameborder="0" height="300" }
              . qq{src="http://api.recaptcha.net/noscript?k=$pubkey" }
              . qq{width="500"></iframe><textarea cols="40" name="recaptcha_challenge_field" }
              . qq{rows="3"></textarea><input name="recaptcha_response_field" type="hidden" }
              . qq{value="manual_challenge" /></noscript>\n}
        },
        {
            name => 'Error',
            args => [ $pubkey, '<<some random error>>' ],
            expect =>
              qq{<script src="http://api.recaptcha.net/challenge?error=%3c%3csome+random+error%3e%3e&amp;k=$pubkey" }
              . qq{type="text/javascript"></script>\n}
              . qq{<noscript><iframe frameborder="0" height="300" }
              . qq{src="http://api.recaptcha.net/noscript?error=%3c%3csome+random+error%3e%3e&amp;k=$pubkey" }
              . qq{width="500"></iframe><textarea cols="40" name="recaptcha_challenge_field" }
              . qq{rows="3"></textarea><input name="recaptcha_response_field" type="hidden" }
              . qq{value="manual_challenge" /></noscript>\n}
        },
        {
            name => 'Error in hash',
            args =>
              [ $pubkey, { is_valid => 0, error => '<<some random error>>' } ],
            expect =>
              qq{<script src="http://api.recaptcha.net/challenge?error=%3c%3csome+random+error%3e%3e&amp;k=$pubkey" }
              . qq{type="text/javascript"></script>\n}
              . qq{<noscript><iframe frameborder="0" height="300" }
              . qq{src="http://api.recaptcha.net/noscript?error=%3c%3csome+random+error%3e%3e&amp;k=$pubkey" }
              . qq{width="500"></iframe><textarea cols="40" name="recaptcha_challenge_field" }
              . qq{rows="3"></textarea><input name="recaptcha_response_field" type="hidden" }
              . qq{value="manual_challenge" /></noscript>\n}
        },
        {
            name => 'Secure',
            args => [ $pubkey, undef, 1 ],
            expect =>
              qq{<script src="https://api-secure.recaptcha.net/challenge?k=$pubkey" }
              . qq{type="text/javascript"></script>\n}
              . qq{<noscript><iframe frameborder="0" height="300" }
              . qq{src="https://api-secure.recaptcha.net/noscript?k=$pubkey" }
              . qq{width="500"></iframe><textarea cols="40" name="recaptcha_challenge_field" }
              . qq{rows="3"></textarea><input name="recaptcha_response_field" type="hidden" }
              . qq{value="manual_challenge" /></noscript>\n}
        },
        {
            name => 'Options',
            args => [ $pubkey, undef, 0, { theme => 'white', tabindex => 3 } ],
            expect =>
              qq(<script type="text/javascript">\n//<![CDATA[\nvar RecaptchaOptions = )
              . qq({"tabindex":3,"theme":"white"};\n//]]>\n</script>\n)
              . qq{<script src="http://api.recaptcha.net/challenge?k=$pubkey" }
              . qq{type="text/javascript"></script>\n}
              . qq{<noscript><iframe frameborder="0" height="300" }
              . qq{src="http://api.recaptcha.net/noscript?k=$pubkey" }
              . qq{width="500"></iframe><textarea cols="40" name="recaptcha_challenge_field" }
              . qq{rows="3"></textarea><input name="recaptcha_response_field" type="hidden" }
              . qq{value="manual_challenge" /></noscript>\n}
        },
    );
    plan tests => 3 * @schedule;
}

for my $test ( @schedule ) {
    my $name = $test->{name};
    ok my $captcha = Captcha::reCAPTCHA->new(), "$name: Created OK";
    isa_ok $captcha, 'Captcha::reCAPTCHA';
    my $args = $test->{args};
    my $html = $captcha->get_html( @$args );
    is $html, $test->{expect}, "$name: Generate HTML OK";
}
