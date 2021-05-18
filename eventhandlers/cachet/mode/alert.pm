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

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;

    $options{options}->add_options(arguments => {
        'hostname:s'            => { name => 'hostname' },
        'urlpath:s'             => { name => 'urlpath', default=>, default => 'https://localhost:8000/api/v1/components' },
        'port:s'                => { name => 'port', default => 8000 },
        'proto:s'               => { name => 'proto', default => 'https' },
        'api_key:s'             => { name => 'api_key'},
        'name:s'                => { name=> 'name' } ,
		'message:s'             => { name=> 'message' } ,
		'status:s'              => { name=> 'status' },
		'visible:s'             => { name=> 'visible' },
		'component_id:s'        => { name=> 'component_id' },
		'component_status:s'    => { name=> 'component_status' },
		'notify:s'              => { name=> 'notify' },
    });

    $self->{http} = centreon::plugins::http->new(%options);
    return $self;
}


        