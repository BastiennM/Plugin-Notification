#
# Copyright 2021 Centreon (http://www.centreon.com/)
#
# Centreon is a full-fledged industry-strength solution that meets
# the needs in IT infrastructure and application monitoring for
# service performance.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package eventhandlers::cachet::mode::alert;

use base qw(centreon::plugins::mode);

use strict;
use warnings;
use centreon::plugins::http;
use JSON::XS;
use HTTP::Request();
use Data::Dumper;

# use JSON::MaybeXS qw(encode_json);

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;

    $options{options}->add_options(arguments => {
        'hostname:s'            => { name => 'hostname' },
        'urlpath:s'             => { name => 'urlpath', default => '/' },
        'port:s'                => { name => 'port', default => 8000 },
        'proto:s'               => { name => 'proto', default => 'https' },
        'api-key:s'             => { name => 'api_key'},
        'name:s'                => { name=> 'name' } ,
		'message:s'             => { name=> 'message'} ,
        'status:s'              => { name=> 'status' },
		'visible:s'             => { name=> 'visible' },
        'component-id:s'        => { name=> 'component_id' },
		'component-status:s'    => { name=> 'component_status' },
    });

    $self->{http} = centreon::plugins::http->new(%options);
    return $self;
}

sub check_options {
    my ($self, %options) = @_;

    $self->SUPER::init(%options);
    
    if (!defined($self->{option_results}->{hostname})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --hostname option");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{api_key})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --api_key option");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{component_id})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --component_id option");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{component_status})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --component_status option");
        $self->{output}->option_exit();
    }
    if (($self->{option_results}->{component_status}) <1 && ($self->{option_results}->{component_status}) > 4) {
        $self->{output}->add_option_msg(short_msg => "You need to set --component_status between 1 and 4");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{status})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --status option");
        $self->{output}->option_exit();
    }
    if (($self->{option_results}->{status})<1 && ($self->{option_results}->{status})>4) {
        $self->{output}->add_option_msg(short_msg => "You need to set --status between 1 and 4");
        $self->{output}->option_exit();
    }
    $self->{http}->set_options(%{$self->{option_results}});
}

sub run {
    my ($self, %options) = @_;
    
    my $url = $self->{option_results}->{urlpath} . "api/v1/incidents";

    $self->{http}->add_header(key => 'Content-Type', value => 'application/json');
    $self->{http}->add_header(key => 'X-Cachet-Token', value => $self->{option_results}->{api_key});
    print('ok');
    my $data = { name => $self->{option_results}->{name}, message => $self->{option_results}->{message}, status => $self->{option_results}->{status}, visible => $self->{option_results}->{visible}, component_id => $self->{option_results}->{component_id}, component_status => $self->{option_results}->{component_status}};
    my $encoded_data = encode_json($data);
    print Dumper($encoded_data);
    my $response = $self->{http}->request(url_path => $url,
    method => 'POST', query_form_post => $encoded_data);
    print Dumper($response)
}

1;









        