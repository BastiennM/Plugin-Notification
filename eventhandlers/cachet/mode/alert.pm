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
use Encode qw(encode decode);

my $enc = 'utf-8';

my %cachet_status = (
    0 => 1,
    1 => 2,
    2 => 3,
    3 => 4
);

my %cachet_message = (
    "fr" => {
        1 => {
            name => "Le service fonctionne normalement",
            message => "Aucun problèmes détectés"
            },
        2 => {
            name => "Problème de performances",
            message =>"Nous rencontrons quelques problèmes de performances"
        },
        3 => {
            name =>"Panne partielle",
            message =>"Une panne partielle à été détectée, nos équipes sont averti et travaillent à le régler"
        },
        4 => {
            name=>"Panne majeure",
            message=>"Une panne majeur à été détectée, nos équipes sont averti et travaillent à le régler"
        }
    },
    "en" => {
        1 => {
            name => "Service is operating normally",
            message => "No problems detected"
            },
        2 => {
            name => "Performance issue",
            message =>"We're running into some performance issues"
        },
        3 => {
            name =>"Partial failure",
            message =>"A partial failure has been detected, our teams are notified and working to fix it"
        },
        4 => {
            name=>"Major Failure",
            message=>"A major failure has been detected, our teams are notified and working to fix it"
        }
    }
);

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
        'name:s'                => { name=> 'name'} ,
		'message:s'             => { name=> 'message'} ,
        'status:s'              => { name=> 'status' , default => 1},
		'visible:s'             => { name=> 'visible', default => 'true' },
        'component-id:s'        => { name=> 'component_id' },
		'component-status:s'    => { name=> 'component_status' },
        'language:s'            => { name=> 'language' , default=>'fr'},
        'state:s'               => { name=> 'state'},
        'only-hard:s'            => { name=> 'only_hard', default=> 0},
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
    if (($self->{option_results}->{component_status}) <0 || ($self->{option_results}->{component_status}) > 3) {
        $self->{output}->add_option_msg(short_msg => "You need to set --component_status between 0 and 3");
        $self->{output}->option_exit();
    }
    if (($self->{option_results}->{status})<1 || ($self->{option_results}->{status})>4) {
        $self->{output}->add_option_msg(short_msg => "You need to set --status between 1 and 4");
        $self->{output}->option_exit();
    }
    if (($self->{option_results}->{state}) ne "HARD" && ($self->{option_results}->{state}) ne "SOFT") {
        $self->{output}->add_option_msg(short_msg => "You need to set --state option with HARD or SOFT");
        $self->{output}->option_exit();
    }
    if (($self->{option_results}->{only_hard}) ne "true") {
        $self->{output}->add_option_msg(short_msg => "You need to set --only-har option with true");
        $self->{output}->option_exit();
    }
    if (!defined($self->{option_results}->{state})) {
        $self->{output}->add_option_msg(short_msg => "You need to set --state option");
        $self->{output}->option_exit();
    }
    $self->{http}->set_options(%{$self->{option_results}});
}

sub cachet_statusupdate{
    my ($self, %options) = @_;

        if (defined($self->{option_results}->{component_status}) && $self->{option_results}->{component_status} ne '') {
            if (defined($cachet_status{lc($self->{option_results}->{component_status})})) {
                $self->{option_results}->{component_status} = $cachet_status{lc($self->{option_results}->{component_status})};
            }
        }
}

sub bool{
    my ($self, %options) = @_;

    if($self->{option_results}->{only_hard}){
        if($self->{option_results}->{state} eq "SOFT"){
            exit;
        }
    }
}

sub cachet_message{
    my ($self, %options) = @_;

    if (!defined($self->{option_results}->{name})){
        if (defined($self->{option_results}->{language}) && $self->{option_results}->{language} ne '') {
            if (defined($cachet_message{lc($self->{option_results}->{language})})) {
                $self->{option_results}->{name} = decode($enc,$cachet_message{lc($self->{option_results}->{language})}{$self->{option_results}->{component_status}}{name});
            }
        }
    }
    if (!defined($self->{option_results}->{message})){
        if (defined($self->{option_results}->{language}) && $self->{option_results}->{language} ne '') {
            if (defined($cachet_message{lc($self->{option_results}->{language})})) {
                $self->{option_results}->{message} = decode($enc,$cachet_message{lc($self->{option_results}->{language})}{$self->{option_results}->{component_status}}{message});
            }
        }
    }
}

sub run {
    my ($self, %options) = @_;

    $self->cachet_statusupdate();
    $self->cachet_message();
    $self->bool();

    my $url = $self->{option_results}->{urlpath} . "api/v1/incidents";

    $self->{http}->add_header(key => 'Content-Type', value => 'application/json');
    $self->{http}->add_header(key => 'X-Cachet-Token', value => $self->{option_results}->{api_key});

    my $data = {name => $self->{option_results}->{name}, message => $self->{option_results}->{message}, status => $self->{option_results}->{status}, visible => $self->{option_results}->{visible}, component_id => $self->{option_results}->{component_id}, component_status => $self->{option_results}->{component_status}};
    my $encoded_data = encode_json($data);
    my $response = $self->{http}->request(url_path => $url,
    method => 'POST', query_form_post => $encoded_data);
}

1;


__END__

=head1 MODE

Send alert to cachethq components
=over 6

=item B<--api-key>

Cachet API key 
Check user profile to get it

=item B<--hostname>

Hostname of the cachet

=item B<--urlpath>

Path to add to the hostname (by default "/")

=item B<--port>

Port of the cachet component (by default 8000)

=item B<--proto>

Protocol to be used (by default https)

=item B<--component-id>

ID of your compononent
Check the component page to get it in the URL

=item B<--component-status>

Status of your component

It can be : 

1 -> Operational
2 -> Performance Problem
3 -> Partial failure
4 -> Major Failure

=item B<--status>

Status of the incident

It can be : 

1 -> Investigation in progress
2 -> Identified
3 -> Under Surveillance
4 -> Corrected

=item B<--name>

Name of the incident

=item B<--message>

A message (supporting Markdown) to explain more

=item B<--visible>

Whether the incident is publicly visible (true by default)

=item B<--language>

Language in wich will be displayed the message (french by default)

=item B<--state>

State of the service, it can be SOFT or HARD

=item B<--only-hard>

Notify cachet only if the state is HARD

=back

=cut









        